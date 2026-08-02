# Unity Integration

> GameDev-Platform과 실제 Unity 게임 프로젝트를 연결하는 표준입니다.

---

# Overview

GameDev-Platform 자체는 게임을 개발하지 않으며, 실제 게임 프로젝트는 별도 Repository에서 개발합니다.

Unity Integration은 그 별도 Repository들이 공통으로 따라야 할 **Unity 환경, 프로젝트 구조, Git 연동 표준**을 관리합니다.

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

---

# Future Plans

향후 다음 항목을 추가할 예정입니다.

- ~~Unity 프로젝트 템플릿(Starter Kit) 정의 (`project_template.md`)~~ 완료 ([ADR 0004](../../docs/decisions/0004-unity-starter-template.md), Stage 4 게이트 충족)
- Unity MCP 연동 검토
- CI 기반 Unity Build 자동화
- `templates/unity-starter/`에 실제 복사 가능한 폴더 스켈레톤 + `manifest.json` 프리셋 추가 (Stage 6 첫 게임 적용 후 반복 수작업이 확인되면 검토)

---

# Goal

모든 게임 프로젝트가 동일한 Unity 환경과 구조에서 시작할 수 있도록 표준을 구축합니다.