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

`setup.sh`는 `check_environment.sh`로 현재 환경을 점검하고, `setup_mcp.sh`로 MCP Server 등록까지 자동으로 진행한 뒤, 아래 문서 순서를 안내합니다. 비개발자도 이 한 줄만 실행하면 GitHub Personal Access Token 입력 안내를 포함해 대부분의 MCP 등록이 끝납니다 (Notion·Unity MCP는 계정 연동/Unity Editor가 필요해 수동 단계로 안내됩니다).

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

Git, Node.js, Claude Code, VS Code, GitHub SSH Key 설치 여부를 확인합니다.

---

# Related Documents

| Document | Description |
|---|---|
| [scripts/setup.sh](../../scripts/setup.sh) | 전체 설정 진입점 |
| [scripts/check_environment.sh](../../scripts/check_environment.sh) | 환경 점검 스크립트 |
| [scripts/setup_mcp.sh](../../scripts/setup_mcp.sh) | MCP Server 자동 등록 스크립트 (반복 실행 안전) |