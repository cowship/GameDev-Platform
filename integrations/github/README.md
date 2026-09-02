# GitHub Integration

> GameDev-Platform의 버전 관리 및 협업 플랫폼입니다.

---

# Overview

GameDev-Platform는 GitHub를 코드 버전 관리와 팀 협업의 중심 플랫폼으로 사용합니다.

GitHub는 단순한 코드 저장소가 아니라 Branch 전략, Commit 규칙, PR Review, Issue 관리를 통해 프로젝트 품질과 협업 효율을 유지하는 기반입니다.

GitHub Actions 기반 self-CI(`automation.md`)가 구축되어 있으며, 향후 MCP를 통해 Claude Code, Notion과 추가로 연동됩니다.

---

# Responsibilities

GitHub Integration은 다음을 담당합니다.

- Repository 관리
- Branch 전략
- Commit Convention
- Pull Request 프로세스
- Code Review 규칙
- Issue 관리
- CI/CD 자동화

---

# Directory Structure

```text
github/

├── README.md
├── setup.md
├── workflow.md
├── automation.md
└── templates.md
```

---

# Related Documents

| Document | Description |
|----------|-------------|
| setup.md | GitHub 계정, SSH, Repository 초기 설정 |
| workflow.md | Branch 전략(main / feature / sandbox), Commit Convention, PR/Review 프로세스 |
| automation.md | GameDev-Platform 자신을 검증하는 GitHub Actions self-CI 전략 |
| templates.md | Issue/PR Template 설계 근거, Notion 연동 규칙 |

---

# Related Documents (Outside this Directory)

| Document | Description |
|----------|-------------|
| [docs/team/README.md](../../docs/team/README.md) | 팀원이 매일 따르는 협업 절차 (Branch 사용법, Unity 공동 작업 규칙) |
| [docs/team/ONBOARDING.md](../../docs/team/ONBOARDING.md) | 팀원 최초 환경 구축 |
| [.github/CODEOWNERS](../../.github/CODEOWNERS) | 영역별 리뷰어 자동 배정

---

# Future Plans

향후 다음 항목을 추가할 예정입니다.

- MCP를 통한 Claude Code 자동 연동

---

# Goal

GitHub를 GameDev-Platform의 표준 협업 인프라로 활용하여 코드 품질과 협업 효율을 동시에 확보합니다.