# Team Collaboration Guide

> 개발 5인과 그래픽 팀(아트·사운드·디자인)이 이 저장소 하나에서 Unity 멀티플레이 게임을 함께 개발하기 위한 운영 규칙입니다.

---

# 이 문서를 읽어야 하는 사람

이 저장소를 clone한 **개발팀·그래픽 팀 전원**입니다. 처음이라면 [ONBOARDING.md](ONBOARDING.md)를 먼저 끝내고 돌아오세요.

그래픽 팀은 환경 구축(Unity 설치, SSH, Git)을 개발팀과 **똑같이** 진행하고, 이후 작업 방식은 4장(Unity 공동 작업 규칙)을 중심으로 보면 됩니다.

---

# 1. 저장소 구조

이 저장소는 **플랫폼 표준 문서**와 **실제 게임 프로젝트**를 함께 담습니다.

```text
GameDev-Platform/
├── game/                  ← Unity 프로젝트 루트 (Unity Hub로 이 폴더를 엽니다)
│   ├── Assets/
│   ├── Packages/
│   └── ProjectSettings/
│
├── agents/                 ← AI Agent 역할 정의
├── docs/                   ← 아키텍처, 의사결정(ADR), 팀 운영 문서
├── integrations/           ← Unity / GitHub / Netcode / Notion / MCP 연동 표준
├── prompts/  templates/    ← 재사용 프롬프트, 문서 템플릿
└── scripts/                ← 환경 구축 자동화 스크립트
```

> ⚠️ **Unity Hub에서 저장소 루트가 아니라 `game/` 폴더를 열어야 합니다.** 루트를 열면 Unity가 `docs/`, `scripts/` 같은 폴더까지 Asset으로 취급하려 해서 프로젝트가 정상적으로 로드되지 않습니다.

---

# 2. Branch 전략

```text
main                        ← 게임 개발 본류. 항상 열리고 실행되는 상태를 유지합니다.
├── feature/{작업이름}       ← 새 기능. main에서 분기 → PR → main
├── fix/{버그이름}           ← 버그 수정
├── chore/{작업이름}         ← 문서, 설정, 스크립트 등 비기능 변경
├── art/{작업이름}           ← 이미지·사운드 등 자산 추가/교체 (그래픽 팀)
│
└── sandbox/{본인이름}       ← 개인 실험/공부 전용. main에 직접 머지하지 않습니다.
```

## 2.1 main

| 항목 | 규칙 |
|---|---|
| 목적 | 팀이 함께 만드는 게임의 단일 기준 |
| 상태 | 언제 pull 받아도 Unity에서 열리고 Play가 되어야 함 |
| 직접 push | **금지** — 반드시 Pull Request를 통해 병합 |
| 리뷰 | 본인 외 1명 이상 Approve |
| 병합 방식 | Squash and merge (커밋 히스토리를 기능 단위로 유지) |

main이 깨지면 5명 전원이 동시에 멈춥니다. "내 로컬에서는 되는데"를 막는 것이 PR과 리뷰의 목적입니다.

> ⚠️ **이 규칙은 기술적으로 강제되지 않습니다.** 이 저장소는 GitHub Free Private이라 Branch Protection(Ruleset)을 걸 수 없습니다. 즉 마음만 먹으면 `main`에 직접 push할 수 있고, GitHub이 막아주지 않습니다.
>
> **팀의 합의로만 유지되는 규칙**이므로, 실수로 `main`에 직접 커밋하지 않도록 각자 아래를 습관화합니다.
>
> ```bash
> git branch --show-current   # 커밋 전에 현재 브랜치 확인
> ```
>
> 실수로 main에 커밋했다면 push하기 전에 되돌릴 수 있습니다.
>
> ```bash
> git switch -c feature/작업이름   # 커밋을 새 브랜치로 옮기고
> git switch main
> git reset --hard origin/main    # main은 원격 상태로 되돌림
> ```

## 2.2 feature / fix / chore

실제 게임 개발은 전부 이 브랜치에서 이루어집니다.

```bash
git switch main
git pull
git switch -c feature/player-movement
# ... 작업 ...
git add .
git commit -m "feat: 플레이어 이동 구현"
git push -u origin feature/player-movement
gh pr create --base main            # 또는 GitHub 웹에서 PR 생성
```

- 하나의 브랜치는 **하나의 목적**만 담습니다. PR이 커질수록 리뷰가 형식적으로 변합니다.
- 작업이 길어지면 중간에 `git merge main`으로 최신 상태를 따라갑니다. 오래 묵힐수록 Scene/Prefab 충돌이 커집니다.
- 병합 후 브랜치는 삭제합니다.

## 2.3 sandbox/{본인이름} — 개인 실험/공부 공간

각자 자기 이름의 브랜치를 하나씩 갖습니다. 여기서는 **아무거나 해도 됩니다.**

| 항목 | 규칙 |
|---|---|
| 목적 | 기능 실험, 네트워킹 튜토리얼 따라하기, 개인 학습, 실패해도 되는 시도 |
| 소유 | 브랜치 이름의 본인만 push. 다른 사람 sandbox에 push하지 않습니다 |
| 리뷰 | 불필요 |
| 커밋 메시지 | 자유 |
| force push | 허용 (본인 브랜치이므로) |
| main으로 직접 병합 | **하지 않습니다** |

### 실험이 성공했다면

sandbox를 그대로 main에 머지하지 않습니다. 실험 브랜치에는 보통 임시 코드, 테스트용 Scene, 실패한 시도가 섞여 있기 때문입니다.

```bash
# 1) main에서 깨끗한 feature 브랜치를 새로 만들고
git switch main && git pull
git switch -c feature/inventory-system

# 2) sandbox에서 쓸 파일만 골라 가져옵니다
git checkout sandbox/ajun -- game/Assets/Scripts/Gameplay/Inventory.cs

# 3) 정리한 뒤 PR
```

### sandbox를 최신으로 유지하기

```bash
git switch sandbox/ajun
git merge main        # 또는 git rebase main
```

---

# 3. Commit Convention

Conventional Commits를 따릅니다. (`main`으로 가는 브랜치에만 적용, sandbox는 자유)

```text
{type}: {요약}
```

| Type | 설명 |
|---|---|
| feat | 새로운 기능 |
| fix | 버그 수정 |
| docs | 문서 변경 |
| refactor | 동작 변화 없는 구조 개선 |
| chore | 설정, 스크립트, 패키지 등 |
| test | 테스트 추가/수정 |
| art | 아트/사운드 자산 추가·교체 |

---

# 4. Unity 공동 작업 규칙

Unity는 텍스트 코드보다 **파일 충돌에 훨씬 취약**합니다. 아래만 지켜도 사고의 대부분이 사라집니다. 4.1·4.3·4.4는 그래픽 팀에게 특히 중요합니다.

## 4.1 Asset 추가·이동·삭제는 Unity 에디터 안에서 합니다

`.meta`에는 Asset의 GUID가 들어 있고, Unity는 이 GUID로 "이 스크립트가 저 오브젝트에 붙어 있다"를 기억합니다. GUID가 어긋나면 다른 팀원의 프로젝트에서 참조가 끊어집니다(Missing Reference).

`.gitignore`에 `.meta` 제외 규칙이 없으므로 **`git add .` → commit 하는 평범한 흐름에서는 `.meta`가 알아서 따라옵니다.** 문제가 되는 건 아래 세 가지 경우뿐입니다.

| 상황 | 결과 | 대응 |
|---|---|---|
| Unity를 켜지 않고 파일만 폴더에 복사해 커밋 | `.meta`가 아직 생성되지 않은 상태로 올라감 → 팀원마다 **서로 다른 GUID**가 생겨 참조가 갈라짐 | 커밋 전에 Unity를 한 번 열어 Import를 끝냅니다 |
| 탐색기나 `mv`/`rm`으로 파일 이동·삭제 | `.meta`만 남아 고아가 되거나, 이동한 파일이 새 GUID를 받음 | Project 창에서 드래그/삭제합니다 |
| 경로를 지정해 add (`git add Player.cs`), GUI에서 파일을 하나씩 스테이징 | 짝인 `Player.cs.meta`가 빠짐 | 폴더 단위로 add 하거나 `git status`로 짝을 확인합니다 |

즉 지켜야 할 규칙은 "`.meta`를 잊지 말자"가 아니라 **"Asset 조작은 Unity 안에서, 커밋 전에 에디터를 한 번 열어둔다"** 입니다.

## 4.2 하나의 Scene은 한 번에 한 명만 수정합니다

Scene 파일은 병합이 매우 어렵습니다. 아래 순서로 회피합니다.

1. **Prefab 우선** — Scene에 직접 배치하는 대신 Prefab으로 만들고, Scene에는 Prefab만 올립니다. 그러면 각자 다른 Prefab을 수정하게 되어 충돌이 나지 않습니다.
2. **Additive Scene 분리** — UI Scene, 레벨 Scene을 나눠 서로 다른 파일을 만지게 합니다.
3. 그래도 같은 Scene을 만져야 한다면 **작업 전에 팀 채널에 알립니다.**

## 4.3 이미지·사운드는 잠그고(lock) 편집합니다

이미지·오디오·모델은 텍스트가 아니라서 **병합이 원천적으로 불가능**합니다. 코드는 "A는 10번 줄, B는 50번 줄"처럼 나눠 합칠 수 있지만, `player.png`는 Git이 보기에 그냥 바이트 덩어리라 "반씩 섞기"가 존재하지 않습니다. 두 사람이 각자 수정하면 **한쪽 작업이 통째로 사라집니다.**

그래서 이 파일들은 평소에 **읽기 전용(read-only)으로 잠겨 있습니다.** [.gitattributes](../../.gitattributes)에서 `lockable`로 지정해 두었기 때문입니다.

기억할 규칙은 한 줄입니다.

> **편집하려는데 파일이 안 열리거나 저장이 거부되면, "lock 하라"는 뜻입니다.**

```bash
git lfs lock   game/Assets/Art/Sprites/player.png   # ① 선점 → 쓰기 가능해짐
# ... 편집 ...
git add . && git commit -m "art: 플레이어 스프라이트 수정"
git push
git lfs unlock game/Assets/Art/Sprites/player.png   # ② 해제 → 다시 읽기 전용
```

잠긴 파일을 다른 사람이 수정해 push하면 **거부됩니다.** 나중에 충돌로 터지는 게 아니라 애초에 막히므로, 누군가의 작업이 조용히 사라지는 일이 없습니다.

```bash
git lfs locks   # 지금 누가 무엇을 잠갔는지 전원이 볼 수 있습니다
```

- **작업이 끝나면 바로 unlock합니다.** 잠근 채로 두면 그 파일이 팀 전체에 막힙니다.
- 잠근 사람이 자리에 없어 급하다면 저장소 관리자가 `git lfs unlock --force <경로>`로 풉니다.
- 애초에 담당 영역을 나눠 두면(6장) 같은 파일을 두고 경합할 일 자체가 거의 없습니다. lock은 그 예외 상황을 위한 안전장치입니다.

## 4.4 에셋 교체는 **같은 이름으로 덮어씁니다**

수정한 에셋을 다시 넣을 때 이름을 바꾸면 안 됩니다.

`player.png`를 고쳐서 `player_v2.png`로 올리면, Unity는 이것을 **완전히 새로운 파일**로 보고 새 GUID를 발급합니다. 그 결과 기존 `player.png`를 참조하던 Prefab과 Scene이 **전부 Missing Reference로 깨집니다.**

| 이렇게 하면 | 결과 |
|---|---|
| `player.png`를 같은 경로에 덮어쓰기 | GUID 유지 → 그 스프라이트를 쓰던 모든 오브젝트에 자동 반영 ✅ |
| `player_v2.png`로 새로 추가 | 새 GUID → 기존 참조 전부 끊김, 개발자가 일일이 다시 연결해야 함 ❌ |

버전 구분이 필요하면 저장소가 아니라 **작업 원본 쪽(Drive 등)에서** 합니다. 저장소에 들어오는 파일 이름은 고정입니다.

> 작업 원본(`.psd`, `.aseprite`, `.wav` 멀티트랙 등)은 저장소에 넣지 않습니다. 게임에 실제로 들어가는 결과물만 커밋합니다. GitHub Free는 LFS 저장 1GB / 월 대역폭 1GB라, 원본까지 넣으면 금방 차서 전원이 clone에 실패합니다.

### Unity 안에서 이름을 바꾸는 것은 안전합니다

위 규칙은 "**새 파일로 납품하지 말라**"는 뜻이지, 이름을 영영 못 바꾼다는 뜻이 아닙니다. Unity의 Project 창에서 Rename하면 파일과 `.meta`가 함께 바뀌고 **GUID는 그대로 유지**되므로, 그 에셋을 쓰던 Prefab/Scene은 그대로 동작합니다. 이름만 바꿨다면 Scene/Prefab의 diff가 비어 있는 것이 정상입니다.

단, GUID가 아니라 **문자열(이름)로 찾아 쓰는 것**은 따라오지 않으니 함께 확인합니다.

- Addressables 주소(address)를 경로 기반으로 등록해 둔 경우
- 코드에서 이름으로 조회하는 경우 (`Animator.Play("Idle")` 등)
- Animation Clip이 오브젝트 경로로 바인딩한 프로퍼티

### 삭제는 지우기 전에 참조를 확인합니다

Unity에서 지우면 `.meta`는 함께 정리되지만, **그 에셋을 참조하던 곳은 전부 Missing Reference가 됩니다.** Unity가 "아직 쓰이고 있다"고 막아주지 않으므로 직접 확인해야 합니다.

```bash
# ① 지우려는 에셋의 GUID 확인
grep "^guid:" game/Assets/Art/Character/player.png.meta

# ② 그 GUID를 쓰는 곳이 있는지 검색 — 아무것도 안 나오면 안전
grep -rl "<위에서 나온 GUID>" game/Assets \
  --include="*.unity" --include="*.prefab" --include="*.asset" \
  --include="*.mat" --include="*.controller"
```

파일이 나온다면 그 Prefab/Scene을 먼저 정리한 뒤에 지웁니다.

> 이름 변경과 삭제는 다른 사람의 브랜치와 충돌하기 쉽습니다("한쪽은 지웠고 한쪽은 고쳤다"). **다른 작업과 섞지 말고 작은 PR로 따로 올려 빨리 병합**한 뒤, 팀에 알려 전원이 pull 받게 합니다.

## 4.5 Scene/Prefab 충돌은 UnityYAMLMerge로 풉니다

`./scripts/setup_team_member.sh`가 병합 드라이버를 등록해 두면, 충돌 시 Git이 자동으로 Unity의 Smart Merge를 호출합니다. 자동 해결에 실패하면 **직접 손으로 고치지 말고** 한쪽 버전을 선택한 뒤 작업을 다시 얹는 편이 안전합니다.

```bash
git checkout --ours   game/Assets/Scenes/Main.unity   # 내 버전 채택
git checkout --theirs game/Assets/Scenes/Main.unity   # 상대 버전 채택
```

## 4.6 공용 설정 변경은 반드시 공지합니다

아래 파일은 바꾸면 전원에게 영향이 갑니다. 단독으로 바꾸지 말고 PR + 공지로 처리합니다.

- `game/ProjectSettings/**` (Player Settings, Input, Physics, Quality 등)
- `game/Packages/manifest.json`, `packages-lock.json` (패키지 추가/버전 변경)
- `game/Assets/Settings/**` (URP 설정)
- 루트의 `.gitattributes`, `.gitignore`

---

# 5. 멀티플레이(NGO) 공동 작업 규칙

네트워킹은 **Unity Netcode for GameObjects(NGO)** 를 사용합니다. Unity 공식 패키지라 별도 설치 절차가 없고, 프로젝트를 열면 자동으로 받아집니다. 자세한 내용은 [integrations/netcode/](../../integrations/netcode/README.md)를 참고하고, 협업 관점에서 특히 주의할 점은 다음과 같습니다.

- **네트워크 Prefab 목록(`NetworkPrefabsList` 자산)이 이 프로젝트에서 가장 충돌이 잦은 파일입니다.** 두 사람이 각자 네트워크 Prefab을 추가하면 같은 파일의 같은 위치를 고치게 됩니다. 네트워크 Prefab 추가는 **작은 PR로 빠르게** 병합하세요.
- 그 충돌은 **텍스트로 직접 병합하지 마세요.** GUID가 얽혀 있어 손으로 고치면 조용히 깨집니다. 한쪽을 채택하고 나머지를 Unity에서 다시 등록하는 편이 안전합니다.
- **NetworkObject Prefab**은 `game/Assets/Prefabs/Network/` 아래에 모읍니다. 충돌 지점을 한곳으로 모아 예측 가능하게 만들기 위함입니다.
- **NetworkManager는 씬이 아니라 Prefab으로 관리합니다.** 씬에 두면 그 씬이 팀의 병목이 됩니다.
- `NetworkVariable`이나 RPC의 구조를 바꾸면 클라이언트 간 호환이 깨집니다. 관련 PR은 빠르게 병합하고 팀에 공지해, 전원이 pull 받은 뒤 다음 테스트를 진행합니다.
- 멀티플레이 동작 확인은 혼자서도 가능합니다 — `Window > Multiplayer > Multiplayer Play Mode`로 빌드 없이 여러 플레이어를 띄웁니다.
- 현재 구성은 **localhost와 같은 LAN 안에서만** 접속됩니다. 각자 집에서 붙는 것은 Relay 도입 이후에 가능합니다.

---

# 6. 역할 분담

리뷰 자동 배정([.github/CODEOWNERS](../../.github/CODEOWNERS))과 짝을 이룹니다. 담당은 "그 영역을 혼자 만든다"가 아니라 **"그 영역 변경 PR을 반드시 한 번 본다"**는 뜻입니다.

| 영역 | 경로 | 담당 |
|---|---|---|
| 플랫폼/인프라 | `scripts/`, `.github/`, `docs/`, `game/ProjectSettings/` | @ajunlee0 |

**개발팀 계정**: `@cowship` `@ajunlee0` `@turing081226` `@sjy084` `@shlzzz`
**그래픽 팀 계정**: (합류 시 추가)

## 게임 코드와 자산에는 아직 담당이 없습니다

`game/Assets/Scripts/` 이하와 아트·사운드는 **일부러 비워둔 상태**입니다. 이유는 두 가지입니다.

- 기획이 확정되지 않아 **각 영역에 일이 얼마나 생길지 모릅니다.** 먼저 나누면 일이 없는 사람과 몰리는 사람이 생기고, 표만 남고 안 지켜집니다.
- 초반에는 여러 명이 같은 영역을 만져보는 편이 학습에 낫습니다. 담당을 나누면 각자 자기 영역만 보게 되어 전체 구조를 아무도 모르게 됩니다.

대신 **사고가 크게 나는 영역(공용 설정, 스크립트, 워크플로)에는 담당이 이미 지정돼 있습니다.** 역할 분담의 실질적 목적은 이 방어선이고, 그건 위 표와 CODEOWNERS에 서 있습니다. 나머지 PR은 담당자 없이 "본인 외 1명 Approve" 규칙으로 운영합니다.

> ⚠️ **비어 있다고 아무 이름이나 채우지 마세요.** CODEOWNERS는 실제로 리뷰 요청을 보냅니다. 모르는 영역에 배정된 사람은 내용을 안 보고 Approve하게 되고, 그때부터 리뷰는 형식이 됩니다.

### 언제 채우나

해당 폴더에 각자의 작업이 실제로 쌓이기 시작하면, 그때 **이미 그 영역을 만지고 있는 사람**을 담당으로 적습니다. 미리 정하는 게 아니라 사후에 기록하는 쪽이 맞습니다. 채울 때는 위 표와 [.github/CODEOWNERS](../../.github/CODEOWNERS)의 주석을 **함께** 풉니다.

## 그래픽 팀의 작업 범위

담당은 아직 없지만, **어디에 커밋하는지는 지금 정해져 있습니다.** 그래픽 팀은 `game/Assets/` 아래 **자산 폴더에만** 커밋합니다. `Scripts/`, `ProjectSettings/`, `Packages/`는 건드리지 않습니다.

| 영역 | 경로 |
|---|---|
| 아트 (스프라이트, 텍스처) | `game/Assets/Art/` |
| UI 자산 | `game/Assets/Art/UI/` |
| 사운드 (BGM, SFX) | `game/Assets/Audio/` |

**경합을 줄이는 방법은 lock이 아니라 폴더 분리입니다.** 담당별로 하위 폴더를 나눠 두면(`Art/Character/`, `Art/UI/`, `Audio/BGM/` 등) 같은 파일을 두고 부딪힐 일이 애초에 생기지 않습니다. `git lfs lock`(4.3)은 그래도 겹칠 때를 위한 안전장치입니다.

---

# 7. Pull Request 절차

1. `main`에서 작업 브랜치 생성
2. 작업 후 push, PR 생성 (대상: `main`)
3. [PR 템플릿](../../.github/PULL_REQUEST_TEMPLATE.md)의 체크리스트를 채웁니다
4. 리뷰어 1명 이상 Approve
5. Conflict 해결 후 **Squash and merge**
6. 작업 브랜치 삭제

## 리뷰할 때 보는 것

- 동작이 요구사항을 만족하는가
- Asset이 추가/이동/삭제되었다면 `.meta`가 짝으로 함께 올라왔는가 (고아 `.meta`, 짝 없는 Asset이 없는가)
- Scene/Prefab 변경이 의도한 범위인가 (의도치 않은 대량 변경은 대개 사고입니다)
- 네트워크 코드라면: 권한(Authority) 판단이 올바른가, 클라이언트가 임의로 상태를 바꾸지 않는가
- 폴더 의존성 방향을 지켰는가 ([project_template.md](../../integrations/unity/project_template.md#폴더-간-의존성-방향))

## 자산 PR(`art/*`)을 리뷰할 때

자산 PR은 코드 리뷰가 필요 없으므로 **오래 붙잡지 말고 빠르게 병합**합니다. 대신 아래 3가지만 봅니다.

- 파일과 `.meta`가 짝으로 올라왔는가 (Unity를 열지 않고 커밋하면 `.meta`가 빠집니다 → 4.1)
- 기존 자산 교체라면 **파일 이름이 그대로인가** (이름이 바뀌었다면 참조가 끊깁니다 → 4.4)
- 작업 원본(`.psd`, `.aseprite`)이 섞여 들어오지 않았는가 (→ 4.4)

---

# 8. Issue 관리

| 상황 | 처리 |
|---|---|
| 새로운 작업 | [Task Issue](../../.github/ISSUE_TEMPLATE/task.md) 생성 → 브랜치 연결 |
| 새 기능 제안 | [Feature Request](../../.github/ISSUE_TEMPLATE/feature_request.md) |
| 버그 발견 | [Bug Report](../../.github/ISSUE_TEMPLATE/bug_report.md) |
| PR 병합 | 본문에 `Closes #N`을 넣어 Issue 자동 종료 |

---

# Related Documents

| Document | Description |
|---|---|
| [ONBOARDING.md](ONBOARDING.md) | 팀원이 처음 한 번 수행하는 환경 구축 절차 |
| [integrations/github/workflow.md](../../integrations/github/workflow.md) | Branch/Commit/PR 표준 (원본) |
| [integrations/unity/workflow.md](../../integrations/unity/workflow.md) | Unity 버전 관리 규칙, Smart Merge, LFS Locking (원본) |
| [integrations/netcode/setup.md](../../integrations/netcode/setup.md) | Netcode for GameObjects 설정 |
| [integrations/unity/project_template.md](../../integrations/unity/project_template.md) | Assets 폴더 구조와 의존성 방향 |
| [docs/decisions/0006-game-development-in-platform-repository.md](../decisions/0006-game-development-in-platform-repository.md) | 게임을 이 저장소에서 개발하기로 한 결정 근거 |
| [docs/decisions/0009-netcode-for-gameobjects.md](../decisions/0009-netcode-for-gameobjects.md) | 멀티플레이 스택을 NGO로 정한 결정 근거 |
