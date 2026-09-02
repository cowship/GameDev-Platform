#!/bin/bash
#
# 팀원 한 명이 이 저장소에서 Unity 공동 개발을 시작할 수 있게 로컬 환경을 맞춥니다.
#
#   1) Git 사용자 정보 확인
#   2) Git LFS 초기화 (바이너리 자산을 제대로 받으려면 필수)
#   3) UnityYAMLMerge(Smart Merge) 병합 드라이버 등록 (Scene/Prefab 충돌 대응)
#   4) 개인 실험용 sandbox/{이름} 브랜치 생성
#
# 실행 환경: Windows + Git Bash (Git for Windows에 포함)
#   시작 메뉴 → "Git Bash" → 저장소 폴더로 이동 후 실행
#
# 여러 번 실행해도 안전합니다 (이미 되어 있는 항목은 건너뜁니다).
# 배경: docs/team/README.md, docs/team/ONBOARDING.md 참고.
#
# 사용법:
#   ./scripts/setup_team_member.sh              # 이름을 물어봅니다
#   ./scripts/setup_team_member.sh ajunlee0     # 이름을 인자로 전달

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

MEMBER_NAME="${1:-}"
EXIT_STATUS=0

echo "========================================"
echo " Team Member Setup — GameDev-Platform"
echo "========================================"
echo

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) ;;
    *)
        echo "⚠️  이 스크립트는 Windows의 Git Bash에서 실행하도록 만들어졌습니다."
        echo "   Unity Editor가 Windows에서 동작해야 하므로 저장소도 Windows 드라이브에 두어야 합니다."
        echo "   (자세한 이유는 docs/team/ONBOARDING.md 참고)"
        echo "   계속 진행하지만 Unity 관련 단계는 건너뛸 수 있습니다."
        echo
        ;;
esac

# ------------------------------------------------------------
# 1) Git 사용자 정보
# ------------------------------------------------------------
echo "1) Git 사용자 정보"
echo "----------------------------------------"
GIT_NAME="$(git config --get user.name || true)"
GIT_EMAIL="$(git config --get user.email || true)"
if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
    printf "✅ %s <%s>\n" "$GIT_NAME" "$GIT_EMAIL"
else
    echo "❌ Git 사용자 정보가 없습니다. 커밋 작성자가 비면 리뷰 추적이 안 됩니다."
    echo "   git config --global user.name \"이름\""
    echo "   git config --global user.email \"github-계정-이메일\""
    EXIT_STATUS=1
fi
echo

# ------------------------------------------------------------
# 2) Git LFS
# ------------------------------------------------------------
echo "2) Git LFS"
echo "----------------------------------------"
if command -v git-lfs >/dev/null 2>&1 || git lfs version >/dev/null 2>&1; then
    printf "✅ %s\n" "$(git lfs version | cut -d' ' -f1)"
    git lfs install --local >/dev/null 2>&1 && echo "✅ 이 저장소에 LFS hook 등록 완료"
    if git lfs pull >/dev/null 2>&1; then
        echo "✅ git lfs pull 완료"
    else
        echo "ℹ️  아직 LFS로 관리되는 파일이 없거나 원격에 접근하지 못했습니다 (지금은 문제 없습니다)."
    fi
else
    echo "❌ Git LFS를 찾을 수 없습니다."
    echo "   Git for Windows 2.x에는 기본 포함되어 있습니다. 재설치 시 'Git LFS' 항목을 선택하세요."
    echo "   https://git-scm.com/download/win"
    EXIT_STATUS=1
fi
echo

# ------------------------------------------------------------
# 3) UnityYAMLMerge (Smart Merge) 병합 드라이버
# ------------------------------------------------------------
echo "3) UnityYAMLMerge (Scene/Prefab 병합 도구)"
echo "----------------------------------------"

# Git Bash 경로(/c/...)를 Windows 경로(C:/...)로 바꿉니다.
# 병합 드라이버는 Git 내부 셸을 거쳐 실행되므로 Windows 형식이 더 안전합니다.
to_windows_path() {
    printf '%s' "$1" | sed -E 's|^/([a-zA-Z])/|\1:/|'
}

find_unity_merge_tool() {
    local roots=() hub_config secondary root path
    hub_config="$HOME/AppData/Roaming/UnityHub/secondaryInstallPath.json"
    if [ -f "$hub_config" ]; then
        # "F:\\Unity\\Hub\\Editor" → /f/Unity/Hub/Editor
        secondary="$(tr -d '"' < "$hub_config" | sed 's|\\\\|/|g; s|\\|/|g')"
        if [ -n "$secondary" ]; then
            roots+=("/$(printf '%s' "$secondary" | cut -c1 | tr '[:upper:]' '[:lower:]')$(printf '%s' "$secondary" | cut -c3-)")
        fi
    fi
    roots+=("/c/Program Files/Unity/Hub/Editor" "/c/Program Files/Unity/Editor")

    for root in "${roots[@]}"; do
        [ -d "$root" ] || continue
        # <root>/<버전>/Editor/Data/Tools/UnityYAMLMerge.exe → root 기준 깊이 5
        path="$(find "$root" -maxdepth 5 -name "UnityYAMLMerge.exe" -type f 2>/dev/null | head -n 1)"
        if [ -n "$path" ]; then
            printf '%s' "$path"
            return 0
        fi
    done
    return 1
}

if [ -n "$(git config --get merge.unityyamlmerge.driver || true)" ]; then
    echo "✅ 병합 드라이버가 이미 등록되어 있습니다."
else
    MERGE_TOOL="$(find_unity_merge_tool)"
    if [ -z "$MERGE_TOOL" ]; then
        echo "⚠️  UnityYAMLMerge를 찾지 못했습니다. Unity Editor 설치 후 다시 실행하세요."
        echo "   (설치 위치: <Unity Editor>/Editor/Data/Tools/UnityYAMLMerge.exe)"
    else
        WIN_TOOL="$(to_windows_path "$MERGE_TOOL")"
        git config merge.unityyamlmerge.name "Unity SmartMerge"
        git config merge.unityyamlmerge.driver "'$WIN_TOOL' merge -p --force %O %B %A %A"
        git config merge.unityyamlmerge.recursive binary
        echo "✅ 병합 드라이버 등록 완료"
        echo "   도구: $WIN_TOOL"
    fi
fi
echo

# ------------------------------------------------------------
# 4) 개인 sandbox 브랜치
# ------------------------------------------------------------
echo "4) 개인 실험용 sandbox 브랜치"
echo "----------------------------------------"
if [ -z "$MEMBER_NAME" ]; then
    read -r -p "본인 GitHub 계정을 입력하세요 (예: ajunlee0): " MEMBER_NAME
fi

# 브랜치 이름으로 쓸 수 없는 문자를 정리합니다.
MEMBER_NAME="$(printf '%s' "$MEMBER_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9-' '-' | sed 's/-\+/-/g; s/^-//; s/-$//')"

if [ -z "$MEMBER_NAME" ]; then
    echo "⚠️  이름이 비어 있어 sandbox 브랜치 생성을 건너뜁니다."
else
    SANDBOX_BRANCH="sandbox/$MEMBER_NAME"
    if git show-ref --verify --quiet "refs/heads/$SANDBOX_BRANCH"; then
        echo "✅ $SANDBOX_BRANCH 브랜치가 이미 있습니다."
    elif git ls-remote --exit-code --heads origin "$SANDBOX_BRANCH" >/dev/null 2>&1; then
        git fetch origin "$SANDBOX_BRANCH":"$SANDBOX_BRANCH" >/dev/null 2>&1
        echo "✅ 원격의 $SANDBOX_BRANCH 를 로컬로 가져왔습니다."
    else
        if git branch "$SANDBOX_BRANCH" >/dev/null 2>&1; then
            echo "✅ $SANDBOX_BRANCH 브랜치를 만들었습니다."
            echo "   원격에 올리려면: git push -u origin $SANDBOX_BRANCH"
        else
            echo "❌ $SANDBOX_BRANCH 브랜치 생성에 실패했습니다."
            EXIT_STATUS=1
        fi
    fi
fi
echo

# ------------------------------------------------------------
# 마무리 안내
# ------------------------------------------------------------
echo "========================================"
echo " 남은 수동 단계"
echo "========================================"
echo "1. Unity Hub → Add project from disk → 이 저장소의 game/ 폴더 선택"
echo "   (저장소 루트가 아닙니다. Editor 버전은 game/ProjectSettings/ProjectVersion.txt 와 일치해야 합니다)"
echo "2. 네트워킹(NGO)은 별도 설치가 필요 없습니다 → integrations/netcode/README.md"
echo "3. 브랜치 사용 규칙 → docs/team/README.md"
echo "4. (선택) Claude Code를 쓴다면 → ./scripts/setup_mcp.sh"
echo

if [ "$EXIT_STATUS" -eq 0 ]; then
    echo "Setup Complete!"
else
    echo "⚠️  Setup Incomplete — 위 로그의 ❌ 항목을 처리한 뒤 다시 실행하세요."
fi

exit "$EXIT_STATUS"
