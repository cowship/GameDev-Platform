# Prompts

> Agent(Slash Command)를 효과적으로 부르기 위한, 자주 반복되는 요청을 복사해서 채워 쓰는 프롬프트 모음입니다.

---

# Overview

`.claude/commands/*.md`의 6개 Slash Command(`/technical-lead`, `/pm`, `/documentation`, `/unity`, `/qa`, `/game-designer`)는 로직 없는 Dispatcher로, `$ARGUMENTS`를 그대로 Agent에 전달합니다([ADR 0002](../docs/decisions/0002-slash-commands-strategy.md)). 즉 좋은 결과를 얻으려면 `$ARGUMENTS`에 들어갈 요청 자체가 잘 구조화되어 있어야 합니다.

이 디렉토리는 실제로 반복될 가능성이 높은 요청만 최소한으로 템플릿화합니다. 모든 Agent에 대응하는 프롬프트를 만들지 않고, 반복 빈도가 높고 여러 Agent 간 협업(Technical Lead → Documentation, QA → Documentation 등)이 필요한 요청 위주로 구성했습니다.

---

# Directory Structure

```text
prompts/

├── README.md            (본 문서, 인덱스)
├── new-adr.md            (ADR 작성 요청: Technical Lead 검토 → Documentation Agent 기록)
├── sprint-planning.md    (Sprint 계획/우선순위 요청: PM Agent)
└── bug-analysis.md       (버그 분석 요청: QA Agent)
```

---

# Related Documents

| Prompt | 대상 Slash Command | 설명 |
|---|---|---|
| [new-adr.md](new-adr.md) | `/technical-lead` → `/documentation` | 기술 결정을 Technical Lead가 검토하고, Documentation Agent가 [templates/adr.md](../templates/adr.md) 형식으로 기록하는 2단계 요청 |
| [sprint-planning.md](sprint-planning.md) | `/pm` | Sprint 목표/후보 작업/팀 규모/기간을 채워 우선순위 계획을 요청. 결과는 [templates/sprint-report.md](../templates/sprint-report.md) 형식으로 반환 |
| [bug-analysis.md](bug-analysis.md) | `/qa` | 버그 재현 정보를 채워 원인 분석을 요청. 결과는 `agents/qa.md`의 Bug Report Format으로 반환 |

---

# Usage

각 프롬프트 파일의 코드 블록을 복사해 대괄호(`[...]`) 부분만 채운 뒤, 안내된 Slash Command 뒤에 붙여 사용합니다.

```text
/pm 아래 내용을 바탕으로 Sprint 계획을 세워줘. ...
```

여러 Agent 협업이 필요한 프롬프트(`new-adr.md`, `bug-analysis.md`)는 1단계 결과를 2단계 요청에 그대로 붙여넣어 이어서 사용합니다.

---

# Update Policy

여기 없는 요청 유형이라도 굳이 미리 만들지 않습니다. 실제로 3회 이상 반복되는 패턴이 확인되면 그때 추가합니다(Simplicity, 과설계 금지).
