# 이 저장소의 기반을 직접 만드는 법

> 이 프로젝트의 협업 기반을 처음부터 다시 만들어야 한다면 무엇을, 왜, 어떻게 해야 하는지 정리한 문서입니다.
>
> AI 도구의 도움 없이도 팀원 누구나 같은 구조를 다시 세울 수 있게 하는 것이 목적입니다.

---

# 이 문서를 읽는 방법

각 항목은 세 부분으로 되어 있습니다.

| 부분 | 뜻 |
|---|---|
| **무엇** | 무엇을 만들었는지 |
| **왜** | 그게 없으면 무슨 사고가 나는지 |
| **직접 하려면** | 빈 저장소에서 똑같이 만드는 방법 |

순서대로 읽으면 저장소를 처음부터 다시 만들 수 있습니다. 급하면 맨 아래 [처음부터 다시 만드는 순서](#처음부터-다시-만드는-순서)만 봐도 됩니다.

---

# 1. 저장소를 하나로 합쳤습니다

## 무엇

플랫폼 문서와 실제 게임을 **한 저장소**에 담았습니다. 게임은 `game/` 폴더 안에 있습니다.

```text
GameDev-Platform/
├── game/          ← Unity 프로젝트 (Unity Hub로 이 폴더를 엽니다)
├── agents/        ← AI Agent 역할 정의
├── docs/          ← 아키텍처, 결정 기록, 팀 규칙
├── integrations/  ← Unity / GitHub / Netcode / Notion / MCP 연동 표준
├── prompts/       ← 재사용 프롬프트
├── templates/     ← 문서 템플릿
└── scripts/       ← 환경 구축 자동화 스크립트
```

## 왜

저장소를 둘로 나누면 문서와 코드가 따로 놀게 됩니다. 규칙을 고쳤는데 게임 쪽은 옛날 규칙을 쓰는 일이 생깁니다. 5명이 저장소 두 개를 각각 clone하고 각각 최신으로 맞추는 것도 부담입니다.

대신 **Unity 프로젝트를 저장소 루트에 두면 안 됩니다.** Unity는 자기 폴더 아래의 모든 파일을 Asset으로 읽으려 하기 때문에, `docs/`나 `scripts/`까지 Asset 취급하다가 프로젝트가 제대로 열리지 않습니다. 그래서 게임을 `game/` 한 칸 아래로 내렸습니다.

## 직접 하려면

1. GitHub에서 빈 저장소를 만들고 clone합니다.
2. Unity Hub에서 새 프로젝트를 만들되, 저장 위치를 저장소 안의 `game` 폴더로 지정합니다.
3. 팀에게 **"Unity Hub로 루트가 아니라 `game/`을 연다"** 를 명확히 알립니다. 이건 실수가 아주 잦은 지점입니다.

배경: [ADR 0006](../decisions/0006-game-development-in-platform-repository.md)

---

# 2. `.gitignore` — Unity가 자동으로 만드는 것은 올리지 않습니다

## 무엇

`Library/`, `Temp/`, `Obj/`, `Logs/`, `UserSettings/`, `*.csproj`, `*.sln` 같은 것들을 Git 추적에서 제외했습니다. 경로는 전부 `/game/` 으로 시작하게 적었습니다.

## 왜

이 폴더들은 Unity가 프로젝트를 열 때마다 **각자의 컴퓨터에서 새로 만드는** 것들입니다. 내용이 사람마다 다르고, 크기도 수 GB까지 갑니다.

커밋하면 두 가지 일이 벌어집니다. 저장소가 감당 못 할 만큼 무거워지고, pull 받을 때마다 아무도 고치지 않은 파일에서 충돌이 납니다.

반대로 **반드시 올려야 하는 것**도 있습니다. `Packages/manifest.json`, `Packages/packages-lock.json`, `ProjectSettings/` 는 올립니다. 이게 있어야 다른 사람이 열었을 때 같은 패키지, 같은 설정으로 열립니다.

## 직접 하려면

Unity 공식 `.gitignore`([github/gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore))를 가져다 쓰되, 우리처럼 게임이 하위 폴더에 있으면 **모든 경로 앞에 `/game/` 을 붙입니다.**

```gitignore
/game/[Ll]ibrary/
/game/[Tt]emp/
/game/[Oo]bj/
/game/[Bb]uild/
/game/[Ll]ogs/
/game/[Uu]ser[Ss]ettings/
/game/*.csproj
/game/*.sln
```

`[Ll]` 은 대소문자 어느 쪽으로 만들어져도 잡기 위한 표기입니다.

> 이 저장소에는 한 줄이 더 있습니다. `/game/ProjectSettings/VirtualProjectsConfig.json` — ProjectSettings 아래에 있지만 Multiplayer Play Mode가 만드는 **개인 설정**이라 공유 대상이 아닙니다.

실제 파일: [.gitignore](../../.gitignore)

---

# 3. `.gitattributes` — 충돌을 미리 막는 설정

이 파일 하나가 Unity 협업 사고의 대부분을 막습니다. 세 가지 일을 합니다.

## 3-1. 줄바꿈 통일

**무엇**: `* text=auto` 를 넣고, 셸 스크립트는 `*.sh text eol=lf` 로 고정했습니다.

**왜**: Windows와 다른 OS는 줄바꿈 문자가 다릅니다. 그냥 두면 아무도 안 고친 파일이 "전체 줄이 바뀜"으로 표시되어 diff가 쓸모없어집니다. 그리고 `.sh` 파일은 줄바꿈이 Windows식(CRLF)이면 **실행 자체가 실패합니다.**

**직접 하려면**: 위 두 줄을 먼저 넣습니다.

## 3-2. Scene/Prefab은 Unity 전용 병합기로

**무엇**: `.unity`, `.prefab`, `.asset`, `.mat`, `.controller`, `.meta` 등에 `merge=unityyamlmerge` 를 지정했습니다.

**왜**: Scene과 Prefab은 텍스트처럼 보이지만 Git이 기본 방식으로 합치면 **파일이 깨집니다.** Unity가 `UnityYAMLMerge`라는 전용 병합 도구를 제공하므로, 충돌 시 Git이 그 도구를 부르도록 연결해 둔 것입니다.

**직접 하려면**: `.gitattributes`에 위 줄을 적고, 팀원 각자가 로컬에 병합 도구를 등록해야 합니다(설정은 저장소가 아니라 개인 Git 설정에 들어갑니다). 우리는 그 등록을 [scripts/setup_team_member.sh](../../scripts/setup_team_member.sh)가 대신 하게 만들었습니다(9번 항목).

## 3-3. 이미지·사운드는 LFS로 보내고, 잠글 수 있게 합니다

**무엇**: `.png`, `.psd`, `.fbx`, `.wav`, `.mp4`, `.ttf` 같은 바이너리에 `filter=lfs ... lockable` 을 붙였습니다.

**왜**: 두 가지 문제를 동시에 해결합니다.

- **저장소가 무거워지는 문제** — 이미지는 조금만 고쳐도 파일 전체가 새로 저장됩니다. 수정을 반복하면 저장소가 계속 커지고, 나중에 clone하는 사람이 몇 GB를 받게 됩니다. Git LFS는 실제 파일을 따로 보관하고 저장소에는 주소만 남깁니다.
- **작업이 사라지는 문제** — 이미지는 "반씩 섞어 합치기"가 불가능합니다. 두 사람이 각자 고치면 **한쪽 작업이 통째로 없어집니다.** `lockable`을 붙이면 그 파일들이 평소 읽기 전용이 되고, 편집하려면 먼저 `git lfs lock`으로 선점해야 합니다. 남이 잠근 파일은 push 자체가 거부되므로, 나중에 터지지 않고 처음부터 막힙니다.

```bash
git lfs lock   game/Assets/Art/Sprites/player.png   # 선점 (쓰기 가능해짐)
# ... 편집하고 커밋, push ...
git lfs unlock game/Assets/Art/Sprites/player.png   # 해제
git lfs locks                                       # 누가 뭘 잠갔는지 전원이 확인
```

**직접 하려면**:

```bash
git lfs install                    # 각자 1회
git lfs track "*.png" --lockable   # .gitattributes에 자동으로 줄이 추가됩니다
```

> ⚠️ **LFS 설정은 첫 커밋 전에 끝내야 합니다.** 이미 커밋된 이미지는 나중에 LFS로 옮겨도 저장소 히스토리에 그대로 남습니다.
>
> ⚠️ GitHub Free는 LFS 저장 1GB, 월 다운로드 1GB입니다. 작업 원본(`.psd`, `.aseprite`)까지 넣으면 금방 차서 **전원이 clone에 실패합니다.** 게임에 실제로 들어가는 결과물만 커밋합니다.

실제 파일: [.gitattributes](../../.gitattributes)

---

# 4. Branch 전략

## 무엇

네 종류로 나눴습니다.

```text
main                  ← 항상 열리고 실행되는 상태를 유지
feature/{이름}         ← 새 기능
fix/{이름}             ← 버그 수정
chore/{이름}           ← 문서·설정·스크립트
art/{이름}             ← 이미지·사운드 (그래픽 팀)
sandbox/{본인이름}      ← 개인 실험 공간. main에 직접 머지하지 않음
```

## 왜

`main`이 깨지면 5명이 동시에 멈춥니다. PR과 리뷰는 "내 컴퓨터에서는 되는데"가 main까지 가지 않게 막는 장치입니다.

`sandbox/{이름}`을 따로 둔 이유는 **실패할 자유**를 주기 위해서입니다. 튜토리얼을 따라 하거나 실험하는 코드까지 PR을 거치게 하면 아무도 실험을 안 하게 됩니다. sandbox는 커밋 메시지도 자유이고 force push도 됩니다. 대신 여기엔 임시 코드가 섞이므로 통째로 main에 넣지 않고, 성공한 파일만 골라 새 feature 브랜치로 옮깁니다.

## 직접 하려면

특별한 설정이 필요 없습니다. 규칙을 문서로 적고 팀이 지키면 됩니다.

> ⚠️ **우리 저장소는 이 규칙을 기술적으로 강제하지 못합니다.** GitHub Free의 Private 저장소에서는 Branch Protection(Ruleset)을 쓸 수 없어서, 마음만 먹으면 `main`에 직접 push할 수 있습니다. 그래서 커밋 전에 브랜치를 확인하는 습관이 필요합니다.
>
> ```bash
> git branch --show-current
> ```
>
> 저장소를 Public으로 바꾸거나 유료 플랜을 쓰면 그때는 GitHub이 직접 막아줍니다.

실제 문서: [docs/team/README.md](../team/README.md) 2장

---

# 5. Commit 규칙

## 무엇

Conventional Commits를 씁니다. `{종류}: {요약}` 형식입니다.

| 종류 | 뜻 |
|---|---|
| `feat` | 새 기능 |
| `fix` | 버그 수정 |
| `docs` | 문서 |
| `refactor` | 동작은 그대로, 구조만 개선 |
| `chore` | 설정·스크립트·패키지 |
| `test` | 테스트 |
| `art` | 아트·사운드 자산 |

## 왜

나중에 "언제 뭐가 바뀌었지"를 찾을 때 히스토리가 목록처럼 읽힙니다. 형식이 정해져 있으면 커밋 메시지를 고민하는 시간도 줄어듭니다.

sandbox 브랜치는 예외입니다. 개인 공간이므로 자유입니다.

## 직접 하려면

문서에 표를 적어두고 PR 체크리스트에 한 줄 넣습니다. 도구는 필요 없습니다.

---

# 6. GitHub 템플릿 — PR / Issue / CODEOWNERS

## 무엇

`.github/` 폴더에 네 가지를 넣었습니다.

| 파일 | 역할 |
|---|---|
| `PULL_REQUEST_TEMPLATE.md` | PR을 열면 본문이 자동으로 채워집니다 |
| `ISSUE_TEMPLATE/task.md` / `bug_report.md` / `feature_request.md` | Issue 종류별 서식 |
| `CODEOWNERS` | 특정 폴더가 바뀌면 담당자에게 리뷰가 자동 요청됩니다 |

## 왜

**PR 템플릿**은 리뷰어가 매번 같은 것을 묻지 않게 해줍니다. 특히 Unity에서 잊기 쉬운 것들을 체크리스트로 박아두었습니다 — `.meta`를 같이 커밋했는지, 네트워크 Prefab을 추가했으면 `NetworkPrefabsList`도 같이 올렸는지 같은 항목입니다.

**CODEOWNERS**는 "사고가 크게 나는 영역"만 지정했습니다. `scripts/`, `.github/`, `game/ProjectSettings/`, `game/Packages/` 처럼 잘못 건드리면 팀 전원이 멈추는 곳입니다.

게임 코드와 아트는 **일부러 담당을 비워뒀습니다.** 기획이 정해지기 전에 나누면 일이 몰리는 사람과 없는 사람이 생기고, 표만 남고 안 지켜집니다. 그리고 초반엔 여러 명이 같은 영역을 만져보는 편이 학습에 낫습니다.

## 직접 하려면

1. `.github/PULL_REQUEST_TEMPLATE.md` 를 만들면 끝입니다. GitHub가 알아서 씁니다.
2. Issue 템플릿은 `.github/ISSUE_TEMPLATE/` 아래에 여러 개 두면 "New issue" 화면에서 고를 수 있습니다.
3. CODEOWNERS는 `경로  @계정` 한 줄씩 적습니다.

> ⚠️ **CODEOWNERS에 없는 계정을 적으면 GitHub이 조용히 무시합니다.** 오타가 나도 에러가 안 뜨므로 실제 ID를 확인하고 적으세요.
>
> ⚠️ 자리를 채우려고 아무 이름이나 넣지 마세요. 모르는 영역에 배정된 사람은 내용을 안 보고 Approve하게 되고, 그때부터 리뷰는 형식이 됩니다.

실제 파일: [.github/](../../.github/)

---

# 7. GitHub Actions — 자동 점검 두 개

## 무엇

PR을 올리면 자동으로 도는 검사 두 개를 붙였습니다.

| 워크플로 | 하는 일 |
|---|---|
| `shellcheck.yml` | `scripts/*.sh` 를 정적 분석해서 셸 스크립트 버그를 찾습니다 |
| `agent-drift-check.yml` | Agent 정의 파일 3벌이 서로 어긋났는지 점검합니다 |

## 왜

**shellcheck**: `scripts/`의 스크립트는 팀원이 온보딩할 때 **그대로 실행하는 진입점**입니다. 여기에 버그가 있으면 신규 팀원이 첫날부터 막힙니다. 특히 "조건이 맞을 때만 실행되는 부분"은 사람이 테스트로 잡기 어려운데, 정적 분석은 실행 안 해도 찾아줍니다.

**agent-drift-check**: Agent 정의가 `agents/`, `.claude/agents/`, `.claude/commands/` 세 곳에 나뉘어 있어 사람이 손으로 맞춰야 합니다. 하나만 고치고 나머지를 잊는 일이 반복돼서 자동 점검을 붙였습니다.

둘 다 **머지를 막는 관문이 아니라 사후 안전망**입니다. Free 플랜이라 필수 검사로 지정할 수 없기 때문이기도 하고, 초반에 관문부터 세우면 개발이 느려지기 때문이기도 합니다.

## 직접 하려면

`.github/workflows/` 아래에 `.yml` 파일을 두면 GitHub이 알아서 실행합니다. 무료 러너(`ubuntu-latest`)에는 shellcheck가 이미 깔려 있어서 추가 설치 없이 바로 씁니다.

`paths:` 로 대상 폴더를 좁혀두면 관련 없는 PR에서 헛돌지 않습니다.

```yaml
on:
  pull_request:
    paths:
      - "scripts/*.sh"
```

> Unity 빌드를 CI에서 돌리는 것은 **하지 않았습니다.** Unity 라이선스를 CI에 물려야 하고 빌드 시간이 길어서, 팀 규모 대비 이득이 적습니다. 동작 확인은 각자 Editor에서 합니다.

실제 파일: [.github/workflows/](../../.github/workflows/)

---

# 8. 온보딩 문서 — 신규 팀원이 혼자 끝낼 수 있게

## 무엇

[docs/team/ONBOARDING.md](../team/ONBOARDING.md) 하나에 Git 설치부터 Unity 실행, 멀티플레이 확인까지 순서대로 적었습니다. 마지막에 Troubleshooting 절을 붙였습니다.

## 왜

같은 질문이 5번 반복되면 그건 문서가 없다는 뜻입니다. 특히 환경 구축은 **한 번만 하고 다시 안 하는 작업**이라 아무도 기억하지 못합니다.

Troubleshooting을 같은 문서에 붙인 이유는, 막힌 사람이 다른 문서를 찾으러 가지 않게 하기 위해서입니다. 실제로 겪은 문제만 적습니다 — 회사·학교 네트워크에서 SSH 22번 포트가 막히는 문제, `gh`가 설치 안 된 문제 같은 것들이 그렇게 들어갔습니다.

## 직접 하려면

**첫 팀원이 환경을 구축할 때 그 과정을 그대로 받아적는 것**이 가장 정확합니다. 미리 상상해서 쓰면 반드시 빠지는 단계가 생깁니다.

- 명령어는 복사해서 바로 붙여넣을 수 있게 적습니다.
- "성공했는지 확인하는 법"을 각 단계마다 넣습니다.
- 누군가 막힐 때마다 Troubleshooting에 한 줄씩 추가합니다.

---

# 9. 자동화 스크립트 — 반복되는 설정은 스크립트로

## 무엇

[scripts/setup_team_member.sh](../../scripts/setup_team_member.sh) 하나로 팀원의 로컬 환경을 맞춥니다.

1. Git 사용자 정보 확인
2. Git LFS 초기화
3. UnityYAMLMerge 병합 도구 등록
4. 개인 `sandbox/{이름}` 브랜치 생성

## 왜

이 4가지는 **저장소에 담을 수 없는 설정**입니다. 각자의 컴퓨터 Git 설정에 들어가야 하는 값이라, clone만으로는 절대 따라오지 않습니다. 문서로만 안내하면 5명 중 한둘은 빠뜨리고, 그 사람만 Scene 충돌 때 이상하게 동작합니다.

**여러 번 실행해도 안전하게** 만든 것이 중요합니다(이미 되어 있으면 건너뜁니다). 그래야 "내가 이거 했었나?" 싶을 때 그냥 다시 돌려보라고 할 수 있습니다.

## 직접 하려면

- 실행 환경을 하나로 고정합니다. 우리는 **Windows + Git Bash**입니다. Unity가 Windows에서 돌아야 해서 저장소도 Windows 드라이브에 있어야 하기 때문입니다.
- 스크립트 맨 위 주석에 "무엇을 하는지"를 번호로 적습니다. 실행하는 사람이 읽고 안심할 수 있어야 합니다.
- 이미 되어 있는 항목은 건너뛰게 만듭니다.
- `.gitattributes`에 `*.sh text eol=lf` 를 꼭 넣습니다(3-1 참고). 없으면 Windows에서 스크립트가 실행되지 않습니다.

---

# 10. Unity Assets 폴더 구조

## 무엇

`game/Assets/` 아래 구조를 미리 정해두고, 프로젝트를 만들자마자 빈 폴더로 만들어 커밋했습니다.

```text
Assets/
├── Scripts/
│   ├── Core/         # 기반 인터페이스. 다른 폴더에 의존하지 않음
│   ├── Gameplay/     # 실제 플레이 로직
│   ├── UI/           # HUD, 메뉴, 팝업
│   ├── Systems/      # 전역 서비스 (저장, 오디오, 씬 로딩)
│   ├── Utilities/    # 상태 없는 순수 헬퍼
│   └── Editor/       # 에디터 전용. 폴더명 덕분에 빌드에서 자동 제외됨
├── Prefabs/
│   └── Network/      # NetworkObject Prefab만 모읍니다 (11번 참고)
├── Scenes/
├── ScriptableObjects/
├── Materials/
├── Art/     (Sprites / Textures / Fonts)
├── Audio/   (Music / SFX)
├── Settings/
├── Tests/   (EditMode / PlayMode)
└── ThirdParty/       # 외부 자산. 직접 수정하지 않습니다
```

## 왜

**나중에 옮기는 것이 처음에 정하는 것보다 훨씬 비쌉니다.** Unity에서 파일을 옮기면 참조가 얽혀 있어 사고가 나기 쉽고, 여러 사람이 동시에 작업 중이면 충돌이 크게 납니다.

폴더 사이에는 **의존 방향**도 정했습니다.

```text
Core, Utilities  →  (아무것도 참조하지 않음)
Systems          →  Core
Gameplay         →  Core, Systems
UI               →  Core, Systems   (Gameplay와는 이벤트로 통신)
```

방향을 정해두면 나중에 한 부분만 떼어내거나 테스트하기 쉽습니다. 반대 방향 참조(예: Core가 Gameplay를 참조)가 보이면 리뷰에서 반려합니다.

`Resources/` 폴더는 만들지 않습니다. 이 폴더에 넣은 것은 **쓰든 안 쓰든 전부 빌드에 들어가서** 용량과 로딩 시간이 늘어납니다. 런타임 로딩은 Addressables를 씁니다.

## 직접 하려면

1. Unity의 Project 창에서 폴더를 만듭니다(탐색기 말고 Unity 안에서).
2. Git은 빈 폴더를 추적하지 않으므로, 폴더를 만들면 생기는 `.meta` 파일을 커밋하면 됩니다.
3. 의존 방향을 문서에 적고 PR 리뷰 항목에 넣습니다.

> 규모가 커져서 리뷰만으로 방향을 못 지키게 되면 그때 Assembly Definition으로 물리적으로 분리하는 것을 검토합니다. 지금은 단순함을 우선해서 보류했습니다.

실제 문서: [integrations/unity/project_template.md](../../integrations/unity/project_template.md)

---

# 11. 멀티플레이(NGO) 협업 규칙

## 무엇

네트워킹은 Unity 공식 패키지인 **Netcode for GameObjects(NGO)** 를 씁니다. 협업 관점에서 세 가지 규칙을 정했습니다.

1. **NetworkManager는 씬이 아니라 Prefab으로 관리합니다.**
2. **NetworkObject Prefab은 `game/Assets/Prefabs/Network/` 아래에 모읍니다.**
3. **네트워크 Prefab 추가는 작은 PR로 빠르게 병합합니다.**

## 왜

**1번** — NetworkManager를 씬에 두면 네트워크 설정을 바꿀 때마다 그 씬 파일을 고쳐야 합니다. 씬은 병합이 어려워서, 결국 **그 씬이 팀 전체의 병목**이 됩니다. Prefab으로 빼면 씬을 건드리지 않고 설정만 고칠 수 있습니다.

**2번** — 충돌이 날 수 있는 자리를 한 곳에 모으기 위해서입니다. 어디를 조심해야 하는지 예측 가능해집니다.

**3번** — 네트워크 Prefab을 등록하면 `NetworkPrefabsList` 라는 목록 자산에 줄이 추가됩니다. 두 사람이 각자 Prefab을 추가하면 **같은 파일의 같은 위치**를 고치게 되어 거의 반드시 충돌합니다.

이 충돌은 **텍스트로 직접 합치면 안 됩니다.** 안에 GUID가 얽혀 있어서 손으로 고치면 겉보기엔 멀쩡한데 조용히 깨집니다. 한쪽을 통째로 채택하고, 나머지는 Unity에서 다시 등록하는 편이 안전합니다.

## 직접 하려면

1. Package Manager에서 `com.unity.netcode.gameobjects` 를 추가합니다. 공식 패키지라 계정 발급이나 SDK import가 없습니다.
2. `com.unity.multiplayer.playmode` 도 추가합니다. **빌드 없이 Editor에서 여러 플레이어를 띄워** 테스트할 수 있어서 확인 속도가 크게 빨라집니다.
3. 위 세 규칙을 팀 문서와 PR 체크리스트에 적습니다.

> 현재 구성은 localhost와 같은 LAN 안에서만 접속됩니다. 각자 집에서 붙으려면 Relay 도입이 필요하고, 그건 게임이 어느 정도 돌아간 다음에 판단할 일입니다.

실제 문서: [integrations/netcode/](../../integrations/netcode/README.md), 배경: [ADR 0009](../decisions/0009-netcode-for-gameobjects.md)

---

# 12. Unity 버전과 패키지 고정

## 무엇

- Editor 버전은 `game/ProjectSettings/ProjectVersion.txt` 에 적힌 값(`6000.3.22f1`)이 기준입니다.
- `Packages/manifest.json` 과 `packages-lock.json` 을 둘 다 커밋합니다.
- 이 파일들을 바꾸는 것은 CODEOWNERS 대상이고, 바꿀 때는 팀에 공지합니다.

## 왜

**버전이 다르면 프로젝트 파일이 조용히 바뀝니다.** 더 높은 버전으로 열면 Unity가 자산 형식을 자동 업그레이드하는데, 낮은 버전 사람은 그걸 열지 못하게 됩니다. 한 사람이 실수로 다른 버전으로 열면 전원이 따라 올려야 합니다.

`packages-lock.json` 은 "실제로 어떤 버전이 설치됐는지"를 기록한 파일입니다. `manifest.json` 만 있으면 사람마다 다른 버전이 해석돼 들어올 수 있습니다. lock 파일까지 커밋해야 전원이 **정확히 같은 패키지**로 열립니다.

## 직접 하려면

1. Unity Hub에서 팀 전원이 같은 Editor 버전을 설치합니다.
2. `ProjectVersion.txt` 를 커밋하고, 이 파일이 기준임을 문서에 명시합니다.
3. 프로젝트를 열 때 "버전이 다르다"는 경고가 뜨면 **그냥 넘기지 말고** 맞는 버전을 설치합니다.
4. 패키지 추가는 개인이 몰래 하지 않고 PR + 공지로 처리합니다.

---

# 13. 결정을 기록합니다 (ADR)

## 무엇

중요한 기술 결정은 `docs/decisions/` 에 번호를 붙여 남깁니다. 지금까지 9개가 있습니다. 예를 들어 [ADR 0007](../decisions/0007-photon-fusion-multiplayer-stack.md)에서 Photon Fusion을 골랐다가, [ADR 0009](../decisions/0009-netcode-for-gameobjects.md)에서 NGO로 바꾼 과정이 그대로 남아 있습니다.

## 왜

몇 달 지나면 **왜 그렇게 했는지 아무도 기억하지 못합니다.** 그러면 같은 논의를 처음부터 다시 하거나, 이유가 있어서 그렇게 둔 것을 "이상한데?" 하며 되돌려 놓습니다.

되돌린 결정을 지우지 않고 새 번호로 덮는 이유도 같습니다. **왜 바꿨는지**가 결정 자체만큼 중요한 정보이기 때문입니다.

## 직접 하려면

[templates/adr.md](../../templates/adr.md)를 복사해서 씁니다. 형식은 간단합니다.

```markdown
# ADR 000N: 제목
## Status      (Accepted / Superseded by ADR 000M)
## Context     무슨 상황이었나
## Decision    무엇으로 정했나
## Consequences 그래서 뭐가 좋아지고 뭘 감수하나
## Alternatives 검토했지만 안 고른 것과 그 이유
```

- 파일명은 `000N-제목.md` 로 번호를 붙입니다.
- 번호는 다시 쓰지 않습니다. 결정이 바뀌면 새 번호로 쓰고 옛날 것에 "0009로 대체됨"이라고 표시합니다.
- **모든 것을 다 적지 않습니다.** 나중에 누가 "왜 이렇게 했지?" 하고 물어볼 만한 것만 적습니다.

---

# 14. (선택) AI Agent 시스템

## 무엇

`agents/` 폴더에 역할별 정의(Technical Lead, PM, Documentation, Unity, QA, Game Designer)를 두고, Claude Code에서 `/기술리드` 같은 명령으로 부를 수 있게 연결했습니다. `CLAUDE.md` 는 프로젝트 전체의 규칙을 AI에게 알려주는 파일입니다.

## 왜

같은 프로젝트 규칙을 매번 설명하지 않기 위해서입니다. `CLAUDE.md` 에 "Unity 경로는 `game/Assets/`", "main에 직접 push 금지" 같은 규칙을 적어두면 AI가 그걸 전제로 움직입니다.

## 직접 하려면

**이 부분은 없어도 나머지가 전부 동작합니다.** 1~13번은 Git과 GitHub, Unity만 있으면 됩니다.

AI를 쓴다면 `CLAUDE.md` 하나부터 시작하는 것을 권합니다. 프로젝트 구조, 폴더 규칙, 협업 규칙만 적어도 효과가 큽니다.

---

# 처음부터 다시 만드는 순서

빈 저장소에서 시작한다면 이 순서가 안전합니다. **첫 커밋 전에 끝내야 하는 것**이 앞에 옵니다.

| # | 할 일 | 왜 이 순서인가 |
|---|---|---|
| 1 | GitHub에 빈 저장소 생성 → clone | |
| 2 | `.gitignore` 작성 | Unity가 만든 대용량 폴더가 커밋되기 전에 |
| 3 | `.gitattributes` 작성 + `git lfs install` | **첫 커밋 전에 해야 합니다.** 나중에 하면 히스토리에 원본이 남습니다 |
| 4 | Unity Hub로 `game/` 폴더에 프로젝트 생성 | 루트가 아니라 하위 폴더 |
| 5 | Assets 폴더 구조를 Unity 안에서 생성 | 나중에 옮기면 참조가 깨집니다 |
| 6 | 필요한 패키지 추가 (NGO 등) → 첫 커밋 | `packages-lock.json` 도 함께 |
| 7 | `.github/` 템플릿과 CODEOWNERS 추가 | 두 번째 PR부터 바로 적용됩니다 |
| 8 | 팀 규칙 문서 작성 (브랜치·커밋·Unity 협업) | 팀원 합류 전에 |
| 9 | 온보딩 문서 + 설정 스크립트 작성 | 두 번째 팀원이 이걸로 혼자 끝냅니다 |
| 10 | GitHub Actions 추가 | 여유 있을 때. 없어도 개발은 됩니다 |
| 11 | 팀원 합류 → 막힌 곳마다 Troubleshooting에 추가 | 문서는 여기서부터 정확해집니다 |

---

# 이것만은 기억하세요

시간이 없어서 하나만 고른다면, 순서대로 다음 세 가지입니다.

1. **`.gitattributes` 와 Git LFS 를 첫 커밋 전에 설정합니다.** 나중에 되돌리기가 가장 어렵습니다.
2. **`.meta` 파일은 짝으로 커밋합니다.** 이걸 놓치면 다른 팀원의 프로젝트에서 참조가 조용히 끊깁니다. 지키는 방법은 "`.meta`를 기억하자"가 아니라 **"Asset 조작은 Unity 안에서 하고, 커밋 전에 Editor를 한 번 열어둔다"** 입니다.
3. **Scene 대신 Prefab으로 작업합니다.** Scene은 병합이 어려워서, 여러 명이 만지는 순간 팀의 병목이 됩니다.

---

# Related Documents

| Document | Description |
|---|---|
| [docs/team/README.md](../team/README.md) | 팀 운영 규칙 전문 (브랜치, 커밋, Unity 협업, 리뷰) |
| [docs/team/ONBOARDING.md](../team/ONBOARDING.md) | 신규 팀원 환경 구축 절차 |
| [integrations/unity/project_template.md](../../integrations/unity/project_template.md) | Assets 폴더 구조와 의존성 방향 (원본) |
| [integrations/unity/workflow.md](../../integrations/unity/workflow.md) | Unity 버전 관리, Smart Merge, LFS Locking (원본) |
| [integrations/github/workflow.md](../../integrations/github/workflow.md) | Branch / Commit / PR 표준 (원본) |
| [integrations/netcode/README.md](../../integrations/netcode/README.md) | NGO 연동 표준 |
| [docs/decisions/](../decisions/) | 지금까지의 기술 결정 기록 (ADR) |
