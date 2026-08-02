# ADR 0005: Context7 MCP 전체 Agent 개방

## Status

Accepted

## Context

Context7 MCP(`@upstash/context7-mcp`)를 등록했다. 라이브러리/프레임워크의 최신 공식 문서·코드 예제를 실시간으로 조회하는 서버로, 도구는 `resolve-library-id`, `get-library-docs` 2개뿐이며 조회 결과를 그대로 반환할 뿐 Repository나 외부 시스템에 어떤 쓰기도 하지 않는다.

[ADR 0003](0003-agent-mcp-access.md)은 MCP 서버를 성격에 따라 나눠 Agent별로 열었다. 그중 Sequential Thinking은 "부작용 없는 순수 추론 보조 도구"라는 이유로 6개 Adapter Agent 전체에 허용됐다(ADR 0003 Decision 1). Context7도 같은 성격(부작용 없음, 읽기 전용)이며, 오히려 활용 범위는 Sequential Thinking보다 넓다 — Unity API/C# 문법을 다루는 Unity Agent뿐 아니라, 기술 검토(technical-lead), 문서 작성 중 레퍼런스 인용(documentation), 테스트 대상 라이브러리 동작 확인(qa), 일정/기획 중 참고 자료 조회(pm, game-designer)까지 전 영역에서 "환각 방지" 목적으로 유용하다.

## Decision

1. **Context7 MCP를 6개 Adapter Agent 전체에 허용**한다. `.claude/agents/*.md`의 `tools` frontmatter에 `mcp__context7__resolve-library-id`, `mcp__context7__get-library-docs`를 추가했다.
2. **와일드카드(`mcp__context7__*`)가 아닌 도구 이름을 명시적으로 나열**한다. ADR 0003이 GitHub MCP에서 확립한 관례(서버 안 도구를 구분해 나열)를 그대로 따르되, Context7은 도구 2개뿐이라 실질적으로는 전체 개방과 동일한 효과다.

---

## Alternatives

- **(A) Unity/Documentation/Technical Lead 등 문서·코드 조사가 잦은 Agent에만 우선 개방**: 읽기 전용·부작용 없음이라는 판단 기준(ADR 0003의 Sequential Thinking 논리)을 그대로 적용하면 굳이 일부 Agent만 배제할 근거가 없어 기각. 도구 자체가 매우 가볍고(문서 조회 API 호출), Rate Limit 문제도 API Key 없는 무료 등급 사용자 1인이 감당하는 수준이라 전체 개방의 비용이 낮다.

---

## Consequences

**장점**
- 6개 Agent 모두 라이브러리/프레임워크 관련 답변 시 최신 공식 문서를 근거로 삼을 수 있어 환각(오래되거나 틀린 API 사용법 제시) 위험이 줄어든다.
- Sequential Thinking과 동일한 논리를 재사용해 결정 기준이 단순하고 일관적이다.

**단점**
- API Key 없이 사용하므로 요청량이 많아지면 Rate Limit에 걸릴 수 있다. 필요해지면 [context7.com/dashboard](https://context7.com/dashboard)에서 키를 발급해 `integrations/mcp/servers.md`에 기록된 등록 명령에 `-e CONTEXT7_API_KEY=<key>`를 추가한다.

**후속 작업**
- Rate Limit이 실제로 문제가 되면 API Key 발급 및 등록을 별도로 진행한다(새 ADR 불필요, servers.md 갱신으로 충분).
