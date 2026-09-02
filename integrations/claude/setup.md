# Claude Code Setup

---

# Requirements

Claude Code 사용 전 다음 환경이 준비되어 있어야 합니다.

- Windows 10 (1809+) 또는 Windows 11
- [Git for Windows](https://git-scm.com/download/win) — Git Bash 제공 (Claude Code의 Bash 도구가 이를 사용)
- Node.js
- VS Code
- GitHub SSH 인증

> 이 프로젝트는 Windows 단일 환경으로 운영합니다. WSL은 사용하지 않습니다 ([ADR 0008](../../docs/decisions/0008-windows-only-development-environment.md)).

---

# Installation

Windows 설치 방법은 [공식 문서](https://code.claude.com/docs/en/setup)를 따릅니다.

Git for Windows가 설치되어 있으면 Claude Code가 Git Bash를 Bash 도구로 사용합니다. 없으면 PowerShell로 대체되며, 이 저장소의 `scripts/*.sh`를 실행할 수 없으므로 Git for Windows 설치를 권장합니다.

---

# Verify Installation

```bash
claude --version
```

정상적으로 버전이 출력되면 설치가 완료된 것입니다.

---

# Login

Claude Code 로그인

```bash
claude login
```

현재는 개인 계정으로 테스트한 후, 추후 Team 계정으로 전환하는 것을 권장합니다.

---

# Project Initialization

프로젝트 루트에서 실행합니다.

```bash
claude
```

Claude는 프로젝트를 분석하며 다음 파일을 우선적으로 참고합니다.

- README.md
- CLAUDE.md
- agents/

---

# Recommended Environment

- VS Code
- Git for Windows (Git Bash)
- GitHub Repository
- Claude Code
- Unity Hub
- Notion

---

# Recommended Skills

GameDev-Platform이 채택한 외부(커뮤니티) Claude Code Skill입니다.

| Skill | 용도 | 채택 이유 |
|---|---|---|
| [unity-coding-skills](https://github.com/nowsprinting/unity-coding-skills) (nowsprinting) | Unity Test-first workflow, 코딩 가이드라인, Scene 편집 | `agents/unity.md`의 원칙(유지보수성, 낮은 결합도)과 방향이 일치 |

설치는 아래 스크립트로 자동화되어 있습니다 (여러 번 실행해도 안전).

```bash
./scripts/setup_claude_skills.sh
```

설치 후에는 Claude Code 세션을 재시작해야 새 Skill이 로드됩니다.

---

# Troubleshooting

## `claude: command not found`

설치 후 새 터미널을 열어야 PATH가 반영됩니다. 그래도 안 되면 [공식 설치 문제 해결 문서](https://code.claude.com/docs/en/troubleshoot-install)를 참고합니다.

---

## `scripts/*.sh`가 실행되지 않음

Git for Windows가 설치되지 않아 Claude Code가 PowerShell을 쓰고 있을 가능성이 큽니다. Git for Windows를 설치하면 Bash 도구가 활성화됩니다.

---

# References

- [Claude Code 공식 문서](https://code.claude.com/docs/en/overview)
- [Advanced setup](https://code.claude.com/docs/en/setup) — Windows 요구사항 (Git for Windows / PowerShell)
- [Git for Windows](https://git-scm.com/download/win)