# GitHub Workflow

---

> **적용 범위**: 이 문서는 **이 저장소(`cowship/GameDev-Platform`)의 협업 표준**입니다.
> 2026-09-02부로 이 저장소는 플랫폼 문서와 실제 게임 프로젝트(`game/`)를 함께 담게 되었고,
> 5인 팀이 함께 사용합니다 ([ADR 0006](../../docs/decisions/0006-game-development-in-platform-repository.md)).
> 그에 따라 기존의 "1인 main 직접 커밋" 운영에서 **PR 기반 협업**으로 전환했습니다.
> 팀원 관점의 일상 절차와 Unity 특화 규칙은 [docs/team/README.md](../../docs/team/README.md)를 참고하세요.

---

# Development Philosophy

GitHub는 코드 변경 이력과 협업 과정을 투명하게 기록하는 기반입니다.

모든 변경 사항은 추적 가능해야 하며, 중요한 결정은 PR 또는 Issue에 근거를 남깁니다.

---

# Branch Strategy

```text
main                        ← 게임 개발 본류 (직접 push 금지, PR로만 병합)
├── feature/{name}          ← 신규 기능
├── fix/{name}              ← 버그 수정
├── chore/{name}            ← 문서, 설정, 스크립트 등 비기능 변경
│
└── sandbox/{팀원이름}       ← 개인 실험/공부 전용 (main에 직접 병합하지 않음)
```

| Branch | 용도 | main 병합 | 리뷰 |
|---|---|---|---|
| main | 팀이 함께 만드는 게임의 단일 기준. 항상 열리고 실행되는 상태를 유지 | — | — |
| feature/* | 신규 기능 개발 | PR | 1명 이상 |
| fix/* | 버그 수정 | PR | 1명 이상 |
| chore/* | 문서, 설정 등 비기능 변경 | PR | 1명 이상 |
| sandbox/* | 팀원 개인의 기능 실험·학습 공간. 소유자만 push하며 force push 허용 | **하지 않음** | 불필요 |

`develop` 통합 Branch는 두지 않습니다. 팀 규모가 5명이고 아직 배포 대상이 없어, `main`과 `develop`을 이중으로 관리하는 비용이 얻는 안정성보다 큽니다. 정식 릴리즈를 시작해 "개발 중인 main"과 "출시된 버전"을 분리해야 하는 시점이 오면 그때 재도입합니다 ([ADR 0006](../../docs/decisions/0006-game-development-in-platform-repository.md) Alternatives 참고).

sandbox Branch의 상세 운영 규칙(실험 결과를 main으로 옮기는 방법 포함)은 [docs/team/README.md](../../docs/team/README.md)에 있습니다.

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

1. `main`에서 작업 Branch 생성
2. 작업 완료 후 PR 생성 (대상: `main`)
3. [PR 템플릿](../../.github/PULL_REQUEST_TEMPLATE.md)의 변경 목적·체크리스트 작성
4. Review 요청 (`.github/CODEOWNERS`에 따라 자동 배정)
5. Approve 후 **Squash and merge**
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