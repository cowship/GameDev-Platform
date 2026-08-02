# GitHub Workflow

---

# Development Philosophy

GitHub는 코드 변경 이력과 협업 과정을 투명하게 기록하는 기반입니다.

모든 변경 사항은 추적 가능해야 하며, 중요한 결정은 PR 또는 Issue에 근거를 남깁니다.

---

# Branch Strategy

```text
main
│
├── develop
│   │
│   ├── feature/{name}
│   ├── fix/{name}
│   └── chore/{name}
```

| Branch | 용도 |
|---|---|
| main | 배포 가능한 안정 버전 |
| develop | 다음 릴리즈를 위한 통합 Branch |
| feature/* | 신규 기능 개발 |
| fix/* | 버그 수정 |
| chore/* | 문서, 설정 등 비기능 변경 |

---

# Commit Convention

Conventional Commits 형식을 따릅니다.

```text
{type}: {summary}
```

| Type | 설명 |
|---|---|
| feat | 새로운 기능 추가 |
| fix | 버그 수정 |
| docs | 문서 변경 |
| refactor | 리팩토링 |
| chore | 빌드, 설정 등 기타 변경 |
| test | 테스트 추가/수정 |

예시

```text
feat: Add QA Agent role definition
docs: Add GitHub integration setup guide
```

기능 단위로 Commit하며, 하나의 Commit에는 하나의 목적만 포함합니다.

---

# Pull Request Process

1. `develop`에서 작업 Branch 생성
2. 작업 완료 후 PR 생성 (대상: `develop`)
3. PR 설명에 변경 목적과 주요 내용 작성
4. Review 요청
5. Approve 후 Merge
6. 작업 Branch 삭제

---

# Review 규칙

- 최소 1명 이상의 Review를 권장합니다.
- 구조적 변경(Architecture, 주요 시스템)은 Technical Lead 관점에서 검토합니다.
- Merge 전 Conflict를 해결합니다.

---

# Issue 관리

Issue는 작업 단위를 추적하는 기본 수단입니다.

향후 Notion Tasks / Bug Reports Database와 GitHub Issue를 상호 연동합니다.

| 상황 | 처리 |
|---|---|
| 새로운 작업 | Issue 생성 후 Branch 연결 |
| 버그 발견 | Bug Issue 생성 |
| PR 병합 | 관련 Issue 자동 Close (`Closes #N`) |

---

# Documentation 연계

다음 변경 사항은 PR과 함께 문서화합니다.

- Architecture 변경
- 기술 선택
- 프로젝트 구조 변경
- Agent 역할 변경

---

# Long-term Vision

향후 GitHub는 다음 시스템과 연동됩니다.

- GitHub Actions (CI/CD)
- Notion (Task/Issue 동기화)
- Claude Code (MCP 기반 자동화)

이를 통해 코드 변경부터 문서화까지 이어지는 자동화된 개발 흐름을 구축하는 것을 목표로 합니다.