# Unity Project Template

> 새로운 게임 Repository가 최초 생성 시 따라야 할 표준 프로젝트 구조입니다.

---

# Overview

이 문서는 실제로 복사할 수 있는 Unity 프로젝트 파일이 아니라 **스펙 문서**입니다. GameDev-Platform은 게임 코드를 직접 담지 않으므로([`README.md`](../../README.md)), 각 게임 Repository는 Unity Hub로 프로젝트를 새로 생성한 뒤 이 문서의 구조를 그대로 적용합니다.

세부 코딩 규칙(네이밍, Architecture Prefer/Avoid)은 [`agents/unity.md`](../../agents/unity.md)를 따르며, 본 문서는 그 골격을 Repository 전체 트리와 패키지 의존성 수준까지 확장한 것입니다. Editor 버전·Git LFS 기본 설정은 [`setup.md`](setup.md), 생성 절차 개요는 [`workflow.md`](workflow.md)를 따릅니다.

관련 결정 근거는 [ADR 0004: Unity Starter Template 구조](../../docs/decisions/0004-unity-starter-template.md)를 참고합니다.

---

# Repository Root Structure

```text
<game-repo>/
├── Assets/                    # Git 추적 (바이너리는 LFS, 아래 "Assets Structure" 참고)
├── Packages/
│   ├── manifest.json          # Git 추적 — 필수 패키지 기준선은 아래 참고
│   └── packages-lock.json     # Git 추적 — 재현 가능한 패키지 해석을 위해 반드시 커밋
├── ProjectSettings/           # Git 추적 (ProjectVersion.txt 포함, setup.md 참고)
├── UserSettings/              # gitignore 대상 (개인 Editor 환경)
├── Library/                   # gitignore 대상
├── Temp/                      # gitignore 대상
├── Obj/                       # gitignore 대상
├── Logs/                      # gitignore 대상
├── Build/  Builds/            # gitignore 대상
├── .vs/  .idea/                # gitignore 대상 (IDE)
├── .gitattributes             # Git 추적 — Git LFS 추적 규칙
├── .gitignore                  # Git 추적 — setup.md 기준 + 아래 추가 항목
├── CLAUDE.md                   # GameDev-Platform CLAUDE.md 복사/커스터마이징, Git 추적
├── agents/                     # GameDev-Platform agents/*.md 참조 복사본(선택), Git 추적
└── README.md                   # 게임 프로젝트 소개, Git 추적
```

---

# Assets Structure

```text
Assets/
├── Scripts/
│   ├── Core/          # 프로젝트 전역 인터페이스/기반 클래스. 다른 폴더에 의존하지 않음
│   ├── Gameplay/       # 실제 플레이 로직(PlayerController, AI, 상호작용 오브젝트 등)
│   ├── UI/              # HUD/Menu/Popup. Gameplay와는 직접 참조 대신 Event로 통신
│   ├── Systems/         # 전역 서비스(SaveSystem, AudioSystem, SceneLoader 등). Singleton 남용 지양
│   ├── Utilities/       # 상태를 갖지 않는 순수 헬퍼(확장 메서드, 수학 유틸 등)
│   └── Editor/          # Custom Inspector 등 Editor 전용 확장. 폴더명으로 빌드 자동 제외
│
├── Prefabs/
├── Scenes/
├── ScriptableObjects/
├── Materials/
├── Art/
│   ├── Models/
│   ├── Textures/
│   ├── Sprites/
│   └── Fonts/
├── Audio/
│   ├── Music/
│   └── SFX/
├── Settings/
│   ├── Input/          # Input Actions 자산(.inputactions)
│   └── Rendering/      # URP Asset, Quality 설정 등
├── AddressableAssetsData/   # Addressables 최초 설정 시 자동 생성. Git 추적(그룹 설정 재현을 위해)
├── Tests/
│   ├── EditMode/        # EditMode.asmdef 필요
│   └── PlayMode/        # PlayMode.asmdef 필요
└── ThirdParty/           # Asset Store 등 외부 자산. 직접 수정 금지, 별도 관리
```

> `Resources/` 폴더는 생성하지 않습니다. 런타임 로딩은 Addressables를 사용합니다(`agents/unity.md`의 "Addressables 고려" 원칙).

## 폴더 간 의존성 방향

```text
Core, Utilities  →  (의존 없음)
Systems          →  Core
Gameplay         →  Core, Systems
UI               →  Core, Systems   (Gameplay와는 Event/Interface로 통신)
```

이 방향을 어기는 참조(예: Core가 Gameplay를 참조)가 발견되면 코드 리뷰에서 반려합니다. 프로젝트 규모가 커져 코드 리뷰만으로 강제하기 어려워지면, 이 폴더들을 Assembly Definition으로 물리 분리하는 것을 재검토합니다(현재는 Simplicity 우선으로 보류, [ADR 0004](../../docs/decisions/0004-unity-starter-template.md) Alternatives 참고).

---

# Required Packages

`Packages/manifest.json`에 아래 5개 패키지를 기준선으로 둡니다. 버전 번호는 Unity Hub가 지정 LTS Editor로 프로젝트를 생성할 때 채워지는 값을 그대로 사용하고, 임의로 최신 버전으로 갱신하지 않습니다(setup.md의 Editor 버전 고정 원칙과 동일한 이유).

| 패키지 | 근거 | 비고 |
|---|---|---|
| `com.unity.addressables` | `agents/unity.md`에 이미 명시된 원칙 | 최초 사용 시 Window > Asset Management > Addressables > Groups에서 초기화 → `Assets/AddressableAssetsData/` 자동 생성 |
| `com.unity.inputsystem` | Event 기반 설계 원칙과 정합, 멀티플랫폼 리바인딩 대응 | Player Settings > Active Input Handling을 "Input System Package (New)" 또는 "Both"로 변경해야 적용됨 |
| `com.unity.textmeshpro` | UI 텍스트 사실상 표준 | |
| `com.unity.test-framework` | `Tests/` 폴더 및 QA Agent와 연계, 유지보수성 우선순위 부합 | EditMode/PlayMode 각 asmdef에서 참조 |
| `com.unity.render-pipelines.universal` | Unity의 현재 권장 경로, 2D/3D 모두 대응 | 게임 특성에 따라 URP 내 Renderer Feature 등 세부 설정은 게임별 재량(아래 표 참고) |

Cinemachine, 2D/3D 전용 확장 패키지(2D Animation, ProBuilder 등), Netcode, Localization 등은 표준에 포함하지 않습니다 — 장르에 따라 필요 여부가 갈리므로 게임별로 개별 추가합니다.

---

# .gitignore / .gitattributes

`setup.md`에 정의된 기본 `.gitignore` 대상(`Library/`, `Temp/`, `Obj/`, `Build/`, `Builds/`, `Logs/`, `UserSettings/`)에 아래 항목을 추가합니다.

```text
.vs/
.idea/
*.csproj
*.sln
*.pidb
*.booproj
*.svd
sysinfo.txt
crashlytics-build.properties
```

Git LFS 추적 대상은 `setup.md`의 목록(`*.psd`, `*.fbx`, `*.png`, `*.wav`, `*.mp4`)을 기준선으로 하고, 프로젝트에서 실제 사용하는 바이너리 확장자(`*.tga`, `*.exr`, `*.mp3`, `*.ttf` 등)가 추가되면 그때그때 `git lfs track`으로 확장합니다.

---

# Assembly Definition 최소 요구사항

- `Tests/EditMode/`, `Tests/PlayMode/`에는 각각 asmdef가 **필수**입니다(Unity Test Framework 동작 요구사항).
- `Scripts/Core`, `Gameplay`, `UI`, `Systems`, `Utilities`를 별도 asmdef로 분리하는 것은 **선택**입니다. 컴파일 시간이 체감되거나 의존성 방향 위반이 코드 리뷰만으로 통제되지 않기 시작하면 도입을 재검토합니다.

---

# New Project Setup Checklist

`workflow.md`의 "Project Creation Workflow" 4단계("표준 프로젝트 구조 적용")를 구체화한 체크리스트입니다.

1. GameDev-Platform 기준으로 신규 Repository 생성
2. Unity Hub에서 지정 LTS 버전, 게임 장르에 맞는 템플릿(2D/3D, URP)으로 프로젝트 생성
3. Hub가 기본 생성한 `Assets/TutorialInfo`, `Assets/Readme.asset` 등 샘플 자산 삭제
4. Git LFS 설정(`setup.md`) — 첫 Commit 이전에 완료
5. 위 "Assets Structure" 트리대로 폴더 생성
6. `Packages/manifest.json`에 필수 패키지 5종 확인/추가 (Hub가 URP 템플릿 선택 시 일부는 이미 포함됨)
7. Addressables 초기화(Window > Asset Management > Addressables > Groups)
8. Input System 사용 시 Active Input Handling 설정 변경
9. `.gitignore`/`.gitattributes` 적용
10. `CLAUDE.md` 및 `agents/` 복사 또는 참조 연결
11. 초기 Commit

---

# 게임마다 다른 것 vs 플랫폼 표준

| 구분 | 항목 | 비고 |
|---|---|---|
| 플랫폼 표준(고정) | 폴더 스켈레톤/이름, Scripts 하위 의존성 방향, 네이밍 규칙 | `agents/unity.md` 준수 |
| 플랫폼 표준(고정) | gitignore/Git LFS 대상 기준선 | `setup.md` 확장 |
| 플랫폼 표준(고정) | 필수 패키지 5종(Addressables, Input System, TextMeshPro, Test Framework, URP) | 위 표 참고 |
| 플랫폼 표준(고정) | 프로젝트 생성 절차(위 체크리스트) | |
| 게임별 재량 | URP 내 Renderer Feature, Quality 세부 설정 | 그래픽 목표에 따라 |
| 게임별 재량 | Art/Audio 세부 분류, ScriptableObjects 내부 카테고리 | 게임 콘텐츠에 따라 |
| 게임별 재량 | Cinemachine, 2D/3D 전용 확장 패키지, Netcode, Localization 등 추가 패키지 | 장르/배포 방식에 따라 |
| 게임별 재량 | Scenes 구성, 챕터/레벨 명명 | 게임 디자인에 따라 |

---

# Related Documents

| Document | Description |
|---|---|
| [agents/unity.md](../../agents/unity.md) | Unity Agent 코딩 원칙 및 Architecture 가이드 (Source of Truth) |
| [setup.md](setup.md) | Unity Hub, Editor, Git LFS 설치 및 설정 |
| [workflow.md](workflow.md) | 프로젝트 생성 절차 개요, 버전 관리 규칙 |
| [docs/decisions/0004-unity-starter-template.md](../../docs/decisions/0004-unity-starter-template.md) | 본 구조를 채택한 결정 근거(ADR) |

---

# Goal

모든 게임 프로젝트가 동일한 Unity 환경과 구조에서 시작할 수 있도록 표준을 구축합니다.
