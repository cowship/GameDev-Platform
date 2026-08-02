# Notion Integration

> GameDev-Platform의 공식 문서 및 프로젝트 관리 플랫폼입니다.

---

# Overview

GameDev-Platform는 Notion을 **프로젝트 운영 데이터**(Task, Project, Meeting Notes, Bug Reports, Features)의 Single Source of Truth(SSOT)로 사용합니다.

**ADR/Architecture 등 구조적 의사결정의 SSOT는 GitHub `docs/decisions/`, `agents/*.md`, `integrations/*/*.md`입니다** ([docs/architecture/README.md](../../docs/architecture/README.md) 참고). Notion의 🏛 Architecture 하위 ADR Database는 그 원본을 읽기 편하게 동기화한 사본이며, 새 ADR은 GitHub에 먼저 작성한 뒤 Database에 반영합니다.

Notion은 단순한 문서 저장소가 아니라 프로젝트 운영, 작업 관리, 회의 기록 및 AI Agent와의 협업을 위한 중심 플랫폼입니다.

Notion MCP는 2026-08-02에 연결을 확인했고, `workspace.md`/`databases.md`에 계획된 구조를 실제 Notion에 구축했습니다. 세부 구축 상태는 각 문서의 "상태" 섹션을 참고하세요.

---

# Responsibilities

Notion Integration은 다음을 담당합니다.

- 프로젝트 문서 관리
- 기술 문서 관리
- 회의록 관리
- 작업(Task) 관리
- 프로젝트 지식(Knowledge Base) 관리
- AI 기반 문서 자동화

---

# Directory Structure

```text
notion/

├── README.md
├── workspace.md
├── databases.md
├── workflow.md
├── templates.md         (Planned)
└── automation.md        (Planned)
```

---

# Related Documents

| Document | Description |
|----------|-------------|
| workspace.md | Notion Workspace 구조 |
| databases.md | Database 설계 |
| workflow.md | Base Page 규칙, Documentation Agent 전용 작성 채널 |

---

# Long-term Goal

GameDev-Platform는 Notion을 AI Native Project Management Platform으로 발전시키는 것을 목표로 합니다.

Claude Code, GitHub, Unity 및 MCP와 연동하여 프로젝트 관리의 대부분을 자동화합니다.