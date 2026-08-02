# Claude Code Setup

---

# Requirements

Claude Code 사용 전 다음 환경이 준비되어 있어야 합니다.

- Windows 11
- WSL2
- Ubuntu 24.04 LTS
- Git
- Node.js (nvm 권장)
- VS Code
- GitHub SSH 인증

---

# Installation

Claude Code 설치

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

---

# PATH 설정

설치 후 `claude` 명령어가 인식되지 않는 경우 다음 명령어를 실행합니다.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

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

- VS Code + WSL
- GitHub Repository
- Claude Code
- Unity Hub
- Notion

---

# Troubleshooting

## PATH 오류

```text
claude: command not found
```

→ PATH를 설정한 후 새로운 터미널을 실행합니다.

---

## apt Update 오류

WSL 설치 과정에서 `/etc/apt/sources.list`에 잘못된 저장소가 추가될 수 있습니다.

해결 방법

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sudo truncate -s 0 /etc/apt/sources.list
sudo apt update
```

---

# References

- Claude Code 공식 문서
- Ubuntu WSL Documentation
- Node Version Manager (nvm)