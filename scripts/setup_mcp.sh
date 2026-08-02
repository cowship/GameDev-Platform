#!/bin/bash
#
# GameDev-Platform에서 사용하는 MCP Server를 자동으로 등록합니다.
# 여러 번 실행해도 안전합니다 (이미 등록된 서버는 건너뜁니다).
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
    echo "   ./scripts/check_environment.sh 로 설치 여부를 확인하세요."
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
        echo "GitHub Personal Access Token이 아직 없다면 발급 방법은 integrations/github/setup.md 를 참고하세요."
        read -r -s -p "GitHub Personal Access Token 입력 (입력값은 화면에 표시되지 않습니다): " TOKEN
        echo
    fi

    if [ -z "$TOKEN" ]; then
        echo "❌ 토큰이 입력되지 않아 GitHub MCP 등록을 건너뜁니다. 준비되면 이 스크립트를 다시 실행하세요."
    elif claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN="$TOKEN" -- npx -y @modelcontextprotocol/server-github >/dev/null 2>&1; then
        printf "✅ %-20s 등록 완료\n" "github"
        MCP_LIST="$(claude mcp list 2>/dev/null)"
    else
        printf "❌ %-20s 등록 실패 — 토큰 권한(repo)을 확인하세요.\n" "github"
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

echo "4) Unity MCP (수동 단계 — Unity 프로젝트 필요)"
echo "----------------------------------------"
echo "ℹ️  Unity 프로젝트를 만든 뒤 integrations/mcp/servers.md의 'Unity MCP' 절차를 따르세요."
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "⚠️  WSL 환경이 감지되었습니다. Unity Editor가 Windows에서 실행 중이라면"
    echo "   WSL Mirrored Networking(.wslconfig의 networkingMode=mirrored)이 켜져 있어야"
    echo "   WSL 안의 Claude Code가 Unity MCP에 접속할 수 있습니다. 자세한 내용은"
    echo "   integrations/mcp/servers.md의 'WSL ↔ Windows 네트워크 주의사항'을 참고하세요."
fi
echo

echo "========================================"
echo " 최종 등록 상태"
echo "========================================"
claude mcp list
