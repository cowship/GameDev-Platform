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
echo "========================================"
echo " Next Steps"
echo "========================================"
echo

echo "1. Read the setup documentation:"
echo "   docs/setup/"
echo

echo "2. Login to Claude Code"
echo

echo "3. Configure GitHub"
echo

echo "4. Configure Notion MCP (Coming Soon)"
echo

echo "5. Configure Unity (Coming Soon)"
echo

echo "Setup Complete!"