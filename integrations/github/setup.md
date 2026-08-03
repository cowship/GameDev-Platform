# GitHub Setup

---

# Requirements

GitHub 사용 전 다음 환경이 준비되어 있어야 합니다.

- GitHub 계정
- Git
- SSH Key (ed25519 권장)
- GitHub CLI (`gh`, 선택)

---

# SSH Key 생성

`./scripts/check_environment.sh`를 실행하면 SSH Key가 없을 때 생성 여부를 물어보고, y 입력 시 자동으로 생성한 뒤 Public Key를 화면에 출력합니다 (GitHub 웹사이트 등록은 자동화할 수 없어 수동으로 진행해야 합니다).

수동으로 생성하려면 기존 키가 없는 경우 다음을 실행합니다.

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

키 확인

```bash
cat ~/.ssh/id_ed25519.pub
```

`check_environment.sh` 스크립트가 `~/.ssh/id_ed25519.pub` 존재 여부를 자동으로 확인합니다.

---

# SSH Key 등록

1. GitHub → Settings → SSH and GPG keys 이동
2. New SSH Key 클릭
3. 위에서 확인한 Public Key 붙여넣기

---

# 연결 테스트

```bash
ssh -T git@github.com
```

정상적으로 인증되면 사용자 이름이 포함된 환영 메시지가 출력됩니다.

---

# GitHub CLI 설치 (선택)

```bash
sudo apt install gh
```

로그인

```bash
gh auth login
```

---

# Repository Naming Convention

| 유형 | 규칙 | 예시 |
|---|---|---|
| Platform Repository | `{name}-Platform` | `GameDev-Platform` |
| Game Project Repository | `{game-name}` | `MyGame` |

Platform Repository와 실제 게임 Repository는 항상 분리합니다.

---

# Branch Protection (main)

Repository 생성 후 `main` Branch에 다음 설정을 권장합니다.

- Require Pull Request before merging
- Require status checks to pass (CI 도입 시)
- Do not allow force push

---

# Verify Installation

```bash
git --version
gh --version
```

버전이 정상 출력되면 설정이 완료된 것입니다.

---

# Troubleshooting

## SSH 인증 실패

```text
Permission denied (publickey)
```

→ SSH Key가 GitHub에 등록되어 있는지, `ssh-agent`에 키가 로드되어 있는지 확인합니다.

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## gh 인증 오류

```text
gh: To use GitHub CLI in a codespace, ...
```

→ `gh auth status`로 로그인 상태를 확인 후 `gh auth login`을 재실행합니다.

---

# References

- GitHub Docs - Connecting with SSH
- GitHub CLI Documentation