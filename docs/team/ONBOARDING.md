# Onboarding

> 팀원이 이 저장소에서 Unity 개발을 시작할 때 **처음 한 번** 수행하는 절차입니다.
> 실행 환경은 **Windows**입니다. WSL은 사용하지 않습니다 ([ADR 0008](../decisions/0008-windows-only-development-environment.md)).

---

# 준비물

| 항목 | 비고 |
|---|---|
| Windows 10 (1809+) 또는 11 | |
| [Git for Windows](https://git-scm.com/download/win) | Git Bash와 Git LFS가 함께 설치됩니다 |
| Unity Hub | |
| Unity Editor **6000.3.22f1** | 버전이 다르면 프로젝트 파일이 갈립니다 |
| GitHub 계정 | 이 저장소의 Collaborator 초대를 수락해야 합니다 |
| Photon 계정 (무료) | Fusion App Id 발급용 |

아래 명령은 모두 **Git Bash**에서 실행합니다 (시작 메뉴 → `Git Bash`).

---

# 1. SSH Key 등록

```bash
# 1) 키 생성 — 경로는 기본값 그대로, passphrase는 비워두고 엔터 3번
ssh-keygen -t ed25519 -C "본인-github-이메일"

# 2) 공개키를 클립보드로 복사
clip < ~/.ssh/id_ed25519.pub

# 3) GitHub → Settings → SSH and GPG keys → New SSH key → 붙여넣기 → Add SSH key

# 4) 연결 확인 (본인 계정 이름이 나오면 성공)
ssh -T git@github.com
```

키는 `C:\Users\<이름>\.ssh\id_ed25519`에 생성됩니다. passphrase를 비워두면 `ssh-agent` 설정 없이 바로 쓸 수 있습니다.

---

# 2. 저장소 clone

```bash
cd /d/Work          # 원하는 위치 (D 드라이브 예시)
git clone git@github.com:cowship/GameDev-Platform.git
cd GameDev-Platform
```

> ⚠️ **반드시 Windows 드라이브에 clone하세요.**
>
> WSL 내부 경로(`/home/...`)에 둔 프로젝트는 Unity Editor가 **열지 못합니다.** 실측 결과 `\\wsl.localhost\...` 경로로 열면 다음과 같이 거부됩니다.
>
> ```text
> DisplayDialog: Project folder or disk is read only
> Please move the project folder somewhere readable and writable.
> ```
>
> 경로에 한글이나 공백이 없는 위치를 권장합니다.

---

# 3. 개발 환경 자동 설정

```bash
./scripts/setup_team_member.sh
```

| 단계 | 내용 | 왜 필요한가 |
|---|---|---|
| 1 | Git 사용자 정보 확인 | 커밋 작성자가 비면 리뷰·추적이 안 됩니다 |
| 2 | Git LFS 초기화 | LFS 없이 pull하면 이미지·오디오가 텍스트 포인터 파일로 받아집니다 |
| 3 | UnityYAMLMerge 병합 드라이버 등록 | Scene/Prefab 충돌을 Unity 전용 도구로 자동 해결합니다 |
| 4 | `sandbox/{본인계정}` 브랜치 준비 | 개인 실험 공간 |

여러 번 실행해도 안전합니다. Unity Editor를 아직 설치하지 않았다면 3단계가 건너뛰어지므로, 설치 후 다시 한 번 실행하세요.

---

# 4. Unity 프로젝트 열기

1. Unity Hub → **Add** → **Add project from disk**
2. 저장소 안의 **`game/` 폴더**를 선택합니다 (저장소 루트가 아닙니다)
3. Editor 버전이 `6000.3.22f1`인지 확인하고 엽니다

처음 여는 데 몇 분 걸립니다. Unity가 `game/Library/`를 만드는 과정이며, 이 폴더는 Git에 올라가지 않습니다(각자 로컬 캐시).

## 버전이 다르다는 경고가 뜨면

```text
This project was last opened with a different version of the Editor.
```

**그냥 열지 마세요.** Unity Hub에서 `6000.3.22f1`을 설치한 뒤 그 버전으로 엽니다. 다른 버전으로 열면 `ProjectSettings`와 Asset이 자동 업그레이드되어 대량 변경이 팀 전체로 퍼집니다.

## 프로젝트를 처음 여는 사람에게만 나타나는 변화

> 이 단계는 **팀에서 한 명만** 수행하면 됩니다. 이미 누군가 끝냈다면 `git pull`만 하면 됩니다.

`game/`은 아직 Unity로 열린 적이 없는 상태로 커밋되어 있습니다. 처음 여는 사람은 `git status`에 **폴더별 `.meta` 파일이 새로 생성**된 것을 보게 됩니다. Unity가 `Assets/` 하위 폴더마다 GUID를 부여하며 만드는 파일이라 **정상**이며, 반드시 커밋해야 합니다. 커밋하지 않으면 다음 사람이 열 때 다른 GUID가 생성되어 참조가 어긋납니다.

```bash
git switch -c chore/unity-first-open
git add game/
git commit -m "chore: Unity 최초 실행으로 생성된 .meta 및 패키지 lock 추가"
git push -u origin chore/unity-first-open
# → PR 생성 후 main에 병합
```

`Packages/packages-lock.json`도 이때 함께 생성됩니다. 같이 커밋하세요 — 팀 전원의 패키지 버전을 고정해 줍니다.

반대로 **기존 파일이 대량 수정**된 것으로 나온다면 Editor 버전이 다를 가능성이 높습니다. 커밋하지 말고 팀에 알려주세요.

---

# 5. Photon Fusion 설정

[integrations/photon/setup.md](../../integrations/photon/setup.md)를 따릅니다. 요약하면 이렇습니다.

1. Fusion SDK(`.unitypackage`) import — **최초 1명만** 수행하고 커밋합니다. 이미 `game/Assets/Photon/`이 있다면 건너뜁니다.
2. 팀 공용 App Id를 `Tools > Fusion > Realtime Settings`에 입력합니다.

---

# 6. (선택) Claude Code 사용

Claude Code를 쓰는 팀원만 해당됩니다.

```bash
./scripts/setup_mcp.sh          # filesystem / github / context7 / Unity MCP 등록
./scripts/setup_claude_skills.sh # Unity 전용 Skill 설치
```

`setup_mcp.sh`는 GitHub Personal Access Token 입력을 요구하고, Notion은 최초 1회 브라우저 인증이 필요합니다. Unity MCP 도구는 **Unity Editor가 실행 중일 때만** 응답합니다 (`unity status`로 확인).

---

# 7. 동작 확인

- [ ] `ssh -T git@github.com`에 본인 계정 이름이 나온다
- [ ] Unity Console에 빨간 에러가 없다
- [ ] `game/Assets/Scenes/SampleScene.unity`가 열리고 Play가 된다
- [ ] `Window > General > Test Runner`에 EditMode/PlayMode 탭이 보인다
- [ ] `git status`에 **기존 파일의 수정**이 없다

---

# 8. 다음 단계

[docs/team/README.md](README.md)의 Branch 전략과 Unity 공동 작업 규칙을 읽습니다. 특히 아래 3가지가 사고가 잦은 지점입니다.

- `.meta` 파일 함께 커밋하기
- 하나의 Scene은 한 명만 수정하기
- 바이너리 자산은 `git lfs lock`으로 선점하기

---

# Troubleshooting

## 이미지가 열리지 않고 텍스트로 보입니다

Git LFS가 설정되지 않은 상태에서 pull한 경우입니다.

```bash
git lfs install --local
git lfs pull
```

## Unity에서 스크립트 참조가 전부 Missing으로 뜹니다

`.meta` 파일이 누락된 커밋을 받았을 가능성이 큽니다. 누가 언제 빠뜨렸는지 확인하고 해당 `.meta`를 복구합니다.

## `git push`가 LFS lock 때문에 거부됩니다

다른 팀원이 그 파일을 잠가둔 상태입니다. `git lfs locks`로 확인하고 협의하세요.

## Unity가 프로젝트를 인식하지 못합니다

저장소 루트가 아니라 `game/` 폴더를 선택했는지 확인하세요.

## `Permission denied (publickey)`

SSH 키가 GitHub에 등록되지 않았거나, Collaborator 초대를 아직 수락하지 않은 경우입니다. 1단계를 다시 확인하세요.

---

# Related Documents

| Document | Description |
|---|---|
| [README.md](README.md) | 팀 협업 규칙 (Branch 전략, Unity 공동 작업 규칙) |
| [integrations/photon/setup.md](../../integrations/photon/setup.md) | Photon Fusion SDK 설치 |
| [integrations/unity/setup.md](../../integrations/unity/setup.md) | Unity Hub / Editor / Git LFS 기본 설정 |
| [docs/setup/README.md](../setup/README.md) | Claude Code / MCP 설정 |
| [docs/decisions/0008-windows-only-development-environment.md](../decisions/0008-windows-only-development-environment.md) | WSL을 버리고 Windows 단일 환경으로 정한 근거 |
