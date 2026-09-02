# GitHub Actions Automation

> GameDev-Platform 저장소 **자신**을 검증하는 CI(Self-CI) 전략입니다.

---

# Scope

> **적용 범위**: 이 문서는 [workflow.md](workflow.md)와 대상이 다릅니다.
> `workflow.md`는 Stage 6에서 생성되는 **게임 프로젝트 Repository**가 따를 협업 표준(Branch 전략, Issue 관리 등)을 다루고, 이 문서는 **GameDev-Platform 저장소 자체**를 검증하는 CI를 다룹니다.
> GameDev-Platform은 `docs/decisions/`(ADR)를 Single Source of Truth로 삼아 `main`에 직접 커밋·push하는 방식으로 운영되며, 아래 CI는 이 운영 모델을 바꾸지 않습니다. **머지를 막는 게이트가 아니라, push 이후 문제를 잡아내는 사후 안전망**으로 설계되었습니다.

---

# Overview

GameDev-Platform은 대부분 Markdown 문서 + Bash 스크립트 + 설정 파일로 구성되어 있고, 컴파일되는 애플리케이션이나 배포 대상이 없습니다. 따라서 일반적인 빌드/테스트/배포 CI/CD가 아니라, **문서와 스크립트의 정합성을 검증하는 CI**가 이 저장소에 맞는 형태입니다.

---

# 검증 항목

| 항목 | 도구 | 우선순위 | 근거 |
|---|---|---|---|
| Agent 3계층 드리프트 | `scripts/check_agent_drift.sh` (기존 스크립트를 CI로 감쌈) | 최우선 | `agents/*.md` ↔ `.claude/agents/*.md` ↔ `.claude/commands/*.md` 3계층을 사람이 수동으로 동시에 맞춰야 해서 드리프트가 나기 가장 쉬운 지점. 이미 검증 로직이 존재해 도구 신설 없이 CI로 감싸기만 하면 됨 |
| Shell Script 정적 분석 | `shellcheck` | 높음 | `scripts/`는 비개발자 사용자가 온보딩 시 그대로 실행하는 진입점(`setup.sh` 등). `ubuntu-latest` 러너에 기본 설치되어 있어 marketplace action 없이 바로 사용 가능 |
| Markdown 링크 체크 | `lychee-action` | 중간 (3단계) | 문서 간 상대경로 링크가 촘촘해 파일 이동/rename 시 깨진 링크가 조용히 신뢰성을 해침. 외부 URL의 일시적 장애로 인한 오탐을 피하기 위해 **내부 상대경로 링크만 검사** |
| Markdown 스타일 lint | `markdownlint-cli2-action` | 중간 (4단계) | 여러 Agent가 각각 문서를 생성하는 구조상 스타일 드리프트가 누적되기 쉬움. 링크 깨짐보다 위험도는 낮은 미관 문제 |
| 워크플로 파일 자체 검증 | `actionlint` | 낮음 (5단계, 지연 도입) | 워크플로 파일이 1~2개일 때는 과잉. 3~4개로 늘어나 "CI를 검증하는 CI"의 ROI가 생기는 시점에 도입 |

---

# 지금 하지 않는 것

| 항목 | 미루는 이유 |
|---|---|
| 실제 배포(CD) 파이프라인 | 배포 대상이 없음. `templates/unity-starter/`도 아직 실물로 생성되지 않았고(Stage 6 트리거 대기), Stage 6 게임 Repo 자체가 없음 |
| Unity 전용 CI (Test Runner, 빌드 검증 등) | 이 저장소에 Unity 프로젝트 코드가 없음. `integrations/unity/`는 스펙 문서일 뿐. Stage 4 게이트가 실물 코드로 열리거나 Stage 6 게임 Repo가 생기는 시점에 별도 설계 |
| Dependabot / CodeQL 등 의존성·보안 스캔 | 저장소에 `package.json` 등 의존성 매니페스트가 없어 스캔할 대상이 없음. 신호 없는 노이즈만 늘어남 |
| 자동 포맷/자동 커밋 봇 | 이미 "문서 변경은 확인 없이 자동 커밋+push"라는 관례가 있음. 여기에 CI 봇의 자동 커밋까지 겹치면 커밋 히스토리 오염과 충돌 가능성이 커지고, "누가 왜 바꿨는지" 추적성을 해침 |
| PR 필수화 / Required Status Check 강제 | 현재 운영 모델은 "main 직접 push". CI를 머지 게이트로 승격시키는 것은 협업 모델 자체를 바꾸는 결정이라 이 문서 스코프를 넘어섬 |
| Notion 연동 자동화 (Actions → Notion API) | Notion MCP는 브라우저 OAuth 기반이라 stateless CI 러너에서 재현하기 어렵고, [workflow.md](../../docs/workflow/README.md)가 "Notion 쓰기는 Documentation Agent 전용 채널"이라고 규정. CI가 이를 우회해 직접 Notion에 쓰는 것은 기존 협업 원칙과 충돌 |

---

# 단계적 도입 순서

ROI(설정 비용 대비 잡아내는 문제) 순으로 도입합니다. 새로운 Roadmap Stage를 만들지 않고, **Stage 1(scripts 검증)과 Stage 3(문서 품질)을 계속 보강하는 Automation First 작업**으로 위치시킵니다.

1. **Agent Drift Check** — 기존 스크립트를 감싸기만 함, 신규 도구 없음. (완료)
2. **Shellcheck** — 러너 기본 내장, marketplace action 불필요. (완료)
3. **Markdown 링크 체크**
4. **Markdown 스타일 lint** — 3, 4는 `docs-lint.yml` 하나에 job 2개(`link-check`, `markdown-lint`)로 묶어 워크플로 파일 수 증식을 억제
5. **actionlint** — 워크플로 파일이 3~4개로 늘어난 뒤 도입
6. **(보류) Unity CI** — Stage 4/6 게이트 이후 별도 설계. 이 문서 v1 범위 밖

---

# 네이밍 / 트리거 컨벤션

- GitHub Actions는 `.github/workflows/` 하위에 **평면 구조만 지원**하므로(하위 디렉토리 불가), 구분은 디렉토리가 아니라 **파일명**으로 합니다. kebab-case로 무엇을 검증하는지 파일명만 봐도 드러나게 합니다 (예: `agent-drift-check.yml`, `shellcheck.yml`, `docs-lint.yml`).
- 트리거는 다음 3종 조합을 기본값으로 통일합니다.
  - `pull_request` (paths 필터)
  - `push: branches: [main]` (동일 paths 필터)
  - `workflow_dispatch:`
  - 단, paths 범위는 워크플로별로 재판단합니다. 예를 들어 저장소 전역 `**/*.md`를 대상으로 하는 `docs-lint.yml`은 `shellcheck.yml`처럼 좁은 paths 필터를 그대로 복붙하면 안 됩니다.
- 워크플로 파일 상단에 한국어 설명 주석(무엇을 / 왜 / 제외 범위)을 유지합니다. 비개발자 사용자도 워크플로 파일을 열었을 때 목적을 바로 이해할 수 있게 하는 것이 이 저장소의 기존 관례입니다.
- Job 이름은 워크플로 목적을 그대로 반영하는 짧은 slug를 사용합니다 (`dry-run:`, `agent-drift:`, `shellcheck:`).

---

# 현재 구현 현황

| 워크플로 | 검증 대상 | 상태 |
|---|---|---|
| [agent-drift-check.yml](../../.github/workflows/agent-drift-check.yml) | Agent 3계층(`agents/`, `.claude/agents/`, `.claude/commands/`) 드리프트 | 완료 (1단계) |
| [shellcheck.yml](../../.github/workflows/shellcheck.yml) | `scripts/*.sh` 정적 분석 | 완료 (2단계) |

남은 3~6단계는 [integrations/notion/workflow.md](../notion/workflow.md) 절차에 따라 Notion "GameDev-Platform 진행 현황" 페이지의 다음 단계 제안 섹션에 기록되어 있습니다.

---

# Related Documents

| Document | Description |
|---|---|
| [workflow.md](workflow.md) | Stage 6 게임 프로젝트 Repository용 협업 표준 (이 문서와 스코프가 다름) |
| [templates.md](templates.md) | Stage 6 게임 프로젝트 Repository용 Issue/PR Template |
| [docs/setup/README.md](../../docs/setup/README.md) | 온보딩 스크립트 및 관련 CI 인덱스 |
| [docs/architecture/overview.md](../../docs/architecture/overview.md) | Roadmap Mapping, Design Principles |
