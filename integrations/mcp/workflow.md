# MCP Workflow

---

# Development Philosophy

MCP는 Claude Code가 외부 시스템에 안전하고 표준화된 방식으로 접근하는 창구입니다.

Claude는 MCP를 통해 얻은 정보를 근거로 판단하되, 최종 결정과 실행 승인은 항상 사람이 수행합니다.

---

# Standard Connection Flow

```text
Claude Code
    ↓
MCP Server
    ↓
External System (Notion / GitHub / Unity)
```

Claude Code는 MCP Server를 통해서만 외부 시스템에 접근하며, 직접 API를 호출하지 않습니다.

---

# 연동 시스템별 역할

| System | MCP를 통해 하는 일 |
|---|---|
| Notion | 문서/Database 조회, Task/Meeting Notes 생성 |
| GitHub | Issue/PR 조회, Repository 정보 확인 |
| Unity | (Planned) Editor 상태 조회, Asset 정보 확인 |

---

# 권한 원칙

## Least Privilege

MCP Server에는 필요한 최소한의 권한만 부여합니다.

## No Secret Exposure

API Key, Token은 대화나 커밋에 노출되지 않도록 관리합니다.

## Human Approval for Write

문서/코드/Issue 등 외부 시스템에 실제로 쓰기 작업을 수행하기 전, 중요한 변경은 사람의 확인을 거칩니다.

---

# 사용 예시

| 상황 | MCP 활용 |
|---|---|
| 회의록 작성 | Notion MCP로 Meeting Notes 생성 |
| 이슈 확인 | GitHub MCP로 Issue 목록 조회 |
| ADR 기록 | Notion MCP로 ADR Database에 기록 |

---

# Long-term Vision

향후 MCP를 통해 다음 흐름을 자동화하는 것을 목표로 합니다.

```text
코드 변경 (GitHub)
    ↓
Claude 분석
    ↓
문서 자동 생성/갱신 (Notion)
```

이를 통해 개발-문서화-협업이 하나의 흐름으로 연결된 AI Native 개발 프로세스를 구축합니다.