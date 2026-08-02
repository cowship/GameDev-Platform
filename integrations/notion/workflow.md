# Notion Workflow

---

# Purpose

Notion Workspace에 콘텐츠를 만들고 정리하는 절차를 정의합니다.

여러 세션/사람이 각자 다른 방식으로 페이지를 만들면 구조가 금방 무너지므로, "누가 어떻게 쓰는가"를 하나의 규칙으로 고정합니다.

---

# Base Page

Workspace의 모든 콘텐츠는 **🏠 Home**을 Base Page로 두고, 그 하위 트리에서만 생성합니다.

| 항목 | 내용 |
|---|---|
| Base Page | 🏠 Home |
| URL | https://app.notion.com/p/3b0050efa95d81e2968ff0b4dd078357 |

- 신규 페이지·Database는 항상 Home의 하위(직계 자식이거나, Home 하위 페이지의 자식)에 생성합니다.
- Workspace 최상위(독립 페이지)로 만들지 않습니다. 독립 페이지는 검색 외에는 찾을 방법이 없어 금방 유실됩니다.
- 새 항목을 만들면 Home 페이지의 대시보드(카테고리별 Callout/Column, "하위 항목 전체 목록" 토글)에도 바로가기를 추가합니다.

---

# 작성 채널: Documentation Agent 전용

Notion에 쓰기(생성/수정/이동/Database 조작)가 필요한 모든 작업은 **Documentation Agent**(`/documentation` 또는 `Agent(subagent_type: "documentation")`)를 통해서만 수행합니다.

- 메인 대화(다른 Agent 포함)에서 Notion MCP 도구를 직접 호출하지 않습니다.
- 읽기 전용 조회(`notion-search`, `notion-fetch` 등으로 내용 확인만 하는 경우)는 예외적으로 메인 대화에서도 허용하지만, 실제 쓰기 작업은 Documentation Agent에 위임합니다.
- 이렇게 제한하는 이유는 [ADR 0001](../../docs/decisions/0001-agent-adapter-strategy.md)의 Role Separation 원칙과 동일합니다: 쓰기 권한을 한 Agent에 모아야 Base Page 규칙, 중복 페이지 방지, 제목 규칙이 실제로 지켜집니다.

---

# 새 페이지/Database 생성 절차

1. Home 하위 어디에 속하는 콘텐츠인지 확인 (`workspace.md`의 카테고리 참고)
2. 같은 목적의 페이지/Database가 이미 있는지 `notion-search` 또는 Home 대시보드에서 확인 (중복 방지)
3. Home 또는 해당 카테고리 페이지를 parent로 지정해 생성
4. Home 대시보드에 바로가기 추가
5. 필요 시 `workspace.md` / `databases.md`의 "상태" 섹션 갱신 및 커밋

---

# Related Documents

| Document | Description |
|---|---|
| [workspace.md](workspace.md) | Workspace 구조 및 구축 상태 |
| [databases.md](databases.md) | Database 설계 및 구축 상태 |
| [../../agents/documentation.md](../../agents/documentation.md) | Documentation Agent 역할 정의 |
