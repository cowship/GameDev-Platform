#!/bin/bash
#
# Agent 정의 3계층(agents/*.md ↔ .claude/agents/*.md ↔ .claude/commands/*.md)
# 사이의 드리프트(이름/링크 불일치)를 점검합니다. (ADR 0001, 0002 참고)

echo "========================================"
echo " GameDev-Platform Agent Drift Check"
echo "========================================"
echo

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

# name(kebab-case) -> agents/*.md 원본 파일명
AGENT_NAMES="technical-lead pm documentation unity qa game-designer"
source_file_for() {
    case "$1" in
        technical-lead) echo "technical_lead.md" ;;
        game-designer)  echo "game_designer.md" ;;
        *)              echo "$1.md" ;;
    esac
}

fail=0

for name in $AGENT_NAMES; do
    src_file=$(source_file_for "$name")
    src="agents/${src_file}"
    adapter=".claude/agents/${name}.md"
    command=".claude/commands/${name}.md"

    echo "-- ${name} --"

    # 1. Source (agents/*.md)
    if [ ! -f "$src" ]; then
        printf "❌ %-10s source missing: %s\n" "source" "$src"
        fail=1
    else
        printf "✅ %-10s %s\n" "source" "$src"
    fi

    # 2. Adapter (.claude/agents/*.md): name frontmatter, source 링크
    if [ ! -f "$adapter" ]; then
        printf "❌ %-10s adapter missing: %s\n" "adapter" "$adapter"
        fail=1
    else
        adapter_name=$(grep -m1 '^name:' "$adapter" | sed 's/^name: *//')
        if [ "$adapter_name" != "$name" ]; then
            printf "❌ %-10s name frontmatter '%s' != '%s'\n" "adapter" "$adapter_name" "$name"
            fail=1
        elif ! grep -q "agents/${src_file}" "$adapter"; then
            printf "❌ %-10s does not link to %s\n" "adapter" "$src"
            fail=1
        else
            printf "✅ %-10s name=%s, links to %s\n" "adapter" "$adapter_name" "$src"
        fi
    fi

    # 3. Command (.claude/commands/*.md): subagent_type 일치
    if [ ! -f "$command" ]; then
        printf "❌ %-10s command missing: %s\n" "command" "$command"
        fail=1
    elif ! grep -q "subagent_type: *\"${name}\"" "$command"; then
        printf "❌ %-10s does not dispatch to subagent_type: \"%s\"\n" "command" "$name"
        fail=1
    else
        printf "✅ %-10s dispatches to subagent_type: \"%s\"\n" "command" "$name"
    fi

    echo
done

echo "========================================"
if [ "$fail" -eq 0 ]; then
    echo "✅ 3계층 모두 일치합니다."
else
    echo "❌ 드리프트가 발견되었습니다. 위 항목을 확인하세요."
fi
echo "========================================"

exit "$fail"
