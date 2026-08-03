#!/bin/bash
#
# GameDev-Platform에서 사용하기로 한 외부(커뮤니티) Claude Code Skill을 자동으로 설치합니다.
# 여러 번 실행해도 안전합니다 (이미 설치된 항목은 건너뜁니다).
# 배경: integrations/mcp/servers.md, agents/unity.md의 코딩 원칙과 연계되는 Unity 전용 Skill입니다.

set -uo pipefail

echo "========================================"
echo " GameDev-Platform Claude Skills Setup"
echo "========================================"
echo

if ! command -v claude >/dev/null 2>&1; then
    echo "❌ Claude Code CLI를 찾을 수 없습니다."
    echo "   먼저 integrations/claude/setup.md를 따라 Claude Code를 설치/로그인하세요."
    exit 1
fi

# unity-coding-skills (nowsprinting): Unity 프로젝트의 Test-first workflow, 코딩 가이드라인,
# Scene 편집 등을 지원하는 Skill 모음. agents/unity.md의 원칙(유지보수성, 낮은 결합도)과
# 방향이 맞아 채택했습니다.
echo "1) unity-coding-skills (nowsprinting)"
echo "----------------------------------------"

MARKETPLACE_NAME="nowsprinting-unity-coding-skills"
PLUGIN_ID="unity-coding-skills@${MARKETPLACE_NAME}"

if claude plugin marketplace list 2>/dev/null | grep -q "$MARKETPLACE_NAME"; then
    printf "✅ marketplace %-20s 이미 등록됨 (건너뜀)\n" "$MARKETPLACE_NAME"
else
    printf "▶ marketplace %-20s 등록 중...\n" "$MARKETPLACE_NAME"
    if claude plugin marketplace add nowsprinting/unity-coding-skills >/dev/null 2>&1; then
        printf "✅ marketplace %-20s 등록 완료\n" "$MARKETPLACE_NAME"
    else
        printf "❌ marketplace %-20s 등록 실패 — 'claude plugin marketplace add nowsprinting/unity-coding-skills' 를 직접 실행해 에러를 확인하세요.\n" "$MARKETPLACE_NAME"
        exit 1
    fi
fi

if claude plugin list 2>/dev/null | grep -q "$PLUGIN_ID"; then
    printf "✅ plugin %-40s 이미 설치됨 (건너뜀)\n" "$PLUGIN_ID"
else
    printf "▶ plugin %-40s 설치 중 (project scope)...\n" "$PLUGIN_ID"
    if claude plugin install "$PLUGIN_ID" --scope project >/dev/null 2>&1; then
        printf "✅ plugin %-40s 설치 완료\n" "$PLUGIN_ID"
    else
        printf "❌ plugin %-40s 설치 실패 — 'claude plugin install %s --scope project' 를 직접 실행해 에러를 확인하세요.\n" "$PLUGIN_ID" "$PLUGIN_ID"
        exit 1
    fi
fi
echo

echo "========================================"
echo " 완료 — Claude Code 세션을 재시작하면 새 Skill이 로드됩니다."
echo "========================================"
claude plugin list
