#!/bin/bash
#
# Unity 프로젝트 생성 후, WSL2에서 Unity MCP·Git 작업을 원활히 하기 위한 추가 설정을 자동화합니다.
# Windows 11 + WSL2 + Unity Editor(Windows) 조합을 쓰는 팀원 전용입니다.
# 여러 번 실행해도 안전합니다 (이미 되어 있는 항목은 건너뜁니다).
# 배경: integrations/mcp/servers.md의 'Unity MCP', 'WSL ↔ Windows 네트워크 주의사항' 참고.

set -uo pipefail

echo "========================================"
echo " Unity Workspace Setup (WSL2 + Windows)"
echo "========================================"
echo

if ! grep -qi microsoft /proc/version 2>/dev/null; then
    echo "ℹ️  WSL 환경이 아닙니다. 이 스크립트는 WSL2 + Windows Unity Editor 조합 전용이라 건너뜁니다."
    exit 0
fi

# 1) WSL Mirrored Networking 확인
echo "1) WSL Mirrored Networking 확인"
echo "----------------------------------------"
if ip addr show lo 2>/dev/null | grep -q "10.255.255.254"; then
    echo "✅ Mirrored Networking이 적용된 것으로 보입니다."
else
    echo "⚠️  Mirrored Networking이 꺼져있을 수 있습니다. Unity MCP 연결이 안 되면"
    echo "   Windows 사용자 홈의 .wslconfig에 아래를 추가하고 PowerShell에서 'wsl --shutdown'을 실행하세요."
    echo "   [wsl2]"
    echo "   networkingMode=mirrored"
fi
echo

# 2) Git LFS (WSL 쪽, root 권한 불필요)
echo "2) Git LFS (WSL)"
echo "----------------------------------------"
export PATH="$HOME/.local/bin:$PATH"
if command -v git-lfs >/dev/null 2>&1; then
    printf "✅ %s\n" "$(git-lfs version)"
else
    echo "▶ git-lfs가 없어 사용자 폴더(~/.local/bin)에 설치합니다 (root 권한 불필요)..."
    LFS_VERSION="3.5.1"
    TMP_DIR="$(mktemp -d)"
    if curl -sL "https://github.com/git-lfs/git-lfs/releases/download/v${LFS_VERSION}/git-lfs-linux-amd64-v${LFS_VERSION}.tar.gz" -o "$TMP_DIR/git-lfs.tar.gz" \
        && tar -xzf "$TMP_DIR/git-lfs.tar.gz" -C "$TMP_DIR" \
        && mkdir -p "$HOME/.local/bin" \
        && cp "$TMP_DIR"/git-lfs-*/git-lfs "$HOME/.local/bin/git-lfs" \
        && chmod +x "$HOME/.local/bin/git-lfs"; then
        git-lfs install >/dev/null
        printf "✅ %s 설치 완료\n" "$(git-lfs version)"
        # shellcheck disable=SC2016  # .bashrc에는 확장되지 않은 리터럴 $HOME/$PATH가 들어가야 합니다.
        grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    else
        echo "❌ git-lfs 자동 설치 실패. 수동 설치: https://github.com/git-lfs/git-lfs/releases"
    fi
    rm -rf "$TMP_DIR"
fi
echo

# 3) Windows Git Credential Manager 연동 (로컬 git push 인증을 Windows와 공유)
echo "3) Windows Git Credential Manager 연동"
echo "----------------------------------------"
CURRENT_HELPER="$(git config --global --get credential.helper || true)"
if [ -n "$CURRENT_HELPER" ]; then
    printf "✅ 이미 credential.helper가 설정되어 있습니다: %s\n" "$CURRENT_HELPER"
else
    GCM_PATH="$(find "/mnt/c/Program Files/Git" -iname "git-credential-manager.exe" 2>/dev/null | head -n 1)"
    if [ -n "$GCM_PATH" ]; then
        ESCAPED_PATH="$(printf '%s' "$GCM_PATH" | sed 's/ /\\ /g')"
        git config --global credential.helper "$ESCAPED_PATH"
        echo "✅ Windows Git Credential Manager를 credential.helper로 등록했습니다."
        echo "   (Windows에서 이미 로그인된 GitHub 인증을 WSL에서도 그대로 재사용합니다)"
    else
        echo "❌ Windows Git Credential Manager(git-credential-manager.exe)를 찾지 못했습니다."
        echo "   Git for Windows가 설치되어 있는지 확인하세요: https://git-scm.com/download/win"
    fi
fi
echo

# 4) Unity MCP 등록 (Unity CLI 기반, Unity Hub 43.4.0+가 자동 설치)
# 배경: 기존 relay_win.exe(in-Editor MCP Bridge) 방식은 Unity가 폐기 예고하여
# Unity CLI의 MCP Mode(`unity mcp`)로 전환했습니다. integrations/mcp/servers.md 'Unity MCP' 참고.
echo "4) Unity MCP 등록 (Unity CLI 기반)"
echo "----------------------------------------"
if ! command -v claude >/dev/null 2>&1; then
    echo "❌ Claude Code CLI를 찾을 수 없어 건너뜁니다."
else
    if claude mcp list 2>/dev/null | grep -qE "^unity-editor-mcp:"; then
        echo "✅ unity-editor-mcp가 이미 등록되어 있습니다."
    else
        UNITY_CLI_PATH="$(find /mnt/c/Users/*/AppData/Local/Unity/bin -maxdepth 1 -iname "unity.exe" 2>/dev/null | head -n 1)"
        if [ -n "$UNITY_CLI_PATH" ]; then
            if claude mcp add --scope user --transport stdio unity-editor-mcp -- "$UNITY_CLI_PATH" mcp >/dev/null 2>&1; then
                echo "✅ unity-editor-mcp 등록 완료: $UNITY_CLI_PATH"
            else
                echo "❌ unity-editor-mcp 등록 실패. 'claude mcp add --scope user --transport stdio unity-editor-mcp -- \"$UNITY_CLI_PATH\" mcp' 를 직접 실행해보세요."
            fi
        else
            echo "ℹ️  Unity CLI(unity.exe)를 찾지 못했습니다. Unity Hub(43.4.0 이상)를 실행해"
            echo "   CLI가 자동 설치되게 한 뒤 이 스크립트를 다시 실행하세요."
            printf '   (수동 확인: Windows에서 %%LOCALAPPDATA%%\\Unity\\bin\\unity.exe 존재 여부)\n'
        fi
    fi

    if claude mcp list 2>/dev/null | grep -qE "^unity-mcp:"; then
        echo "⚠️  구 방식(unity-mcp, relay_win.exe)이 아직 등록되어 있습니다. 'claude mcp remove unity-mcp'로 정리하세요."
    fi
fi
echo

echo "========================================"
echo " 완료 — Claude Code 세션을 재시작하면 Unity MCP 도구가 로드됩니다."
echo "========================================"
