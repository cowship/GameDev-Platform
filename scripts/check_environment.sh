#!/bin/bash
#
# GameDev-Platform 개발 환경을 점검하고, 누락된 항목은 가능한 범위에서 직접 설치합니다.
# 여러 번 실행해도 안전합니다 (이미 설치된 항목은 건너뜁니다).
# 자동화가 불가능한 항목(Notion 인증, Unity Editor 등)은 안내만 출력합니다.

set -uo pipefail

echo "========================================"
echo " GameDev-Platform Environment Check & Setup"
echo "========================================"
echo

NEEDS_MANUAL=0

confirm() {
    # $1: 안내 메시지. y/Y 입력 시 0(true), 그 외 1(false) 반환.
    read -r -p "$1 (y/N): " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

has_sudo() {
    command -v sudo >/dev/null 2>&1
}

# ---------- 1) Git ----------
echo "1) Git"
echo "----------------------------------------"
if command -v git >/dev/null 2>&1; then
    printf "✅ Git            %s\n" "$(git --version)"
else
    echo "❌ Git이 설치되어 있지 않습니다."
    if has_sudo && confirm "sudo apt-get install git 로 지금 설치할까요?"; then
        sudo apt-get update && sudo apt-get install -y git
        command -v git >/dev/null 2>&1 && printf "✅ Git            %s\n" "$(git --version)"
    else
        echo "   수동 설치: sudo apt-get install -y git"
        NEEDS_MANUAL=1
    fi
fi
echo

# ---------- 2) Git 사용자 정보 (Commit에 필요) ----------
echo "2) Git 사용자 정보 (user.name / user.email)"
echo "----------------------------------------"
if command -v git >/dev/null 2>&1; then
    GIT_NAME="$(git config --global --get user.name || true)"
    GIT_EMAIL="$(git config --global --get user.email || true)"
    if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
        printf "✅ Git 사용자      %s <%s>\n" "$GIT_NAME" "$GIT_EMAIL"
    else
        echo "❌ Git 사용자 정보가 없습니다. Commit 시 필요합니다."
        if confirm "지금 설정할까요?"; then
            read -r -p "  Git user.name: " input_name
            read -r -p "  Git user.email: " input_email
            git config --global user.name "$input_name"
            git config --global user.email "$input_email"
            echo "✅ Git 사용자 정보를 설정했습니다."
        else
            echo "   수동 설정: git config --global user.name \"이름\" && git config --global user.email \"이메일\""
            NEEDS_MANUAL=1
        fi
    fi
else
    echo "⏭️  Git이 없어 건너뜁니다."
fi
echo

# ---------- 3) Node.js / npm (nvm 경유) ----------
echo "3) Node.js / npm"
echo "----------------------------------------"
export NVM_DIR="$HOME/.nvm"
# nvm.sh 내부 코드가 set -u(nounset)와 호환되지 않아(예: unbound variable로 스크립트 전체가
# 조기 종료됨) nvm을 다루는 동안만 nounset을 잠시 끈다.
set +u
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" >/dev/null 2>&1

if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    printf "✅ Node.js        %s\n" "$(node --version)"
    printf "✅ npm            %s\n" "$(npm --version)"
else
    echo "❌ Node.js/npm이 설치되어 있지 않습니다."
    if confirm "nvm으로 Node.js LTS를 지금 설치할까요?"; then
        if [ ! -s "$NVM_DIR/nvm.sh" ]; then
            echo "▶ nvm 설치 중..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
            \. "$NVM_DIR/nvm.sh"
        fi
        nvm install --lts
        nvm use --lts
        if command -v node >/dev/null 2>&1; then
            printf "✅ Node.js        %s\n" "$(node --version)"
            printf "✅ npm            %s\n" "$(npm --version)"
            echo "   (새 터미널에서도 적용하려면 'source ~/.bashrc' 또는 새 터미널을 여세요)"
        else
            echo "❌ 설치 후에도 node 명령을 찾을 수 없습니다. 새 터미널을 열고 다시 실행해보세요."
            NEEDS_MANUAL=1
        fi
    else
        echo "   수동 설치: integrations/claude/setup.md의 nvm 안내 참고"
        NEEDS_MANUAL=1
    fi
fi
set -u
echo

# ---------- 4) Claude Code CLI ----------
echo "4) Claude Code CLI"
echo "----------------------------------------"
if command -v claude >/dev/null 2>&1; then
    version=$(claude --version 2>/dev/null | head -n 1)
    printf "✅ Claude Code    %s\n" "$version"
else
    echo "❌ Claude Code CLI가 설치되어 있지 않습니다."
    if confirm "지금 설치할까요? (curl -fsSL https://claude.ai/install.sh | bash)"; then
        curl -fsSL https://claude.ai/install.sh | bash
        export PATH="$HOME/.local/bin:$PATH"
        grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        if command -v claude >/dev/null 2>&1; then
            printf "✅ Claude Code    %s\n" "$(claude --version 2>/dev/null | head -n 1)"
            echo "   설치 후 최초 1회 'claude login'으로 로그인하세요."
        else
            echo "❌ 설치 후에도 claude 명령을 찾을 수 없습니다. 새 터미널을 열거나 'source ~/.bashrc'를 실행하세요."
            NEEDS_MANUAL=1
        fi
    else
        echo "   수동 설치: integrations/claude/setup.md 참고"
        NEEDS_MANUAL=1
    fi
fi
echo

# ---------- 5) GitHub CLI (gh, 선택) ----------
echo "5) GitHub CLI (gh, 선택)"
echo "----------------------------------------"
if command -v gh >/dev/null 2>&1; then
    printf "✅ GitHub CLI     %s\n" "$(gh --version | head -n 1)"
else
    echo "❌ GitHub CLI(gh)가 설치되어 있지 않습니다. (선택 사항)"
    if has_sudo && confirm "sudo apt-get install gh 로 지금 설치할까요?"; then
        sudo apt-get update && sudo apt-get install -y gh
        if command -v gh >/dev/null 2>&1; then
            printf "✅ GitHub CLI     %s\n" "$(gh --version | head -n 1)"
            echo "   로그인하려면 'gh auth login'을 실행하세요."
        else
            echo "❌ 설치 실패. 수동 설치: integrations/github/setup.md 참고"
        fi
    else
        echo "   수동 설치: integrations/github/setup.md 참고 (선택 사항이라 건너뛰어도 진행에 지장 없음)"
    fi
fi
echo

# ---------- 6) VS Code CLI ----------
echo "6) VS Code CLI"
echo "----------------------------------------"
if command -v code >/dev/null 2>&1; then
    echo "✅ VS Code CLI    Installed"
else
    echo "❌ VS Code CLI를 찾을 수 없습니다."
    if command -v powershell.exe >/dev/null 2>&1 && confirm "Windows 쪽에 winget으로 VS Code 설치를 시도할까요?"; then
        powershell.exe -NoProfile -Command "winget install -e --id Microsoft.VisualStudioCode" || true
        echo "ℹ️  설치 후 VS Code에서 'Remote - WSL' 확장을 설치하고, 이 WSL 폴더를 한 번 열어야 'code' 명령이 PATH에 등록됩니다."
    else
        echo "   VS Code는 Windows 쪽 GUI 설치가 필요해 WSL 내부에서 완전 자동화할 수 없습니다."
        echo "   수동 설치: https://code.visualstudio.com/ (설치 후 Remote-WSL 확장 설치 필요)"
        NEEDS_MANUAL=1
    fi
fi
echo

# ---------- 7) GitHub SSH Key ----------
echo "7) GitHub SSH Key"
echo "----------------------------------------"
if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "✅ SSH Key        Found"
else
    echo "❌ SSH Key        Not Found"
    if confirm "지금 SSH Key(ed25519)를 생성할까요?"; then
        read -r -p "  GitHub 계정 이메일: " ssh_email
        mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
        if ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519" -N ""; then
            echo "✅ SSH Key를 생성했습니다."
            echo
            echo "   ⚠️  아래 Public Key를 GitHub → Settings → SSH and GPG keys 에 직접 등록해야 합니다 (자동화 불가):"
            echo "   ---"
            cat ~/.ssh/id_ed25519.pub
            echo "   ---"
        else
            echo "❌ SSH Key 생성에 실패했습니다. 수동 생성: integrations/github/setup.md 참고"
        fi
        NEEDS_MANUAL=1
    else
        echo "   수동 생성: integrations/github/setup.md 참고"
        NEEDS_MANUAL=1
    fi
fi
echo

# ---------- 8) WSL ----------
echo "8) WSL"
echo "----------------------------------------"
if grep -qi microsoft /proc/version; then
    echo "✅ WSL            Running"
else
    echo "ℹ️  WSL            Not Detected (WSL2 환경이 아니어도 대부분의 항목은 그대로 진행 가능)"
fi
echo

echo "========================================"
if [ "$NEEDS_MANUAL" -eq 0 ]; then
    echo "✅ Environment Check & Setup Complete (자동화 가능한 항목은 모두 완료)"
else
    echo "⚠️  일부 항목은 수동 조치가 필요합니다. 위 ❌/⚠️ 표시와 안내를 확인하세요."
fi
echo "========================================"

exit "$NEEDS_MANUAL"
