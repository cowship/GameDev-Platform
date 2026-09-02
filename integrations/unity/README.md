# Unity Integration

> GameDev-Platform과 실제 Unity 게임 프로젝트를 연결하는 표준입니다.

---

# Overview

이 저장소의 Unity 프로젝트는 **`game/`** 폴더에 있습니다 ([ADR 0006](../../docs/decisions/0006-game-development-in-platform-repository.md)). Unity Hub에서는 저장소 루트가 아니라 이 폴더를 엽니다.

| 항목 | 값 |
|---|---|
| 프로젝트 경로 | `game/` |
| Editor 버전 | `6000.3.22f1` |
| Render Pipeline | URP (2D) |
| 네트워킹 | Photon Fusion 2 → [integrations/photon/](../photon/README.md) |

Unity Integration은 이 프로젝트(및 앞으로 만들 프로젝트)가 공통으로 따르는 **Unity 환경, 프로젝트 구조, Git 연동 표준**을 관리합니다.

> Unity 코드 작성 원칙(네이밍, Architecture 등)은 [`agents/unity.md`](../../agents/unity.md)에서 다루며, 본 문서는 도구/환경 설정에 집중합니다.

---

# Responsibilities

Unity Integration은 다음을 담당합니다.

- Unity Editor 버전 관리
- Unity Hub 설치 및 설정
- Git / Git LFS 연동 표준
- 표준 프로젝트 구조 정의
- Unity 프로젝트 생성 절차

---

# Directory Structure

```text
unity/

├── README.md
├── setup.md
├── workflow.md
└── project_template.md
```

---

# Related Documents

| Document | Description |
|----------|-------------|
| setup.md | Unity Hub, Editor, Git LFS 설치 및 설정 |
| workflow.md | 프로젝트 생성 절차, 표준 구조, 버전 관리 규칙 |
| [project_template.md](project_template.md) | Unity Starter Template — Repository 전체 구조, 필수 패키지, gitignore/LFS 기준선 |

---

# Related Documents (Outside this Directory)

| Document | Description |
|----------|-------------|
| [agents/unity.md](../../agents/unity.md) | Unity Agent 코딩 원칙 및 Architecture 가이드 |
| [docs/decisions/0004-unity-starter-template.md](../../docs/decisions/0004-unity-starter-template.md) | Unity Starter Template 구조 결정 근거(ADR) |
| [docs/decisions/0007-photon-fusion-multiplayer-stack.md](../../docs/decisions/0007-photon-fusion-multiplayer-stack.md) | 현재 `game/` 프로젝트의 Editor 버전·패키지·폴더 구성 결정 근거(ADR) |
| [docs/team/README.md](../../docs/team/README.md) | Unity 공동 작업 규칙 (Scene 소유권, LFS Locking, `.meta` 규칙) |
| [integrations/photon/README.md](../photon/README.md) | Photon Fusion 2 연동 표준 |

---

# Future Plans

향후 다음 항목을 추가할 예정입니다.

- ~~Unity 프로젝트 템플릿(Starter Kit) 정의 (`project_template.md`)~~ 완료 ([ADR 0004](../../docs/decisions/0004-unity-starter-template.md), Stage 4 게이트 충족)
- ~~Unity MCP 연동 검토~~ 완료 (Unity CLI MCP Mode, `scripts/setup_mcp.sh`)
- CI 기반 Unity Build 자동화
- `Scripts/Networking/` 카테고리를 `project_template.md`의 표준 구조에 정식 편입할지 결정 ([ADR 0007](../../docs/decisions/0007-photon-fusion-multiplayer-stack.md) 후속 작업)
- 복사 가능한 폴더 스켈레톤 + `manifest.json` 프리셋 추출 (두 번째 게임 프로젝트가 생기는 시점에 `game/`의 실제 구성에서 역으로 뽑아냄)

---

# Goal

모든 게임 프로젝트가 동일한 Unity 환경과 구조에서 시작할 수 있도록 표준을 구축합니다.