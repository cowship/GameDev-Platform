#!/bin/bash

echo
echo "========================================"
echo " GameDev-Platform Setup"
echo "========================================"
echo

echo "Running environment check & auto-install..."
echo

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/check_environment.sh"
ENV_STATUS=$?

echo
echo "Running MCP setup..."
echo

"$SCRIPT_DIR/setup_mcp.sh"
MCP_STATUS=$?

echo
echo "Running Claude Skills setup..."
echo

"$SCRIPT_DIR/setup_claude_skills.sh"
SKILLS_STATUS=$?

echo
echo "========================================"
echo " Next Steps"
echo "========================================"
echo

echo "1. Read the setup documentation:"
echo "   docs/setup/"
echo

echo "2. Configure Unity MCP (Unity 프로젝트 생성 후, ./scripts/setup_unity_workspace.sh 실행 — integrations/mcp/servers.md 참고)"
echo

if [ "$ENV_STATUS" -eq 0 ] && [ "$MCP_STATUS" -eq 0 ] && [ "$SKILLS_STATUS" -eq 0 ]; then
    echo "Setup Complete!"
else
    echo "⚠️  Setup Incomplete — 위 로그의 ❌/⚠️ 항목을 확인하고 안내된 수동 절차를 진행하세요."
    echo "   (환경 점검: $([ "$ENV_STATUS" -eq 0 ] && echo OK || echo '확인 필요'), MCP 등록: $([ "$MCP_STATUS" -eq 0 ] && echo OK || echo '확인 필요'), Skills 설치: $([ "$SKILLS_STATUS" -eq 0 ] && echo OK || echo '확인 필요'))"
fi