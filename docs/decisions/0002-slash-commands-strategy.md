# ADR 0002: Agent Adapter를 호출하는 Slash Commands 설계

## Status

Accepted

## Context

[ADR 0001](0001-agent-adapter-strategy.md)에서 `agents/*.md`를 `.claude/agents/*.md` Adapter로 변환하여 `Agent(subagent_type: "unity")` 형태로 호출 가능하게 만들었다.

다만 이 호출 방식은 매번 정확한 subagent_type 이름을 기억해야 해서 진입 장벽이 있다. Claude Code는 `.claude/commands/*.md`를 Slash Command로 인식하며, 파일명이 곧 명령어가 되고 `$ARGUMENTS`로 사용자 입력을 프롬프트에 삽입할 수 있다.

---

## Decision

1. **1:1 매핑**: ADR 0001의 6개 Adapter Agent(`technical-lead`, `pm`, `documentation`, `unity`, `qa`, `game-designer`)마다 동일한 이름의 Slash Command를 만든다.

2. **Command는 로직 없는 Dispatcher로만 동작**: Command 파일은 `Agent` 툴로 동일한 이름의 subagent_type을 호출하고 `$ARGUMENTS`를 그대로 전달하는 역할만 한다.

3. **Tool 권한을 Command에서 재정의하지 않는다**: 권한은 이미 ADR 0001의 `.claude/agents/*.md` `tools` 필드가 Single Source of Truth다. Command 파일에 `allowed-tools`를 별도로 명시하면 두 곳에서 권한을 관리하게 되어 어긋날 위험이 생긴다.

---

## Alternatives

- **(C) 서브에이전트 호출 없이 메인 대화에서 역할만 흉내내기**: Command가 `agents/{role}.md`를 Read하게 하고, 별도 subagent 호출 없이 현재 대화 컨텍스트 안에서 그 역할을 따르도록 설계. 대화 맥락(이미 읽은 파일, 진행 중인 논의)을 유지할 수 있는 장점이 있으나, ADR 0001에서 강제한 Tool 권한 제한(Role Separation)이 적용되지 않아 기각. 컨텍스트 유지가 중요한 짧은 질의는 Command 없이 직접 "PM 관점에서 봐줘"처럼 요청하는 방식으로 여전히 가능하다.

---

## Consequences

**장점**
- Command 로직이 없어 유지보수 부담이 거의 없다 (Simplicity).
- 권한 정의가 한 곳(Adapter Agent)에만 존재한다 (Single Source of Truth).

**단점**
- 서브에이전트 호출이므로 메인 대화의 맥락이 전달되지 않는다. 각 Command 호출은 독립적인 새 대화로 시작된다.

**제약**
- ADR 0001의 Adapter Agent들이 현재 세션에서 아직 인식되지 않는 것과 동일한 이유로, 이 Slash Command들도 **새 세션에서만** 정상 동작을 확인할 수 있다.