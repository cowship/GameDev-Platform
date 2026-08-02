# Claude Code Integration

> Claude Code를 GameDev-Platform의 AI 개발 파트너로 활용하기 위한 가이드입니다.

---

# Overview

GameDev-Platform는 Claude Code를 단순한 코드 생성기가 아닌 AI Agent Platform으로 활용합니다.

Claude Code는 프로젝트 구조를 이해하고, AI Agent와 협업하며, 개발 프로세스를 지원하는 중심 인터페이스입니다.

본 디렉터리는 Claude Code의 설치, 설정, 워크플로우 및 운영 방식을 관리합니다.

---

# Responsibilities

Claude Code Integration은 다음을 담당합니다.

- Claude Code 설치 및 설정
- 프로젝트 연결
- AI Agent 활용
- 개발 워크플로우
- Best Practice 관리
- Claude 관련 Troubleshooting

---

# Directory Structure

```text
claude/

├── README.md
├── setup.md
├── workflow.md
├── commands.md          (Planned)
├── best_practices.md    (Planned)
└── troubleshooting.md   (Planned)
```

---

# Related Documents

| Document | Description |
|----------|-------------|
| setup.md | Claude Code 설치 및 초기 설정 |
| workflow.md | Claude Code 개발 워크플로우 |

---

# Custom Agents & Slash Commands

`agents/*.md`에 정의된 역할은 `.claude/agents/*.md` Adapter를 통해 Claude Code 서브에이전트로 호출할 수 있고, `.claude/commands/*.md`를 통해 `/pm`, `/unity`, `/qa` 등 Slash Command로도 호출할 수 있습니다.

설계 배경은 다음 ADR을 참고합니다.

- [ADR 0001: Agent Adapter 전략](../../docs/decisions/0001-agent-adapter-strategy.md)
- [ADR 0002: Slash Commands 전략](../../docs/decisions/0002-slash-commands-strategy.md)

---

# Future Plans

향후 다음 기능을 추가할 예정입니다.

- MCP Integration
- Prompt Library
- Project Templates

---

# Goal

Claude Code를 GameDev-Platform의 핵심 AI 인터페이스로 활용하여 생산성과 협업 효율을 극대화합니다.