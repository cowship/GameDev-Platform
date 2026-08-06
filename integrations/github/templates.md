# Issue / PR Templates

> Stage 6에서 생성되는 **게임 프로젝트 Repository**가 사용할 Issue/PR Template과 Notion 연동 규칙입니다.

---

# Scope

> **적용 범위**: [workflow.md](workflow.md)와 동일한 스코프입니다 — GameDev-Platform 저장소 자체의 규칙이 아니라 Stage 6에서 생성되는 게임 프로젝트 Repository가 따를 표준입니다.
> GameDev-Platform 자체는 Issue를 쓰지 않고 `docs/decisions/`(ADR) + main 직접 커밋으로 운영되므로, 이 저장소에 `.github/ISSUE_TEMPLATE/`을 실제로 만들지 않습니다. 아래 템플릿 내용은 **게임 Repo 생성 시 그대로 복사해 쓰는 원본**입니다 (`templates/`(루트) 디렉토리가 ADR/회의록 템플릿을 문서로 담아두는 것과 동일한 패턴).

Issue를 언제 어떻게 쓰는지의 상황별 처리 규칙은 [workflow.md의 Issue 관리](workflow.md#issue-관리)를 따릅니다. 이 문서는 그 규칙에 맞는 **템플릿 본문**과 **Notion 연동 규칙**만 다룹니다.

---

# Issue Templates

게임 Repo에서 `.github/ISSUE_TEMPLATE/` 아래 파일명 그대로 저장해 사용합니다.

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

게임 Repo 루트에 `.github/PULL_REQUEST_TEMPLATE.md`로 저장해 사용합니다. [workflow.md의 Pull Request Process](workflow.md#pull-request-process) 1~6단계와 짝을 이룹니다.

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
