# Team Collaboration Guide

> 5인 팀이 이 저장소 하나에서 Unity + Photon Fusion 멀티플레이 게임을 함께 개발하기 위한 운영 규칙입니다.

---

# 이 문서를 읽어야 하는 사람

이 저장소를 clone한 팀원 전원입니다. 처음이라면 [ONBOARDING.md](ONBOARDING.md)를 먼저 끝내고 돌아오세요.

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
├── integrations/           ← Unity / GitHub / Photon / Notion / MCP 연동 표준
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
| 목적 | 기능 실험, Fusion 튜토리얼 따라하기, 개인 학습, 실패해도 되는 시도 |
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

Unity는 텍스트 코드보다 **파일 충돌에 훨씬 취약**합니다. 아래 4가지만 지켜도 사고의 대부분이 사라집니다.

## 4.1 `.meta` 파일은 항상 함께 커밋합니다

`.meta`에는 Asset의 GUID가 들어 있습니다. 누락되면 다른 팀원의 프로젝트에서 참조가 전부 끊어집니다(Missing Reference). `git add`할 때 `.meta`가 빠지지 않았는지 확인하세요.

## 4.2 하나의 Scene은 한 번에 한 명만 수정합니다

Scene 파일은 병합이 매우 어렵습니다. 아래 순서로 회피합니다.

1. **Prefab 우선** — Scene에 직접 배치하는 대신 Prefab으로 만들고, Scene에는 Prefab만 올립니다. 그러면 각자 다른 Prefab을 수정하게 되어 충돌이 나지 않습니다.
2. **Additive Scene 분리** — UI Scene, 레벨 Scene을 나눠 서로 다른 파일을 만지게 합니다.
3. 그래도 같은 Scene을 만져야 한다면 **작업 전에 팀 채널에 알립니다.**

## 4.3 바이너리 자산은 `git lfs lock`으로 선점합니다

이미지·오디오·모델은 병합이 원천적으로 불가능합니다. 편집 전에 잠급니다.

```bash
git lfs lock game/Assets/Art/Sprites/player.png     # 잠금 (다른 사람은 push 불가)
git lfs locks                                        # 현재 잠긴 목록
git lfs unlock game/Assets/Art/Sprites/player.png    # 작업 후 해제
```

## 4.4 Scene/Prefab 충돌은 UnityYAMLMerge로 풉니다

`./scripts/setup_team_member.sh`가 병합 드라이버를 등록해 두면, 충돌 시 Git이 자동으로 Unity의 Smart Merge를 호출합니다. 자동 해결에 실패하면 **직접 손으로 고치지 말고** 한쪽 버전을 선택한 뒤 작업을 다시 얹는 편이 안전합니다.

```bash
git checkout --ours   game/Assets/Scenes/Main.unity   # 내 버전 채택
git checkout --theirs game/Assets/Scenes/Main.unity   # 상대 버전 채택
```

## 4.5 공용 설정 변경은 반드시 공지합니다

아래 파일은 바꾸면 전원에게 영향이 갑니다. 단독으로 바꾸지 말고 PR + 공지로 처리합니다.

- `game/ProjectSettings/**` (Player Settings, Input, Physics, Quality 등)
- `game/Packages/manifest.json`, `packages-lock.json` (패키지 추가/버전 변경)
- `game/Assets/Settings/**` (URP 설정)
- 루트의 `.gitattributes`, `.gitignore`

---

# 5. Photon Fusion 공동 작업 규칙

자세한 설정 절차는 [integrations/photon/setup.md](../../integrations/photon/setup.md)를 따릅니다. 협업 관점에서 특히 주의할 점은 다음과 같습니다.

- **App Id는 팀 공용 1개**를 사용합니다. 각자 다른 App Id를 쓰면 서로 접속되지 않습니다.
- **NetworkObject Prefab**은 `game/Assets/Prefabs/Network/` 아래에 모읍니다. Fusion이 관리하는 Prefab 목록이 한곳에 모여 있어야 충돌 지점을 예측할 수 있습니다.
- 네트워크 Prefab을 추가·삭제하면 Fusion의 프로젝트 설정 자산도 함께 바뀝니다. **PR에 반드시 같이 포함**시켜 주세요. 빠지면 다른 팀원 쪽에서 스폰이 실패합니다.
- 동기화 대상(`[Networked]` 프로퍼티) 추가는 클라이언트 전원이 같은 버전을 써야 동작합니다. 관련 PR은 빠르게 병합하고 팀에 공지합니다.
- 멀티플레이 동작 확인은 혼자서도 가능합니다 — Unity의 **Multiplayer Play Mode**를 쓰거나, 빌드를 2개 실행해 붙습니다.

---

# 6. 역할 분담

리뷰 자동 배정([.github/CODEOWNERS](../../.github/CODEOWNERS))과 짝을 이룹니다. 팀 상황에 맞게 채워 넣고, CODEOWNERS의 주석을 해제하세요.

| 영역 | 경로 | 담당 |
|---|---|---|
| 네트워크 / Fusion | `game/Assets/Scripts/Networking/` | (미정) |
| 게임플레이 | `game/Assets/Scripts/Gameplay/` | (미정) |
| UI | `game/Assets/Scripts/UI/` | (미정) |
| 아트 | `game/Assets/Art/` | (미정) |
| 사운드 | `game/Assets/Audio/` | (미정) |
| 플랫폼/인프라 | `scripts/`, `.github/`, `docs/`, `game/ProjectSettings/` | @ajunlee0 |

**팀원 계정**: `@cowship` `@ajunlee0` `@turing081226` `@sjy084` (+ 미확인 1명 — [.github/CODEOWNERS](../../.github/CODEOWNERS)의 "확인 필요" 참고)

담당이 정해지면 위 표와 [.github/CODEOWNERS](../../.github/CODEOWNERS)를 함께 갱신합니다.

담당은 "그 영역을 혼자 만든다"가 아니라 **"그 영역 변경 PR을 반드시 한 번 본다"**는 뜻입니다.

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
- `.meta` 누락이 없는가
- Scene/Prefab 변경이 의도한 범위인가 (의도치 않은 대량 변경은 대개 사고입니다)
- 네트워크 코드라면: 권한(Authority) 판단이 올바른가, 클라이언트가 임의로 상태를 바꾸지 않는가
- 폴더 의존성 방향을 지켰는가 ([project_template.md](../../integrations/unity/project_template.md#폴더-간-의존성-방향))

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
| [integrations/photon/setup.md](../../integrations/photon/setup.md) | Photon Fusion SDK 설치 및 App Id 설정 |
| [integrations/unity/project_template.md](../../integrations/unity/project_template.md) | Assets 폴더 구조와 의존성 방향 |
| [docs/decisions/0006-game-development-in-platform-repository.md](../decisions/0006-game-development-in-platform-repository.md) | 게임을 이 저장소에서 개발하기로 한 결정 근거 |
| [docs/decisions/0007-photon-fusion-multiplayer-stack.md](../decisions/0007-photon-fusion-multiplayer-stack.md) | Photon Fusion 및 Unity 프로젝트 구성 결정 근거 |
