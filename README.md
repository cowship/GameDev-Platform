# 🎮 GameDev-Platform

> **Build the Platform First, Then Build the Game.**
>
> 좋은 게임은 좋은 개발 환경에서 시작됩니다.

---

# 프로젝트 소개

GameDev-Platform은 Unity 게임 개발을 위한 AI Native 개발 플랫폼입니다.

이 프로젝트는 단순히 하나의 게임을 개발하는 것이 아니라, 어떤 게임 프로젝트라도 동일한 개발 환경과 워크플로우에서 시작할 수 있도록 표준을 구축하는 것을 목표로 합니다.

플랫폼에서는 다음과 같은 요소를 관리합니다.

- 개발 환경 구축
- AI Agent 활용
- Claude Code 운영
- MCP 연동
- Notion 문서 시스템
- GitHub 협업
- Unity 프로젝트 템플릿
- 자동화 스크립트

실제 게임 프로젝트는 이 저장소의 `game/` 폴더에서 개발합니다 ([ADR 0006](docs/decisions/0006-game-development-in-platform-repository.md)).

---

# 핵심 목표

- 반복 가능한 개발 환경 구축
- AI 중심(Unity + Claude Code) 개발 프로세스 확립
- 문서화 자동화
- 협업 표준화
- 프로젝트 생성 자동화
- 재사용 가능한 템플릿 구축

---

# 개발 철학

## Standard First

모든 프로젝트는 동일한 기준에서 시작한다.

## Automation First

반복 작업은 가능한 자동화한다.

## Documentation First

결정 사항은 반드시 문서화한다.

## AI Native

AI를 보조 도구가 아닌 팀원으로 활용한다.

---

# Repository 구조

```text
GameDev-Platform
│
├── game                ← Unity 프로젝트 (Unity Hub로 이 폴더를 엽니다)
│   ├── Assets
│   ├── Packages
│   └── ProjectSettings
│
├── agents              ← AI Agent 역할 정의
├── docs                ← 아키텍처, 의사결정(ADR), 팀 운영 문서
├── integrations        ← Unity / GitHub / Netcode / Notion / MCP 연동 표준
├── prompts
├── scripts             ← 환경 구축 자동화 스크립트
├── templates
│
├── .github             ← Issue / PR 템플릿, CODEOWNERS, CI 워크플로
├── README.md
├── CLAUDE.md
├── .gitattributes      ← Git LFS, Unity Smart Merge 설정
└── .gitignore
```

> ⚠️ Unity Hub에서는 **저장소 루트가 아니라 `game/` 폴더**를 열어야 합니다.

---

# 기술 스택

- Windows 10 (1809+) / Windows 11
- Git for Windows (Git Bash, Git LFS 포함)
- GitHub
- VS Code
- Claude Code
- Node.js
- Unity 6000.3.22f1 (URP, 2D)
- Unity Netcode for GameObjects (멀티플레이 네트워킹)
- Notion
- MCP

---

# Roadmap

## Stage 1

Development Environment

## Stage 2

AI Environment

## Stage 3

Documentation Platform

## Stage 4

Unity Starter Template

## Stage 5

Team Collaboration — 진행 중 (5인 팀, PR 기반 협업)

## Stage 6

First Game Project — 진행 중 (Unity + Netcode for GameObjects 멀티플레이)

---

# Repository Policy

GameDev-Platform는 **플랫폼 표준과 실제 게임 프로젝트를 함께 담는 저장소**입니다.

- 플랫폼 자산(문서, Agent 정의, 스크립트, 연동 표준)은 저장소 루트에서 관리합니다.
- 실제 게임 프로젝트는 `game/` 폴더에서 관리합니다.

두 영역은 디렉토리로 분리되어 있어, 필요해지면 `game/`을 별도 Repository로 떼어낼 수 있습니다. 이 정책의 배경과 대안 검토는 [ADR 0006](docs/decisions/0006-game-development-in-platform-repository.md)을 참고하세요.

---

# 팀 개발을 시작하려면

```bash
./scripts/setup_team_member.sh
```

자세한 절차는 [docs/team/ONBOARDING.md](docs/team/ONBOARDING.md), 협업 규칙은 [docs/team/README.md](docs/team/README.md)를 참고합니다.

이 협업 기반이 **무엇으로, 왜 그렇게 구성되어 있는지**와 처음부터 다시 만드는 방법은 [docs/foundation/README.md](docs/foundation/README.md)에 정리되어 있습니다.

---

# License

Private Repository