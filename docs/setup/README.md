# Setup Guide

> GameDev-Platform 개발 환경 설정 인덱스입니다.
> 실행 환경은 **Windows + Git Bash**입니다 ([ADR 0008](../decisions/0008-windows-only-development-environment.md)).

---

# 어디서 시작하나

| 상황 | 문서 |
|---|---|
| **팀원으로 게임 개발에 참여** | [docs/team/ONBOARDING.md](../team/ONBOARDING.md) ← 여기서 시작하세요 |
| 협업 규칙이 궁금할 때 | [docs/team/README.md](../team/README.md) |
| 개별 도구 설정이 궁금할 때 | 아래 표 |

---

# Scripts

스크립트는 3개뿐입니다. 대상 독자가 각각 다릅니다.

| 스크립트 | 대상 | 역할 |
|---|---|---|
| [setup_team_member.sh](../../scripts/setup_team_member.sh) | **팀원 전원 필수** | Git 사용자 확인, Git LFS 초기화, UnityYAMLMerge 병합 드라이버 등록, sandbox 브랜치 준비 |
| [setup_mcp.sh](../../scripts/setup_mcp.sh) | Claude Code 사용자 | MCP 서버 등록 (filesystem / sequential-thinking / context7 / github / Unity) |
| [setup_claude_skills.sh](../../scripts/setup_claude_skills.sh) | Claude Code 사용자 | Unity 전용 Claude Skill 설치 |

모두 여러 번 실행해도 안전합니다. Git Bash에서 저장소 루트 기준으로 실행합니다.

> [check_agent_drift.sh](../../scripts/check_agent_drift.sh)는 온보딩용이 아니라 CI가 쓰는 검증 도구입니다.

---

# Setup Documents

| 순서 | 영역 | 문서 |
|---|---|---|
| 1 | GitHub (SSH Key, 저장소) | [integrations/github/setup.md](../../integrations/github/setup.md) |
| 2 | Unity (Hub, Editor, Git LFS) | [integrations/unity/setup.md](../../integrations/unity/setup.md) |
| 3 | Photon Fusion | [integrations/photon/setup.md](../../integrations/photon/setup.md) |
| 4 | Claude Code | [integrations/claude/setup.md](../../integrations/claude/setup.md) |
| 5 | MCP | [integrations/mcp/setup.md](../../integrations/mcp/setup.md) |
| 6 | Notion | [integrations/notion/workspace.md](../../integrations/notion/workspace.md) *(설치 절차 없음, Workspace 구조 문서)* |

---

# 자동화할 수 없는 항목

Windows에서는 대부분의 도구가 GUI 설치라 스크립트로 대신할 수 없습니다. 아래는 사람이 직접 해야 합니다.

- [ ] **Git for Windows 설치** — Git Bash와 Git LFS가 함께 설치됩니다. `git --version`, `git lfs version`으로 확인
- [ ] **Unity Hub + Editor 6000.3.22f1 설치** — 버전이 다르면 프로젝트 파일이 갈립니다
- [ ] **GitHub SSH Key 등록** — 키 생성은 명령 한 줄이지만, GitHub 웹사이트에 공개키를 붙여넣는 것은 수동. `ssh -T git@github.com`으로 확인
- [ ] **Collaborator 초대 수락** — 수락 전에는 clone/push가 되지 않습니다
- [ ] **Photon App Id 발급 및 입력** — [integrations/photon/setup.md](../../integrations/photon/setup.md)
- [ ] **Notion MCP 계정 연동** — 브라우저 OAuth라 CLI로 대신할 수 없음 (Claude Code 사용자만 해당)

---

# Related Documents

| Document | Description |
|---|---|
| [docs/team/ONBOARDING.md](../team/ONBOARDING.md) | 팀원 최초 환경 구축 절차 (SSH → clone → 스크립트 → Unity → Photon) |
| [docs/team/README.md](../team/README.md) | 협업 규칙 |
| [.github/workflows/](../../.github/workflows/) | Agent 드리프트 검사, Shellcheck |
| [docs/decisions/0008-windows-only-development-environment.md](../decisions/0008-windows-only-development-environment.md) | Windows 단일 환경으로 정한 근거 |
