# Issue / PR Templates

> 이 저장소의 Issue/PR Template 설계 근거와 Notion 연동 규칙입니다.

---

# Scope

> **적용 범위**: [workflow.md](workflow.md)와 동일하게 **이 저장소**에 적용됩니다.
> 초기에는 "게임은 별도 Repository에 두므로 이 저장소에는 `.github/ISSUE_TEMPLATE/`을 만들지 않는다"는 방침이었으나, 게임 개발이 이 저장소의 `game/`에서 이루어지게 되면서([ADR 0006](../../docs/decisions/0006-game-development-in-platform-repository.md)) **실제 템플릿 파일을 생성했습니다.**

| 실제 파일 | 용도 |
|---|---|
| [.github/PULL_REQUEST_TEMPLATE.md](../../.github/PULL_REQUEST_TEMPLATE.md) | PR 작성 시 자동 삽입 |
| [.github/ISSUE_TEMPLATE/bug_report.md](../../.github/ISSUE_TEMPLATE/bug_report.md) | 버그 보고 |
| [.github/ISSUE_TEMPLATE/feature_request.md](../../.github/ISSUE_TEMPLATE/feature_request.md) | 기능 제안 |
| [.github/ISSUE_TEMPLATE/task.md](../../.github/ISSUE_TEMPLATE/task.md) | 일반 작업 |
| [.github/CODEOWNERS](../../.github/CODEOWNERS) | 영역별 리뷰어 자동 배정 (팀원 계정 입력 후 활성화) |

아래 본문은 그 파일들의 설계 근거이자, 다른 프로젝트에서 재사용할 때의 원본입니다. 실제 동작하는 파일과 아래 내용이 어긋나면 **실제 파일이 Source of Truth**입니다.

Issue를 언제 어떻게 쓰는지의 상황별 처리 규칙은 [workflow.md의 Issue 관리](workflow.md#issue-관리)를 따릅니다.

---

# Issue Templates

`.github/ISSUE_TEMPLATE/` 아래 파일명 그대로 저장해 사용합니다. 아래는 이 저장소에 실제로 반영된 내용의 기준선이며, 게임 특성에 맞춘 항목(Unity 버전, 네트워크 역할 등)이 실제 파일에 추가되어 있습니다.

## Bug Report (`bug_report.md`)

```markdown
---
name: Bug Report
about: 버그를 보고합니다
labels: bug
---

## 증상

무엇이 잘못되었는지 설명합니다.

## 재현 절차

1.
2.
3.

## 기대 동작

원래 어떻게 동작해야 하는지 설명합니다.

## 환경

- Unity 버전:
- 플랫폼:

## Severity

- [ ] Critical
- [ ] High
- [ ] Medium
- [ ] Low
```

## Feature Request (`feature_request.md`)

```markdown
---
name: Feature Request
about: 새로운 기능을 제안합니다
labels: enhancement
---

## 배경

왜 이 기능이 필요한지 설명합니다.

## 제안 내용

무엇을 만들 것인지 설명합니다.

## 대안

검토했던 다른 방법이 있다면 적습니다.
```

## Task (`task.md`)

```markdown
---
name: Task
about: 일반 작업 단위를 등록합니다
labels: task
---

## 작업 내용

무엇을 할 것인지 설명합니다.

## 완료 조건

- [ ]
- [ ]

## 담당자 / Sprint

- 담당자:
- Sprint:
```

---

# Pull Request Template

저장소 루트의 `.github/PULL_REQUEST_TEMPLATE.md`에 저장해 사용합니다. [workflow.md의 Pull Request Process](workflow.md#pull-request-process) 1~6단계와 짝을 이룹니다.

```markdown
## 변경 목적

이 PR이 해결하는 문제 또는 추가하는 기능을 설명합니다.

## 주요 내용

-
-

## 관련 Issue

Closes #

## 테스트

- [ ] 로컬에서 동작 확인
- [ ] 관련 테스트 추가/수정

## 체크리스트

- [ ] Commit Convention을 따랐다
- [ ] 관련 문서를 갱신했다 (필요한 경우)
```

---

# Notion 연동 규칙

[integrations/notion/databases.md](../notion/databases.md)의 **Tasks Database**와 **Bug Reports Database**에는 이미 `GitHub Issue`(URL) 속성이 있습니다. Issue 생성 시 다음 매핑에 따라 해당 Database에 항목을 만들고 `GitHub Issue` 속성에 Issue URL을 채웁니다.

| Issue Template | Notion Database | 매핑 예시 |
|---|---|---|
| Feature Request, Task | Tasks | `Title` ← Issue 제목, `Priority` ← Issue label, `Assignee` ← 담당자, `GitHub Issue` ← Issue URL |
| Bug Report | Bug Reports | `Title` ← Issue 제목, `Severity` ← 템플릿의 Severity 체크박스, `Assigned To` ← 담당자, `GitHub Issue` ← Issue URL |

> **현재 상태**: 이 동기화는 자동화되어 있지 않습니다. Issue 생성 후 수동으로 Notion에 반영하거나, Documentation Agent에게 위임합니다 (Notion 쓰기는 [Documentation Agent 전용 채널](../notion/workflow.md#작성-채널-documentation-agent-전용)). GitHub Actions를 통한 자동 동기화는 [automation.md의 "지금 하지 않는 것"](automation.md#지금-하지-않는-것)에 명시된 대로 Notion MCP의 OAuth 특성상 CI 러너에서 재현이 어려워 보류되어 있으며, Notion "GameDev-Platform 진행 현황" 페이지의 다음 단계 제안 항목으로 남겨두었습니다.

---

# Related Documents

| Document | Description |
|---|---|
| [workflow.md](workflow.md) | Branch 전략, Commit Convention, PR/Review 프로세스, Issue 상황별 처리 규칙 |
| [automation.md](automation.md) | GameDev-Platform 자신의 self-CI 전략 (이 문서와 스코프가 다름) |
| [integrations/notion/databases.md](../notion/databases.md) | Tasks / Bug Reports Database 속성 정의 |
| [integrations/notion/workflow.md](../notion/workflow.md) | Notion 작성 채널 규칙 |
