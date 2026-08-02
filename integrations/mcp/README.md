# MCP Integration

> Claude Code와 외부 시스템(Notion, GitHub 등)을 연결하는 프로토콜입니다.

---

# Overview

MCP(Model Context Protocol)는 Claude Code가 외부 시스템의 데이터와 기능에 접근할 수 있도록 연결하는 표준 프로토콜입니다.

GameDev-Platform에서는 MCP를 통해 Claude Code가 Notion 문서, GitHub Repository 등 외부 시스템을 직접 조회하고 조작할 수 있도록 합니다.

MCP 자체는 연결 방식(프로토콜)이며, 실제 연동 대상(Notion, GitHub 등)의 세부 내용은 각 Integration 문서에서 관리합니다.

---

# Responsibilities

MCP Integration은 다음을 담당합니다.

- MCP Server 등록 및 관리
- 인증 정보(API Key, Token) 관리 원칙
- Claude Code ↔ 외부 시스템 연결 상태 관리
- 연동 범위 및 권한 관리

---

# Directory Structure

```text
mcp/

├── README.md
├── setup.md
├── workflow.md
└── servers.md
```

---

# Related Documents

| Document | Description |
|----------|-------------|
| setup.md | MCP Server 등록 및 인증 설정 |
| workflow.md | MCP 사용 흐름 및 권한 원칙 |
| servers.md | 실제 등록된 MCP Server 목록 및 연결 상태 |

---

# Related Integrations

| System | Role |
|---|---|
| [notion](../notion/README.md) | Notion Database/Page 접근 |
| [github](../github/README.md) | Repository/Issue/PR 접근 |
| [unity](../unity/README.md) | (Planned) Unity Editor 연동 |

---

# Future Plans

향후 다음 항목을 추가할 예정입니다.

- Unity MCP 연동 (실제 Unity 프로젝트 생성 이후 — 절차는 [servers.md](servers.md#unity-mcp)에 문서화됨, 등록은 대기 중)

> GitHub, Filesystem, Sequential Thinking, Notion, Context7 MCP는 연동 완료되었습니다. 자세한 내용은 [servers.md](servers.md)를 참고합니다.

---

# Goal

MCP를 통해 Claude Code가 GameDev-Platform의 모든 외부 시스템을 안전하고 일관된 방식으로 활용할 수 있도록 합니다.