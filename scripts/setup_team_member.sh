#!/bin/bash
#
# 팀원 한 명이 이 저장소에서 Unity 공동 개발을 시작할 수 있게 로컬 환경을 맞춥니다.
#
#   1) Git 사용자 정보 확인
#   2) Git LFS 설치 및 초기화 (바이너리 자산을 받으려면 필수)
#   3) UnityYAMLMerge(Smart Merge) 병합 드라이버 등록 (Scene/Prefab 충돌 대응)
#   4) 개인 실험용 sandbox/{이름} 브랜치 생성
#
# 여러 번 실행해도 안전합니다 (이미 되어 있는 항목은 건너뜁니다).
# 배경: docs/team/README.md, integrations/unity/workflow.md 참고.
#
# 사용법:
#   ./scripts/setup_team_member.sh              # 이름을 물어봅니다
#   ./scripts/setup_team_member.sh ajun         # 이름을 인자로 전달

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

MEMBER_NAME="${1:-}"
EXIT_STATUS=0

echo "========================================"
echo " Team Member Setup — GameDev-Platform"
echo "========================================"
echo

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
    echo "❌ Git 사용자 정보가 설정되지 않았습니다. 커밋 작성자가 비어 있으면 리뷰 추적이 어렵습니다."
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
export PATH="$HOME/.local/bin:$PATH"
if ! command -v git-lfs >/dev/null 2>&1; then
    echo "▶ git-lfs가 없어 사용자 폴더(~/.local/bin)에 설치합니다 (root 권한 불필요)..."
    LFS_VERSION="3.5.1"
    TMP_DIR="$(mktemp -d)"
    if curl -sL "https://github.com/git-lfs/git-lfs/releases/download/v${LFS_VERSION}/git-lfs-linux-amd64-v${LFS_VERSION}.tar.gz" -o "$TMP_DIR/git-lfs.tar.gz" \
        && tar -xzf "$TMP_DIR/git-lfs.tar.gz" -C "$TMP_DIR" \
        && mkdir -p "$HOME/.local/bin" \
        && cp "$TMP_DIR"/git-lfs-*/git-lfs "$HOME/.local/bin/git-lfs" \
        && chmod +x "$HOME/.local/bin/git-lfs"; then
        # shellcheck disable=SC2016  # .bashrc에는 확장되지 않은 리터럴 $HOME/$PATH가 들어가야 합니다.
        grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    else
        echo "❌ git-lfs 자동 설치 실패. 수동 설치: https://github.com/git-lfs/git-lfs/releases"
        EXIT_STATUS=1
    fi
    rm -rf "$TMP_DIR"
fi

if command -v git-lfs >/dev/null 2>&1; then
    git lfs install --local >/dev/null 2>&1
    printf "✅ %s (이 저장소에 hook 등록 완료)\n" "$(git-lfs version | cut -d' ' -f1)"
    echo "▶ LFS로 관리되는 파일을 내려받는 중..."
    if git lfs pull >/dev/null 2>&1; then
        echo "✅ git lfs pull 완료"
    else
        echo "ℹ️  아직 LFS로 관리되는 파일이 없거나 원격에 접근하지 못했습니다 (지금은 문제 없습니다)."
    fi
fi
echo

# ------------------------------------------------------------
# 3) UnityYAMLMerge (Smart Merge) 병합 드라이버
# ------------------------------------------------------------
echo "3) UnityYAMLMerge (Scene/Prefab 병합 도구)"
echo "----------------------------------------"

find_unity_merge_tool() {
    local roots=() hub_config="" secondary drive root path candidate
    for candidate in /mnt/c/Users/*/AppData/Roaming/UnityHub/secondaryInstallPath.json; do
        if [ -f "$candidate" ]; then
            hub_config="$candidate"
            break
        fi
    done
    if [ -n "$hub_config" ]; then
        # "F:\\Unity\\Hub\\Editor" 형태의 JSON 문자열을 WSL 경로로 변환합니다.
        secondary="$(tr -d '"' < "$hub_config" | sed 's|\\\\|/|g; s|\\|/|g')"
        if [ -n "$secondary" ]; then
            drive="$(printf '%s' "$secondary" | cut -c1 | tr '[:upper:]' '[:lower:]')"
            roots+=("/mnt/$drive$(printf '%s' "$secondary" | cut -c3-)")
        fi
    fi
    roots+=("/mnt/c/Program Files/Unity/Hub/Editor" "$HOME/Unity/Hub/Editor")

    for root in "${roots[@]}"; do
        [ -d "$root" ] || continue
        # <root>/<버전>/Editor/Data/Tools/UnityYAMLMerge[.exe] → root 기준 깊이 5
        path="$(find "$root" -maxdepth 5 -name "UnityYAMLMerge*" -type f 2>/dev/null | head -n 1)"
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
        echo "⚠️  UnityYAMLMerge를 찾지 못했습니다. Unity Editor 설치 후 이 스크립트를 다시 실행하세요."
        echo "   (설치 위치 예: <Editor>/Data/Tools/UnityYAMLMerge.exe)"
    elif [[ "$MERGE_TOOL" == *.exe ]]; then
        # WSL에서 Windows용 UnityYAMLMerge.exe를 쓰려면 경로 변환 래퍼가 필요합니다.
        # Git이 넘겨주는 리눅스 경로를 그대로 넘기면 Windows 실행 파일이 읽지 못합니다.
        mkdir -p "$HOME/.local/bin"
        WRAPPER="$HOME/.local/bin/unityyamlmerge-wsl"
        cat > "$WRAPPER" <<WRAPPER_EOF
#!/bin/bash
# WSL ↔ Windows 경로 변환 래퍼 (scripts/setup_team_member.sh가 생성)
UNITY_MERGE_EXE="$MERGE_TOOL"
converted=()
for arg in "\$@"; do
    if [ -e "\$arg" ]; then
        converted+=("\$(wslpath -w "\$arg")")
    else
        converted+=("\$arg")
    fi
done
exec "\$UNITY_MERGE_EXE" "\${converted[@]}"
WRAPPER_EOF
        chmod +x "$WRAPPER"
        git config merge.unityyamlmerge.name "Unity SmartMerge"
        git config merge.unityyamlmerge.driver "$WRAPPER merge -p --force %O %B %A %A"
        git config merge.unityyamlmerge.recursive binary
        echo "✅ 병합 드라이버 등록 완료 (WSL 래퍼 사용)"
        echo "   도구: $MERGE_TOOL"
    else
        git config merge.unityyamlmerge.name "Unity SmartMerge"
        git config merge.unityyamlmerge.driver "'$MERGE_TOOL' merge -p --force %O %B %A %A"
        git config merge.unityyamlmerge.recursive binary
        echo "✅ 병합 드라이버 등록 완료"
        echo "   도구: $MERGE_TOOL"
    fi
fi
echo

# ------------------------------------------------------------
# 4) 개인 sandbox 브랜치
# ------------------------------------------------------------
echo "4) 개인 실험용 sandbox 브랜치"
echo "----------------------------------------"
if [ -z "$MEMBER_NAME" ]; then
    read -r -p "브랜치에 사용할 본인 이름을 영문 소문자로 입력하세요 (예: ajun): " MEMBER_NAME
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
        echo "✅ 원격의 $SANDBOX_BRANCH 브랜치를 로컬로 가져왔습니다."
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
echo "   Editor 버전은 game/ProjectSettings/ProjectVersion.txt 와 반드시 일치해야 합니다."
echo "2. Photon Fusion SDK import 및 App Id 입력 → integrations/photon/setup.md 참고"
echo "3. 브랜치 사용 규칙 → docs/team/README.md 참고"
echo

if [ "$EXIT_STATUS" -eq 0 ]; then
    echo "Setup Complete!"
else
    echo "⚠️  Setup Incomplete — 위 로그의 ❌ 항목을 처리한 뒤 다시 실행하세요."
fi

exit "$EXIT_STATUS"
