#!/bin/bash

echo
echo "========================================"
echo " GameDev-Platform Setup"
echo "========================================"
echo

echo "Running environment check..."
echo

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/check_environment.sh"

echo
echo "Running MCP setup..."
echo

"$SCRIPT_DIR/setup_mcp.sh"

echo
echo "Running Claude Skills setup..."
echo

"$SCRIPT_DIR/setup_claude_skills.sh"

echo
echo "========================================"
echo " Next Steps"
echo "========================================"
echo

echo "1. Read the setup documentation:"
echo "   docs/setup/"
echo

echo "2. Configure Unity MCP (Unity 프로젝트 생성 후, integrations/mcp/servers.md 참고)"
echo

echo "Setup Complete!"