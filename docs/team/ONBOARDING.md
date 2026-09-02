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

# 전체 순서 — 본격 작업 전에 끝내야 하는 것들

이 문서의 1~8단계는 **팀원 각자**가 수행합니다. 다만 그중 두 가지는 **팀에서 한 명만** 하고 나머지는 그 결과를 `git pull`로 받습니다.

| 한 명만 하는 작업 | 어디에 | 현재 상태 |
|---|---|---|
| Unity로 `game/` 최초 실행 → 생성된 `.meta`·`packages-lock.json` 커밋 | 4단계 | ⬜ 아직 아무도 안 함 |
| Photon Fusion SDK import + App Id 입력 | 5단계 | ⬜ 아직 아무도 안 함 |

이 두 가지가 `main`에 올라가기 전에 다른 사람이 Unity를 열면 **각자 다른 GUID로 `.meta`가 생성되어 참조가 깨집니다.** 병합으로 깔끔히 풀리지 않으니 순서를 지켜야 합니다.

## Phase 0 — 부트스트랩 (담당자 1명)

| # | 작업 | 참고 |
|---|---|---|
| 0-1 | 1~3단계 수행 (SSH Key → clone → `setup_team_member.sh`) | 아래 |
| 0-2 | 4단계 — Unity로 `game/` 열기 → 생성물 커밋 → **PR 만들고 바로 머지** | [4단계](#4-unity-프로젝트-열기) |
| 0-3 | 팀에 "pull 받고 시작하세요" 공지 | |
| 0-4 | 5단계 — Fusion SDK import + App Id → **별도 PR** → 머지 | [5단계](#5-photon-fusion-설정) |
| 0-5 | 팀에 App Id 공유 및 공지 | |

> ⚠️ 0-2와 0-4를 **한 커밋에 섞지 마세요.** Fusion SDK는 파일 수가 많아 diff가 거대해집니다. 섞이면 나중에 어느 쪽이 문제인지 가려낼 수 없고, 되돌리기도 어려워집니다.

## Phase 1 — 나머지 팀원 4명 (Phase 0 완료 공지 이후)

1~3단계는 Phase 0을 기다리지 않고 **미리 해도 됩니다.** 4단계(Unity 열기)부터는 공지를 받은 뒤에 진행합니다.

## Phase 2 — 본격 개발 시작

- [ ] 역할 분담 확정 → [docs/team/README.md](README.md)의 "역할 분담" 표와 [.github/CODEOWNERS](../../.github/CODEOWNERS) 동시 갱신
- [ ] 게임 제목 확정 → `game/ProjectSettings/ProjectSettings.asset`의 `productName`(현재 임시값 `FusionGame`) 변경
- [ ] 첫 Issue 등록 및 Sprint 시작

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

### 커밋 전에 `git status` 확인

아래와 같이 **추가만 있고 기존 파일 수정이 거의 없어야** 정상입니다.

| 파일 | 예상 상태 | 커밋 |
|---|---|---|
| `game/Assets/**/*.meta` | 새로 추가 (폴더마다) | ✅ |
| `game/Packages/packages-lock.json` | 새로 추가 — 팀 전원의 패키지 버전을 고정합니다 | ✅ |
| `game/ProjectSettings/ProjectVersion.txt` | 수정 — `m_EditorVersionWithRevision` 줄이 채워짐 | ✅ |
| `game/Assets/Settings/*.asset` | 수정될 수 있음 — URP 업그레이드 결과 | ✅ |
| `game/Library/`, `game/UserSettings/`, `game/Logs/` | `.gitignore` 대상이라 **아예 보이지 않아야** 함 | — |

`ProjectSettings/`의 **다른** 파일들이 무더기로 수정됐다면 멈추세요. Editor 버전 불일치 신호입니다. 커밋하지 말고 팀에 알립니다.

### 커밋 및 머지

```bash
git switch -c chore/unity-first-open
git add game/
git commit -m "chore: Unity 최초 실행으로 생성된 .meta 및 패키지 lock 추가"
git push -u origin chore/unity-first-open
gh pr create --base main --fill     # 또는 GitHub 웹에서 PR 생성
```

> **이 PR은 리뷰를 기다리지 말고 본인이 바로 Squash and merge 하세요.**
>
> 평소에는 `main` 병합 전에 1명 이상의 Approve를 받는 것이 규칙입니다([docs/team/README.md](README.md)). 이 커밋만 예외로 두는 이유는 두 가지입니다.
>
> - 내용이 전부 Unity가 기계적으로 생성한 산출물이라 사람이 검토할 대상이 없습니다.
> - 나머지 팀원 4명이 이 커밋을 받아야 작업을 시작할 수 있어, 대기 비용이 리뷰의 가치보다 큽니다.
>
> PR 자체는 남기세요. 기록이 남고, 팀의 첫 PR 흐름을 한 번 굴려보는 의미도 있습니다.

머지한 뒤 **팀에 공지**합니다.

```text
game/ 최초 실행 커밋이 main에 올라갔습니다.
git pull 받은 뒤 Unity Hub로 game/ 폴더를 열어주세요.
```

---

# 5. Photon Fusion 설정

[integrations/photon/setup.md](../../integrations/photon/setup.md)를 따릅니다. 요약하면 이렇습니다.

1. Fusion SDK(`.unitypackage`) import — **최초 1명만** 수행하고 커밋합니다. 이미 `game/Assets/Photon/`이 있다면 건너뜁니다.
2. 팀 공용 App Id를 `Tools > Fusion > Realtime Settings`에 입력합니다. **팀 전체가 같은 App Id를 써야** 서로 접속됩니다.

## 언제 main에 머지하나

4단계의 최초 실행 커밋이 **머지된 뒤에**, 그와 **별도의 PR**로 올립니다.

```bash
git switch main && git pull
git switch -c chore/import-fusion-sdk
git add game/Assets/Photon game/ProjectSettings
git commit -m "chore: Photon Fusion 2 SDK import 및 App Id 설정"
git push -u origin chore/import-fusion-sdk
gh pr create --base main --fill
```

이 PR도 리뷰 대기 없이 바로 머지해도 됩니다 — 내용이 외부 SDK 원본이라 검토 대상이 아닙니다. 다만 **머지 전에 본인 환경에서 Console에 에러가 없는지는 반드시 확인**하세요. 여기서 깨진 채로 올라가면 팀 전원이 동시에 막힙니다.

머지 후 팀에 공지하고 App Id를 공유합니다.

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

# 8. 본격 작업 시작 전 최종 확인

여기까지 오면 개인 환경은 끝입니다. 팀 전체 기준으로 아래가 모두 채워져야 게임 개발을 시작할 수 있습니다.

- [ ] `main`에 Unity 최초 실행 커밋이 들어가 있다 (`game/Assets/**/*.meta`, `packages-lock.json` 존재)
- [ ] `main`에 Fusion SDK가 들어가 있다 (`game/Assets/Photon/` 존재)
- [ ] 팀원 5명 전원이 `setup_team_member.sh`를 돌렸다
- [ ] 팀원 5명 전원이 Unity로 `game/`을 열어 에러 없이 Play까지 확인했다
- [ ] 역할 분담이 정해지고 [.github/CODEOWNERS](../../.github/CODEOWNERS)에 반영됐다
- [ ] 각자 `sandbox/{본인계정}` 브랜치를 확인했다

---

# 9. 다음 단계

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

## `Connection reset by ... port 22` — SSH 포트가 막힌 네트워크

```text
Connection reset by 64:ff9b::14c8:f5f7 port 22
fatal: Could not read from remote repository.
```

학교·회사 네트워크에서 22번 포트를 막아둔 경우입니다. 키 문제가 아니므로 재발급할 필요 없습니다. GitHub는 **443 포트로도 SSH를 받아주므로** 아래처럼 우회합니다.

```bash
cat >> ~/.ssh/config <<'EOF'

Host github.com
  Hostname ssh.github.com
  Port 443
  User git
EOF

ssh -T git@github.com     # 다시 확인
```

이래도 안 되면 HTTPS로 바꿉니다. 첫 push 때 브라우저 로그인 창이 뜨고, 이후에는 Git Credential Manager가 인증을 기억합니다.

```bash
git remote set-url origin https://github.com/cowship/GameDev-Platform.git
git push -u origin <브랜치이름>
```

## `gh: command not found`

GitHub CLI는 선택 사항입니다. 설치하지 않고 **GitHub 웹에서 PR을 만들어도 됩니다** — push 후 저장소 페이지에 뜨는 `Compare & pull request` 버튼을 누르거나, 아래 주소로 바로 이동합니다.

```text
https://github.com/cowship/GameDev-Platform/pull/new/<브랜치이름>
```

설치하고 싶다면 PowerShell에서 `winget install --id GitHub.cli` 실행 후 Git Bash를 새로 엽니다.

---

# Related Documents

| Document | Description |
|---|---|
| [README.md](README.md) | 팀 협업 규칙 (Branch 전략, Unity 공동 작업 규칙) |
| [integrations/photon/setup.md](../../integrations/photon/setup.md) | Photon Fusion SDK 설치 |
| [integrations/unity/setup.md](../../integrations/unity/setup.md) | Unity Hub / Editor / Git LFS 기본 설정 |
| [docs/setup/README.md](../setup/README.md) | Claude Code / MCP 설정 |
| [docs/decisions/0008-windows-only-development-environment.md](../decisions/0008-windows-only-development-environment.md) | WSL을 버리고 Windows 단일 환경으로 정한 근거 |
