# ADR 0001: agents/*.md를 Claude Code Subagent로 변환하는 전략

## Status

Accepted

## Context

`agents/` 디렉토리에는 6개의 역할 정의 문서(technical_lead, pm, documentation, unity, qa, game_designer)가 있다.

이 문서들은 지금까지 Claude가 대화 중 참고하는 "역할 가이드"로만 쓰였고, Claude Code의 Agent 툴(Task 기반 서브에이전트)에서 `Agent(subagent_type: "unity")`처럼 직접 호출할 수는 없었다.

서브에이전트로 호출되려면 `.claude/agents/{name}.md` 위치에 YAML frontmatter(`name`, `description`, `tools`, 선택적으로 `model`)를 포함한 파일이 필요하다. 이 frontmatter는 `agents/*.md`에는 없는, Claude Code 런타임 전용 메타데이터다.

또한 `.gitignore`에 `.claude/` 전체가 무시 설정되어 있어, 이 변환 작업을 하더라도 Git에 커밋되지 않는 문제가 있었다.

---

## Decision

1. **Single Source of Truth 유지**
   `agents/*.md`를 역할 정의의 원본으로 유지한다. `.claude/agents/*.md`는 본문을 복사하지 않고, frontmatter(name/description/tools)만 채운 뒤 원본 파일을 참조하도록 지시하는 **Thin Adapter**로 작성한다.

2. **Tool 권한을 Role Separation 원칙에 따라 제한**

   | Agent | Tools | 근거 |
   |---|---|---|
   | unity | Read, Write, Edit, Bash, Grep, Glob | 실제 구현 담당 |
   | documentation | Read, Write, Edit, Grep, Glob, Bash | 실제 문서 작성 담당 |
   | technical-lead | Read, Grep, Glob, Bash, WebSearch, WebFetch | 분석/제안만, 구현은 Unity Agent에 위임 |
   | pm | Read, Grep, Glob, Bash | 계획/우선순위 제안만, 문서화는 Documentation Agent에 위임 |
   | qa | Read, Grep, Glob, Bash | 테스트/분석만, 버그 기록은 Documentation Agent에 위임 |
   | game-designer | Read, Grep, Glob | 기획/설계 제안만, GDD 작성은 Documentation Agent에 위임 |

   각 `agents/*.md`에 이미 명시된 Collaboration 섹션(예: QA → Documentation Agent가 버그 기록)을 Write 권한 제거로 강제한다.

3. **이름 규칙**
   kebab-case로 통일한다: `technical-lead`, `pm`, `documentation`, `unity`, `qa`, `game-designer`. 다음 단계인 Slash Commands(`/pm`, `/unity` 등)와 1:1로 매핑할 수 있도록 한다.

4. **`.gitignore` 수정**
   `.claude/` 전체 무시를 `.claude/settings.local.json`만 무시하도록 변경한다. `.claude/agents/`는 팀과 공유되어야 하므로 Git에 포함한다.

---

## Alternatives

- **(A) 본문 전체 복사**: `agents/*.md` 내용을 `.claude/agents/*.md`에 그대로 복사한다. 두 문서가 이후 어긋날 위험이 있어 Documentation Agent의 Single Source of Truth 원칙에 위배되므로 기각.
- **(B) 빌드 스크립트로 자동 생성**: `agents/*.md` → `.claude/agents/*.md`를 스크립트로 자동 생성한다. 장기적으로는 이상적이나, 현재 단계에서는 과한 복잡성(Simplicity 원칙 위배)이라 판단하여 보류. Automation 단계에서 재검토한다.

---

## Consequences

**장점**
- 문서 중복이 없다. 역할 정의를 수정할 때 `agents/*.md` 한 곳만 고치면 된다.
- Tool 권한 제한으로 Human Decision 원칙(최종 결정은 사람)이 구조적으로 강제된다.

**단점**
- 서브에이전트 실행 시 매번 원본 파일을 Read로 먼저 읽어야 하므로 약간의 초기 오버헤드가 발생한다.

**후속 작업**
- Slash Commands 설계 시 본 ADR의 이름 규칙(kebab-case)을 그대로 사용한다.
- Alternative (B, 빌드 스크립트 자동화)는 Automation 관련 작업 시 재검토한다.