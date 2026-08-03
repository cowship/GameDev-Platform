# Setup Guide

> GameDev-Platform 개발 환경을 설정하기 위한 안내입니다.

---

# Overview

이 문서는 실제 설치 절차를 담지 않습니다.

각 도구의 설정 절차는 `integrations/` 아래 해당 문서에서 관리하며, 이 문서는 어디서 무엇을 확인해야 하는지 안내하는 인덱스입니다. (Single Source of Truth)

---

# Quick Start

```bash
./scripts/setup.sh
```

`setup.sh`는 `check_environment.sh`로 현재 환경을 점검하고 누락된 도구(Git, Node.js, Claude Code CLI, GitHub CLI, SSH Key 등)를 그 자리에서 설치한 뒤, `setup_mcp.sh`로 MCP Server 등록까지 자동으로 진행하고, 아래 문서 순서를 안내합니다. 비개발자도 이 한 줄만 실행하면 도구 설치 확인 → 설치 → GitHub Personal Access Token 입력 안내 → 대부분의 MCP 등록까지 끝납니다.

자동화할 수 없는 항목은 다음과 같습니다 (모두 스크립트가 안내 문구를 출력합니다).

- **VS Code**: Windows 쪽 GUI 설치가 필요 (WSL 내부에서 완전 자동화 불가)
- **GitHub SSH Key 등록**: Key 생성은 자동화되지만, GitHub 웹사이트에 Public Key를 붙여넣는 것은 수동
- **Notion MCP**: 계정 연동(브라우저 OAuth)이 필요해 수동
- **Unity MCP**: Unity 프로젝트 생성 + Editor 최소 1회 실행이 선행되어야 해서 수동 (`./scripts/setup_unity_workspace.sh`가 그 이후 단계를 자동화)

---

# Setup Documents

| 순서 | 영역 | 문서 |
|---|---|---|
| 1 | Claude Code | [integrations/claude/setup.md](../../integrations/claude/setup.md) |
| 2 | GitHub | [integrations/github/setup.md](../../integrations/github/setup.md) |
| 3 | Notion | [integrations/notion/workspace.md](../../integrations/notion/workspace.md) *(설치 절차 없음, Workspace 구조 문서로 대체)* |
| 4 | Unity | [integrations/unity/setup.md](../../integrations/unity/setup.md) |
| 5 | MCP | [integrations/mcp/setup.md](../../integrations/mcp/setup.md) |

---

# Environment Check

```bash
./scripts/check_environment.sh
```

Git, Git 사용자 정보, Node.js/npm, Claude Code, GitHub CLI, VS Code, GitHub SSH Key, WSL 여부를 확인하고, 자동화 가능한 항목은 확인 후 바로 설치합니다 (설치 여부는 매번 y/N으로 확인). 여러 번 실행해도 안전합니다.

---

# Related Documents

| Document | Description |
|---|---|
| [scripts/setup.sh](../../scripts/setup.sh) | 전체 설정 진입점 |
| [scripts/check_environment.sh](../../scripts/check_environment.sh) | 환경 점검 스크립트 |
| [scripts/setup_mcp.sh](../../scripts/setup_mcp.sh) | MCP Server 자동 등록 스크립트 (반복 실행 안전) |