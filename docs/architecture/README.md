# Architecture

> GameDev-Platform의 현재 시스템 아키텍처를 종합적으로 안내하는 인덱스입니다.

---

# Overview

이 디렉토리는 실제 아키텍처 결정 내용을 새로 정의하지 않습니다.

아키텍처에 관한 결정은 `docs/decisions/`의 ADR과 `agents/*.md`, `integrations/*/*.md`가 원본(Single Source of Truth)입니다. `docs/architecture/`는 이 흩어진 결정들을 하나의 종합된 시점(snapshot)으로 묶어 보여주는 **읽기용 인덱스**입니다.

새로 합류하는 팀원이나 새 세션의 Claude는 이 디렉토리의 문서만 읽어도 "지금 이 플랫폼이 어떻게 구성되어 있는가"를 파악할 수 있어야 합니다.

---

# Directory Structure

```text
architecture/

├── README.md            (본 문서, 인덱스)
├── overview.md           (전체 시스템 개요, Repository 구조, Roadmap)
├── agent-system.md       (AI Agent 3단 구조)
└── mcp-integration.md    (MCP 서버 및 Agent별 접근 범위)
```

---

# Related Documents (본 디렉토리)

| Document | Description |
|---|---|
| [overview.md](overview.md) | 전체 아키텍처 개요, "게임이 아니라 게임을 만들기 위한 플랫폼" 구조, Repository 구성, Roadmap 매핑 |
| [agent-system.md](agent-system.md) | `agents/*.md` → `.claude/agents/*.md` → `.claude/commands/*.md` 3단 구조 |
| [mcp-integration.md](mcp-integration.md) | 등록된 MCP 서버 목록과 Agent별 접근 범위 |

---

# Related Documents (원본 / Source of Truth)

| Document | Description |
|---|---|
| [docs/decisions/0001-agent-adapter-strategy.md](../decisions/0001-agent-adapter-strategy.md) | Agent Adapter 전략 ADR |
| [docs/decisions/0002-slash-commands-strategy.md](../decisions/0002-slash-commands-strategy.md) | Slash Command 전략 ADR |
| [docs/decisions/0003-agent-mcp-access.md](../decisions/0003-agent-mcp-access.md) | Agent별 MCP 접근 범위 ADR |
| [agents/README.md](../../agents/README.md) | Agent Framework 개요 및 6개 Agent 역할 정의 |
| [integrations/mcp/README.md](../../integrations/mcp/README.md) | MCP Integration 개요 |
| [README.md](../../README.md) | Repository 소개 및 Roadmap |
| [CLAUDE.md](../../CLAUDE.md) | 프로젝트 전체 원칙 및 Claude 역할 정의 |

---

# Update Policy

아키텍처에 영향을 주는 변경(새 ADR 작성, Agent 추가, MCP 서버 추가/변경)이 있으면 원본 문서(ADR, agents/*.md, integrations/*.md)를 먼저 갱신하고, 그 다음 본 디렉토리의 관련 문서를 동기화합니다.

---

# Goal

GameDev-Platform의 아키텍처를 "찾아다니지 않아도 되는" 단일 진입점으로 제공하여, 온보딩 시간과 컨텍스트 파악 비용을 줄입니다.
