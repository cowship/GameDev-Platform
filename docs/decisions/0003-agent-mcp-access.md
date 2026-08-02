# ADR 0003: Agent별 MCP 서버 접근 범위

## Status

Accepted

## Context

[ADR 0001](0001-agent-adapter-strategy.md)에서 6개 Adapter Agent(`.claude/agents/*.md`)의 Tool 권한을 Role Separation 원칙에 따라 제한했다. 이 시점에는 MCP 서버(GitHub, Filesystem, Sequential Thinking, Notion)가 아직 등록되지 않았거나 Adapter Agent에 연결되어 있지 않았다.

이후 Notion MCP를 연결하고 Documentation Agent에 `mcp__claude_ai_Notion__*` 권한을 부여했다([[Notion 작성 채널을 Documentation Agent로 일원화]] 커밋). 이번에는 나머지 5개 Agent에도 각자 역할에 맞는 MCP 서버를 열어달라는 요청을 받았다.

MCP 서버 4종의 성격:

| 서버 | 성격 |
|---|---|
| GitHub | 읽기 도구(이슈/PR/코드 조회)와 쓰기 도구(PR 생성, 병합, 파일 push, 저장소 생성 등)가 한 서버에 혼재 |
| Filesystem | Repository 루트에 대한 읽기 + 쓰기(write_file, edit_file, move_file 등) |
| Sequential Thinking | 도구 1개(`sequentialthinking`), 부작용 없는 순수 추론 보조 |
| Notion | 읽기/쓰기 혼재. Documentation Agent 전용으로 이미 결정됨 |

`tools` frontmatter는 서버 전체를 여는 와일드카드(`mcp__server__*`)나 도구 이름을 개별 나열하는 방식만 지원한다. 와일드카드는 서버 안의 읽기/쓰기 도구를 구분하지 못한다.

---

## Decision

1. **Sequential Thinking은 6개 Agent 모두에 전체 허용**한다 (`mcp__sequential-thinking__sequentialthinking`). 부작용이 없는 추론 보조 도구이므로 Role Separation과 무관하게 안전하다.

2. **Filesystem MCP는 어느 Agent에도 부여하지 않는다.**
   - `unity`/`documentation`은 이미 네이티브 Read/Write/Edit로 동일 범위(Repository 루트)를 다루고 있어 중복이다.
   - `technical-lead`/`pm`/`qa`/`game-designer`는 ADR 0001에서 의도적으로 Write를 배제했는데, Filesystem MCP는 write_file/edit_file을 포함하므로 부여하면 그 제한이 우회된다.

3. **GitHub MCP는 Agent 역할에 따라 서로 다른 부분집합을 명시적으로 나열**한다. 와일드카드(`mcp__github__*`)는 사용하지 않는다 — 실제로 Unity Agent에 전체 와일드카드를 시도했을 때 Claude Code의 자동 권한 분류기가 "권한 상승 위험"으로 차단했다.

   | Agent | GitHub 도구 | 근거 |
   |---|---|---|
   | technical-lead | 읽기 전용(이슈/PR/커밋/코드 조회, 검색) | ADR 0001: "분석/제안만" |
   | pm | 읽기 전용(위와 동일 목록) | ADR 0001: "계획/우선순위 제안만" |
   | qa | 읽기 전용(위와 동일 목록) | ADR 0001: "테스트/분석만" |
   | game-designer | 없음 | 설계·기획 업무와 GitHub 연동 접점이 없음 |
   | unity | 읽기 전용 + `create_branch`, `create_or_update_file`, `push_files`, `create_pull_request`, `add_issue_comment` | ADR 0001: "실제 구현 담당" — 구현 결과를 branch/PR로 올리는 것까지가 역할 범위. `merge_pull_request`, `create_repository`, `fork_repository`, `update_pull_request_branch`는 제외(병합·저장소 단위 조작은 사람이 최종 결정) |
   | documentation | 읽기 전용 + `add_issue_comment` | Meeting Notes/Bug Reports DB의 "GitHub Issue" 속성을 채우거나 참조용 코멘트를 남기는 용도. 코드/PR을 직접 만들 필요는 없음 |

   읽기 전용 목록: `get_file_contents`, `get_issue`, `get_pull_request`, `get_pull_request_comments`, `get_pull_request_files`, `get_pull_request_reviews`, `get_pull_request_status`, `list_commits`, `list_issues`, `list_pull_requests`, `search_code`, `search_issues`, `search_repositories`, `search_users`

4. **Notion MCP는 기존 결정(Documentation Agent 전용, `mcp__claude_ai_Notion__*`)을 유지**한다.

---

## Alternatives

- **(D) 모든 Agent에 모든 MCP 서버를 와일드카드로 전면 개방**: 사용자가 최초에 "자유롭게"라고 요청했으나, ADR 0001의 Role Separation을 사실상 무력화하고(예: QA가 PR을 직접 병합) Filesystem MCP로 읽기 전용 Agent가 파일을 쓸 수 있게 되어 기각. 사용자에게 확인 후 "적합한 MCP만" 방식으로 재요청받아 본 ADR의 방식으로 결정.
- **(E) GitHub도 서버 전체 와일드카드로 통일**: 관리 부담은 적지만 Unity Agent에서 자동 분류기가 실제로 차단했고, 쓰기/관리 도구(병합, 저장소 생성/포크)까지 모든 관련 Agent에 열리는 것은 ADR 0001의 취지에 어긋나 기각.

---

## Consequences

**장점**
- MCP 접근이 필요한 실무(코드/이슈 조사, Notion 문서화, PR 생성)를 각 Agent가 직접 수행할 수 있다.
- ADR 0001의 Role Separation(무엇을 "결정/제안만" 하고 무엇을 "실행"하는지)이 MCP 영역까지 일관되게 이어진다.

**단점**
- GitHub 도구를 서버별이 아닌 개별 이름으로 나열해야 해서 `tools` 필드가 길고, 새 GitHub MCP 도구가 추가되면 각 Adapter를 수동으로 갱신해야 한다.
- Filesystem MCP 자체는 어떤 Agent도 못 쓰게 되어, 향후 Repository 루트 바깥 파일이 필요해지면 별도 재검토가 필요하다.

**후속 작업**
- 새 Agent를 추가하거나 GitHub MCP에 새 도구가 생기면 이 ADR의 표를 갱신한다.
- `merge_pull_request` 등 배제한 쓰기 도구가 실제로 필요해지면, 그 시점에 별도 ADR로 재논의한다(현재는 사람이 직접 병합).
