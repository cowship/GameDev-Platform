#!/bin/bash

echo "========================================"
echo " GameDev-Platform Environment Check"
echo "========================================"
echo

check_command() {
    local name="$1"
    local command="$2"

    if command -v "$command" >/dev/null 2>&1; then
        version=$($command --version 2>/dev/null | head -n 1)
        printf "✅ %-15s %s\n" "$name" "$version"
    else
        printf "❌ %-15s Not Installed\n" "$name"
    fi
}

echo "Checking development tools..."
echo

check_command "Git" git
check_command "Node.js" node
check_command "npm" npm
check_command "Claude Code" claude

echo

echo "Checking VS Code..."

if command -v code >/dev/null 2>&1; then
    echo "✅ VS Code CLI    Installed"
else
    echo "❌ VS Code CLI    Not Installed"
fi

echo

echo "Checking GitHub SSH..."

if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "✅ SSH Key        Found"
else
    echo "❌ SSH Key        Not Found"
fi

echo

echo "Checking WSL..."

if grep -qi microsoft /proc/version; then
    echo "✅ WSL            Running"
else
    echo "❌ WSL            Not Detected"
fi

echo
echo "========================================"
echo "Environment Check Complete"
echo "========================================"