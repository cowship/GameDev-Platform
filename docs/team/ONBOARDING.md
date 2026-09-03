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
| [GitHub CLI](https://cli.github.com/) | 터미널에서 PR을 다룹니다. 4단계에서 설치합니다 |

> ⚠️ **명령은 전부 Git Bash에서 실행합니다** (시작 메뉴 → `Git Bash`). PowerShell이 필요한 곳은 **0·4·7단계 세 군데뿐**이고 그때마다 표시해 두었습니다.
>
> 그리고 **설치 후에는 터미널을 새로 여세요.** Windows는 이미 켜져 있는 터미널에 PATH를 반영해주지 않습니다. "분명 설치했는데 명령어를 못 찾는다"의 대부분이 이것입니다.

## WSL에서 옮겨오는 경우 — 무엇을 다시 해야 하나

WSL과 Windows는 같은 노트북 안에 있어도 **사실상 다른 컴퓨터 두 대**입니다. 홈 디렉토리도 설치한 프로그램도 따로라, Ubuntu에서 설치한 Git과 Claude Code는 Windows에서 아예 보이지 않습니다. 게다가 Unity Editor는 WSL 내부 경로의 프로젝트를 **열지 못합니다**([ADR 0008](../decisions/0008-windows-only-development-environment.md)).

| 항목 | 다시 해야 하나? | 이유 |
|---|---|---|
| GitHub / Claude 계정, Notion 커넥터 | ❌ | 계정 단위라 기기와 무관합니다 |
| Unity Hub / Editor | ❌ | 원래부터 Windows에 설치돼 있었습니다 |
| GitHub PAT(토큰) | ⚠️ | 값을 저장해뒀으면 재사용, 없으면 재발급 |
| Git for Windows | ✅ | Git Bash와 Git LFS가 여기 딸려옵니다 |
| SSH key | ✅ | WSL 홈의 `~/.ssh`는 Windows에서 안 보입니다 |
| 저장소 clone | ✅ | Windows 드라이브 경로로 다시 받아야 합니다 |
| git config / LFS / 병합 드라이버 | ✅ | 3단계 스크립트가 한 번에 처리합니다 |
| GitHub CLI (`gh`) | ✅ | 설치도 로그인도 WSL 쪽에만 돼 있습니다 |
| Claude Code 설치 + 로그인 | ✅ | 환경별로 새로 설치·로그인해야 합니다 |
| MCP 서버 등록 | ✅ | 등록 정보가 WSL 홈의 `.claude.json`에 있습니다 |

---

# 전체 순서 — 본격 작업 전에 끝내야 하는 것들

이 문서의 1~9단계는 **팀원 각자**가 수행합니다. 다만 그중 하나만은 **팀에서 한 명만** 하고, 나머지는 그 결과를 `git pull`로 받습니다.

| 한 명만 하는 작업 | 어디에 | 현재 상태 |
|---|---|---|
| Unity로 `game/` 최초 실행 → 생성된 `.meta`·`packages-lock.json` 커밋 | 5단계 | ✅ 완료 (2026-09-02) |

이것이 `main`에 올라가기 전에 다른 사람이 Unity를 열면 **각자 다른 GUID로 `.meta`가 생성되어 참조가 깨집니다.** 병합으로 깔끔히 풀리지 않으니 순서를 지켜야 합니다.

> 네트워킹은 **Netcode for GameObjects(NGO)** 를 쓰며, Unity 공식 패키지라 `manifest.json`에 이미 고정되어 있습니다. 따라서 **SDK를 따로 import하거나 계정·App Id를 발급받는 절차가 없습니다.** 프로젝트를 열면 자동으로 받아집니다 ([ADR 0009](../decisions/0009-netcode-for-gameobjects.md)).

## Phase 0 — 부트스트랩 (담당자 1명) — 완료됨

| # | 작업 | 상태 |
|---|---|---|
| 0-1 | 1~3단계 수행 (SSH Key → clone → `setup_team_member.sh`) | ✅ |
| 0-2 | 5단계 — Unity로 `game/` 열기 → 생성물 커밋 → PR 만들고 바로 머지 | ✅ |
| 0-3 | 팀에 "pull 받고 시작하세요" 공지 | ✅ |

## Phase 1 — 나머지 팀원 4명

Phase 0이 끝났으므로 **지금 바로 1~9단계를 순서대로 진행하면 됩니다.**

## Phase 2 — 본격 개발 시작

- [ ] 역할 분담 확정 → [docs/team/README.md](README.md)의 "역할 분담" 표와 [.github/CODEOWNERS](../../.github/CODEOWNERS) 동시 갱신
- [x] 게임 제목 확정 → `productName`이 `NGOgame`으로 반영됨 (2026-09-02)
- [ ] NetworkManager Prefab 생성 → [integrations/netcode/setup.md](../../integrations/netcode/setup.md)
- [ ] 첫 Issue 등록 및 Sprint 시작

---

# 0. Git for Windows 설치

Git Bash와 Git LFS가 딸려오니 이걸 제일 먼저 깝니다. [git-scm.com/download/win](https://git-scm.com/download/win)에서 받거나, **PowerShell**에서 아래를 실행합니다.

```powershell
winget install --id Git.Git -e
```

Git Bash를 새로 열고 확인합니다. 사용자 정보(`user.name` / `user.email`)는 3단계 스크립트가 확인해주니 지금 설정하지 않아도 됩니다.

```bash
git --version
```

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
> 경로에 **한글이나 공백이 없어야** 합니다. 사용자 폴더 밑(`C:\Users\...`)은 계정명에 한글이 있으면 걸리니, `D:\Work` 같은 드라이브 직하 경로가 안전합니다.

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

# 4. GitHub CLI (`gh`) 설치와 로그인

`gh`는 터미널에서 GitHub을 다루는 도구입니다. 이것이 있으면 **Pull Request를 만들고 리뷰하고 병합하는 일을 브라우저로 가지 않고** 처리할 수 있습니다.

```bash
gh pr create --base main --fill
```

없어도 GitHub 웹에서 PR을 만들 수 있지만, 이 저장소의 작업 흐름은 전부 Git Bash 안에서 끝나므로 설치를 권합니다.

## 설치

**PowerShell**에서 실행하고, 끝나면 **Git Bash를 새로 엽니다.**

```powershell
winget install --id GitHub.cli
```

```bash
gh --version
```

> Windows는 이미 켜져 있는 터미널에 PATH를 반영해주지 않습니다. "분명 설치했는데 명령어를 못 찾는다"의 대부분이 이것입니다.

## 로그인

```bash
gh auth login
```

질문이 순서대로 나옵니다. 방향키로 고르고 엔터를 누르면 됩니다.

| 질문 | 선택 |
|---|---|
| What account do you want to log into? | **GitHub.com** |
| What is your preferred protocol for Git operations? | **SSH** (1단계에서 키를 등록했으므로) |
| Upload your SSH public key to your GitHub account? | **Skip** (이미 올려둔 키가 있습니다) |
| How would you like to authenticate? | **Login with a web browser** |

마지막에 `XXXX-XXXX` 형태의 일회용 코드가 표시됩니다. **이 코드를 복사한 뒤** 엔터를 누르면 브라우저가 열리므로, 붙여넣고 승인하면 끝입니다.

```bash
gh auth status
```

`✓ Logged in to github.com account 본인계정`이 나오면 성공입니다.

> **PAT(토큰)를 따로 만들 필요는 없습니다.** 브라우저 로그인이 필요한 권한을 알아서 받아옵니다.
>
> 7단계의 `setup_mcp.sh`가 요구하는 PAT는 이것과 **별개**입니다. 그쪽은 Claude Code의 GitHub MCP가 쓰는 토큰이라 따로 준비해야 합니다.

## 자주 쓰는 명령

```bash
gh pr create --base main --web     # 브라우저에서 템플릿을 채워 PR 생성
gh pr list                          # 열려 있는 PR 목록
gh pr checkout 5                    # 남의 PR을 내 PC로 받아 Unity에서 확인
gh pr review 5 --approve
gh pr merge 5 --squash --delete-branch
```

`gh pr checkout`이 특히 유용합니다. Unity 프로젝트는 코드만 봐서는 판단이 어려운 경우가 많은데, 이 명령으로 상대 브랜치를 받아 **직접 Play해보고** 승인할 수 있습니다.

---

# 5. Unity 프로젝트 열기

1. Unity Hub → **Add** → **Add project from disk**
2. 저장소 안의 **`game/` 폴더**를 선택합니다 (저장소 루트가 아닙니다)
3. Editor 버전이 `6000.3.22f1`인지 확인하고 엽니다

처음 여는 데 몇 분 걸립니다. Unity가 `game/Library/`를 만드는 과정이며, 이 폴더는 Git에 올라가지 않습니다(각자 로컬 캐시).

## 버전이 다르다는 경고가 뜨면

```text
This project was last opened with a different version of the Editor.
```

**그냥 열지 마세요.** Unity Hub에서 `6000.3.22f1`을 설치한 뒤 그 버전으로 엽니다. 다른 버전으로 열면 `ProjectSettings`와 Asset이 자동 업그레이드되어 대량 변경이 팀 전체로 퍼집니다.

## (완료됨) 최초 1명만 하던 부트스트랩 — 이제 신경쓰지 않아도 됩니다

Unity로 `game/`을 처음 여는 사람은 폴더마다 `.meta`가 새로 생성됩니다. 이게 `main`에 올라가기 전에 다른 사람이 Unity를 열면 **각자 다른 GUID가 생겨 참조가 깨지고**, 병합으로 풀리지 않습니다. 그래서 한 명이 먼저 열어 커밋하고 나머지가 받는 순서가 필요했습니다.

**2026-09-02에 끝났습니다.** 지금은 기다릴 것 없이 0단계부터 순서대로 진행하면 됩니다.

Photon Fusion을 쓸 때 필요했던 SDK import와 App Id 공유 절차도 NGO로 바뀌면서 함께 사라졌습니다.

> 열었을 때 `git status`가 깨끗하지 않다면 8단계의 마지막 항목을 참고하세요. 내가 건드리지도 않은 파일이 무더기로 수정됐다면 Editor 버전 불일치 신호이니, 커밋하지 말고 팀에 알립니다.

---

# 6. 네트워킹 (Netcode for GameObjects)

**따로 설치할 것이 없습니다.** NGO는 Unity 공식 패키지라 `game/Packages/manifest.json`에 버전이 고정되어 있고, 프로젝트를 열면 Package Manager가 자동으로 받아옵니다.

```json
"com.unity.netcode.gameobjects": "2.13.1",
"com.unity.multiplayer.playmode": "2.0.2"
```

## 확인만 하세요

- [ ] `Window > Package Manager` → **In Project**에 `Netcode for GameObjects`가 보인다
- [ ] `Window > Multiplayer > Playmode` 메뉴가 있다

보이지 않으면 Unity를 닫고 `game/Library/PackageCache`를 지운 뒤 다시 엽니다.

`Multiplayer Play Mode`는 **빌드 없이 한 Editor에서 여러 플레이어를 띄우는** 도구입니다. 멀티플레이는 혼자 검증하기 어려운데, 이게 있으면 혼자서도 2인 상황을 재현할 수 있습니다.

## 접속 범위

현재 구성은 UnityTransport 기본값이라 **localhost와 같은 LAN(공유기)** 안에서만 접속됩니다. 서로 다른 네트워크(각자 집)에서 붙으려면 Relay가 필요하고, 이는 필요한 시점에 별도로 도입합니다. 배경은 [integrations/netcode/setup.md](../../integrations/netcode/setup.md#3-접속-방식)를 참고하세요.

자세한 설정과 개발 규칙은 [integrations/netcode/](../../integrations/netcode/README.md)에 있습니다.

---

# 7. (선택) Claude Code 사용

Claude Code를 쓰는 팀원만 해당됩니다.

## 설치

**이 명령만 PowerShell**에서 실행하고, 터미널을 새로 연 뒤 로그인합니다. 브라우저가 열리면 **우리 팀 Claude 계정**으로 로그인합니다.

```powershell
irm https://claude.ai/install.ps1 | iex
claude --version
```

## MCP 서버 등록

여기서부터 다시 **Git Bash**입니다. 저장소 폴더에서 실행합니다.

```bash
./scripts/setup_mcp.sh          # filesystem / github / context7 / Unity MCP 등록
./scripts/setup_claude_skills.sh # Unity 전용 Skill 설치
```

`setup_mcp.sh`가 두 가지를 요구합니다.

- **GitHub Personal Access Token** — 계정 단위라 기기가 바뀌어도 유효합니다. 저장해둔 값이 있으면 그대로 씁니다.
- **Notion 최초 1회 브라우저 인증**

> ⚠️ 토큰은 비밀번호입니다. Notion, Slack, 카카오톡 어디에도 붙여넣지 마세요. 노출됐다면 GitHub의 Settings > Developer settings에서 **즉시 폐기하고 새로 발급**받습니다.

## Unity MCP 확인

Unity MCP 도구는 **`game/`을 연 Unity Editor가 실행 중일 때만** 응답합니다. Editor를 켜둔 뒤 저장소 폴더에서 Git Bash를 새로 열고 확인합니다.

```bash
unity status
```

프로젝트가 한 줄 잡히면 정상입니다. 더 확실히 보려면 Claude를 띄워 `/mcp`를 물어봅니다.

```bash
claude
/mcp
```

전부 `connected`이고 `unity-editor-mcp`에 도구가 100여 개 보이면 됩니다.

### `connected`인데 `no tools`로 뜨면

도구 목록은 CLI가 아니라 **Editor 안의 `com.unity.pipeline` 패키지**가 노출합니다. `/mcp`의 `connected`는 Claude Code ↔ CLI 구간만 확인해주기 때문에, 이 패키지가 없으면 `connected`인데 도구가 0개로 뜹니다.

이 패키지는 **`manifest.json`에 커밋되어 있어 `game/`을 Editor로 열면 자동으로 받아집니다.** 보통은 Editor를 켜고 Git Bash를 새로 열면 해결됩니다.

그래도 안 되면 `esc` → `/exit`로 Claude를 끄고 상태를 확인합니다.

```bash
unity pipeline list
```

`📦 Pipeline`이 설치됨으로 나오지 않으면 직접 설치합니다. `cd game`을 하는 이유는 Unity 프로젝트가 저장소 루트가 아니라 `game/` 폴더이기 때문입니다.

```bash
cd game
unity pipeline install
```

설치 후 **Unity Editor와 Git Bash를 모두 재실행**하고 `/mcp`와 `unity status`를 다시 확인합니다.

> `com.unity.pipeline`은 `com.unity.render-pipelines.universal`(URP)과 **무관합니다.** 이름이 겹쳐서 `manifest.json`에서 `pipeline`을 검색하면 URP가 잡히니 주의하세요.

## VS Code를 쓴다면

VS Code에서 Claude Code extension을 설치하고, 위 setup 스크립트로 MCP를 모두 활성화한 뒤 세션을 초기화합니다. MCP 도구와 서버 연결이 모두 확인되면 VS Code 설정까지 끝입니다.

---

# 8. 동작 확인

저장소 폴더의 Git Bash에서 세 가지를 확인합니다.

- [ ] `ssh -T git@github.com`에 본인 계정 이름이 나온다
- [ ] `gh auth status`에 본인 계정이 나온다
- [ ] `git status`에 **기존 파일의 수정**이 없다

나머지 세 가지는 Unity Hub에서 `game/`을 열어 Editor에서 확인합니다.

- [ ] Unity Console에 빨간 에러가 없다
- [ ] `game/Assets/Scenes/SampleScene.unity`가 열리고 Play가 된다
- [ ] `Window > General > Test Runner`에 EditMode/PlayMode 탭이 보인다

어디서 걸렸는지 알면 어디를 고칠지도 바로 나옵니다.

| 항목 | 실패하면 |
|---|---|
| ssh 확인 | 1단계로. Collaborator 초대 수락 여부도 확인 |
| gh 확인 | 4단계 로그인으로. WSL에서 해둔 로그인은 넘어오지 않습니다 |
| Console 에러 없음 | 대개 패키지 누락입니다. `packages-lock.json`을 받았는지 확인 |
| SampleScene Play | Git LFS 미설정이나 `.meta` 누락을 의심 |
| Test Runner 탭 | `packages-lock.json`이 안 받아진 상태일 가능성 |
| git status 깨끗함 | Editor 버전 불일치. 아래 경고 참고 |

> 🚨 **마지막 항목이 제일 중요합니다.**
>
> 내가 건드리지도 않은 파일이 수십·수백 개 수정된 것으로 뜬다면 거의 확실히 Editor 버전이 `6000.3.22f1`이 아닙니다. **그대로 커밋하면 팀 전원의 프로젝트가 같이 틀어집니다.** 커밋하지 말고 팀에 먼저 알리세요.

---

# 9. 본격 작업 시작 전 최종 확인

여기까지 오면 개인 환경은 끝입니다. 팀 전체 기준으로 아래가 모두 채워져야 게임 개발을 시작할 수 있습니다.

- [x] `main`에 Unity 최초 실행 커밋이 들어가 있다 (`game/Assets/**/*.meta`, `packages-lock.json` 존재)
- [x] 게임 제목 확정 → `productName`이 `NGOgame`으로 반영됨 (2026-09-02)
- [ ] 팀원 5명 전원이 0~9단계를 끝냈다
- [ ] 역할 분담이 정해지고 [.github/CODEOWNERS](../../.github/CODEOWNERS)에 반영됐다
- [ ] NetworkManager Prefab 생성 → [integrations/netcode/setup.md](../../integrations/netcode/setup.md)
- [ ] 첫 Issue 등록 및 Sprint 시작

---

# 10. 다음 단계

[docs/team/README.md](README.md)의 Branch 전략과 Unity 공동 작업 규칙을 읽습니다. 특히 아래 3가지가 사고가 잦은 지점입니다.

- Asset 추가·이동·삭제는 Unity 에디터 안에서 하기 (`.meta` GUID가 어긋나는 것을 막습니다)
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

## `gh` 명령이 인증을 요구합니다

```text
To get started with GitHub CLI, please run: gh auth login
```

로그인이 되어 있지 않은 상태입니다. 4단계의 로그인 절차를 진행하세요. **WSL에서 해둔 로그인은 Windows로 넘어오지 않습니다.** 현재 상태는 `gh auth status`로 확인합니다.

## 명령어를 못 찾습니다 (`gh` / `claude` is not recognized 등)

설치되지 않았거나, 설치 후 터미널을 새로 열지 않은 경우입니다. **Git Bash를 닫고 새로 열어보세요.** Windows는 이미 열려 있는 터미널에 PATH를 반영해주지 않습니다.

`claude`가 안 잡히면 `claude doctor`로 진단합니다. `gh`가 없으면 PowerShell에서 설치합니다.

```powershell
winget install --id GitHub.cli
```

`gh`를 설치하지 않고 GitHub 웹에서 PR을 만들어도 됩니다. push 후 저장소 페이지에 뜨는 `Compare & pull request` 버튼을 누르거나, 아래 주소로 바로 이동합니다.

```text
https://github.com/cowship/GameDev-Platform/pull/new/<브랜치이름>
```

---

# Related Documents

| Document | Description |
|---|---|
| [README.md](README.md) | 팀 협업 규칙 (Branch 전략, Unity 공동 작업 규칙) |
| [integrations/netcode/setup.md](../../integrations/netcode/setup.md) | Netcode for GameObjects 설정 |
| [integrations/unity/setup.md](../../integrations/unity/setup.md) | Unity Hub / Editor / Git LFS 기본 설정 |
| [docs/setup/README.md](../setup/README.md) | Claude Code / MCP 설정 |
| [docs/decisions/0008-windows-only-development-environment.md](../decisions/0008-windows-only-development-environment.md) | WSL을 버리고 Windows 단일 환경으로 정한 근거 |
