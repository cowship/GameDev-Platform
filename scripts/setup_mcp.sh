#!/bin/bash
#
# GameDev-Platform에서 사용하는 MCP Server를 자동으로 등록합니다.
# Claude Code를 쓰는 팀원만 실행하면 됩니다 (게임 개발 자체에는 필수가 아닙니다).
# 여러 번 실행해도 안전합니다 (이미 등록된 서버는 건너뜁니다).
#
# 실행 환경: Windows + Git Bash
# 상세 배경은 integrations/mcp/servers.md, integrations/mcp/setup.md를 참고하세요.

echo "========================================"
echo " GameDev-Platform MCP Setup"
echo "========================================"
echo

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v claude >/dev/null 2>&1; then
    echo "❌ Claude Code CLI를 찾을 수 없습니다."
    echo "   먼저 integrations/claude/setup.md를 따라 Claude Code를 설치/로그인하세요."
    exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
    echo "❌ Node.js(npx)를 찾을 수 없습니다."
    echo "   https://nodejs.org 에서 Node.js를 설치하면 npx도 함께 설치됩니다."
    exit 1
fi

MCP_LIST="$(claude mcp list 2>/dev/null)"

is_registered() {
    echo "$MCP_LIST" | grep -qE "^$1:"
}

# 비밀정보가 필요 없는 stdio MCP 서버를 등록합니다.
add_stdio() {
    local name="$1"
    shift
    if is_registered "$name"; then
        printf "✅ %-20s 이미 등록됨 (건너뜀)\n" "$name"
        return
    fi

    printf "▶ %-20s 등록 중...\n" "$name"
    if claude mcp add "$name" -- "$@" >/dev/null 2>&1; then
        printf "✅ %-20s 등록 완료\n" "$name"
        MCP_LIST="$(claude mcp list 2>/dev/null)"
    else
        printf "❌ %-20s 등록 실패 — 'claude mcp add %s -- %s' 를 직접 실행해 에러를 확인하세요.\n" "$name" "$name" "$*"
    fi
}

echo "1) 비밀정보 없이 등록 가능한 MCP Server"
echo "----------------------------------------"
add_stdio filesystem npx -y @modelcontextprotocol/server-filesystem "$ROOT_DIR"
add_stdio sequential-thinking npx -y @modelcontextprotocol/server-sequential-thinking
add_stdio context7 npx -y @upstash/context7-mcp
echo

echo "2) GitHub MCP (Personal Access Token 필요)"
echo "----------------------------------------"
if is_registered github; then
    printf "✅ %-20s 이미 등록됨 (건너뜀)\n" "github"
else
    TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-}"
    if [ -z "$TOKEN" ]; then
        echo "GitHub Personal Access Token(Fine-grained 권장)이 아직 없다면 발급 방법은 integrations/github/setup.md 를 참고하세요."
        read -r -s -p "GitHub Personal Access Token 입력 (입력값은 화면에 표시되지 않습니다): " TOKEN
        echo
    fi

    if [ -z "$TOKEN" ]; then
        echo "❌ 토큰이 입력되지 않아 GitHub MCP 등록을 건너뜁니다. 준비되면 이 스크립트를 다시 실행하세요."
    else
        case "$TOKEN" in
            ghp_*)
                echo "⚠️  Classic 토큰(ghp_...)으로 보입니다. 이 프로젝트는 Fine-grained 토큰(github_pat_...)을 표준으로 사용합니다."
                echo "   발급 방법: integrations/github/setup.md 참고. 그대로 계속 등록을 진행합니다."
                ;;
        esac
        if claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN="$TOKEN" -- npx -y @modelcontextprotocol/server-github >/dev/null 2>&1; then
            printf "✅ %-20s 등록 완료\n" "github"
            MCP_LIST="$(claude mcp list 2>/dev/null)"
        else
            printf "❌ %-20s 등록 실패 — 토큰 권한(Contents/Issues/Pull requests/Workflows)을 확인하세요.\n" "github"
        fi
    fi
    unset TOKEN
fi
echo

echo "3) Notion MCP (수동 단계 — claude.ai 계정 연동)"
echo "----------------------------------------"
if echo "$MCP_LIST" | grep -qi "notion"; then
    echo "✅ Notion은 이미 연결되어 있습니다."
else
    echo "ℹ️  Notion은 스크립트로 등록할 수 없습니다. 'claude'로 세션을 시작한 뒤"
    echo "   Notion 관련 작업을 한 번 요청하면 최초 1회 브라우저 인증 창이 뜹니다."
fi
echo

echo "4) Unity MCP (Unity CLI 기반)"
echo "----------------------------------------"
if is_registered unity-editor-mcp; then
    printf "✅ %-20s 이미 등록됨 (건너뜀)\n" "unity-editor-mcp"
elif ! command -v unity >/dev/null 2>&1; then
    echo "ℹ️  Unity CLI(unity)를 PATH에서 찾지 못했습니다."
    printf '   Unity Hub를 한 번 실행하면 CLI가 자동 설치됩니다 (%%LOCALAPPDATA%%\\Unity\\bin\\unity.exe).\n'
    echo "   설치 후 이 스크립트를 다시 실행하거나 직접 실행하세요: unity mcp configure claude-code"
else
    printf "▶ %-20s 등록 중...\n" "unity-editor-mcp"
    if unity mcp configure claude-code >/dev/null 2>&1; then
        printf "✅ %-20s 등록 완료\n" "unity-editor-mcp"
        MCP_LIST="$(claude mcp list 2>/dev/null)"
    else
        printf "❌ %-20s 등록 실패 — 'unity mcp configure claude-code' 를 직접 실행해 에러를 확인하세요.\n" "unity-editor-mcp"
    fi
fi

# Unity CLI 스킬(Claude Code용)도 함께 설치합니다.
if command -v unity >/dev/null 2>&1; then
    if [ -d "$HOME/.claude/skills/unity-cli" ]; then
        printf "✅ %-20s 이미 설치됨 (건너뜀)\n" "unity-cli skill"
    elif unity skill install claude-code >/dev/null 2>&1; then
        printf "✅ %-20s 설치 완료\n" "unity-cli skill"
    else
        printf "ℹ️  %-20s 설치 실패 (선택 사항이라 계속 진행합니다)\n" "unity-cli skill"
    fi
fi

echo "ℹ️  Unity MCP 도구는 Unity Editor가 실행 중일 때만 응답합니다. 'unity status'로 확인하세요."
echo

echo "========================================"
echo " 최종 등록 상태"
echo "========================================"
claude mcp list
