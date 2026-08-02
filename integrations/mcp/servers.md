# Registered MCP Servers

---

# Purpose

현재 GameDev-Platform에 등록된 MCP Server 목록과 연결 방식을 관리합니다.

---

# GitHub

| 항목 | 내용 |
|---|---|
| Transport | Local (stdio) |
| 서버 | `npx -y @modelcontextprotocol/server-github` |
| 인증 방식 | Personal Access Token (환경변수 `GITHUB_PERSONAL_ACCESS_TOKEN`) |
| 등록 명령 | `claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=<token> -- npx -y @modelcontextprotocol/server-github` |
| 상태 확인 | `claude mcp list` |

**변경 이력**: 처음에는 Remote(OAuth, `api.githubcopilot.com/mcp/`) 방식을 시도했으나 `Incompatible auth server: does not support dynamic client registration` 에러로 연결 실패. Local PAT 방식으로 전환하여 해결했습니다.

토큰은 절대 Repository에 커밋하지 않고 로컬 환경변수(`~/.bashrc`)로만 관리합니다. `.claude.json`(사용자 홈 디렉토리)에 `-e` 값이 저장되며, 이 파일 역시 Repository 바깥에 위치합니다.

---

# Filesystem

| 항목 | 내용 |
|---|---|
| Transport | Local (stdio) |
| 서버 | `npx -y @modelcontextprotocol/server-filesystem /home/minsooim1/workspace/GameDev-Platform` |
| 인증 방식 | 없음 (로컬 파일시스템 직접 접근) |
| 접근 범위 | 저장소 루트(`/home/minsooim1/workspace/GameDev-Platform`)로 제한 |
| 등록 명령 | `claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /home/minsooim1/workspace/GameDev-Platform` |
| 상태 확인 | `claude mcp list` |

**상태**: 등록 및 연결 확인 완료 (`claude mcp list`에서 Connected).

---

# Sequential Thinking

| 항목 | 내용 |
|---|---|
| Transport | Local (stdio) |
| 서버 | `npx -y @modelcontextprotocol/server-sequential-thinking` |
| 인증 방식 | 없음 |
| 용도 | 범용 사고 보조 (Architecture 설계, ADR 작성 등 복잡한 판단 보조) |
| 등록 명령 | `claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking` |
| 상태 확인 | `claude mcp list` |

**상태**: 등록 및 연결 확인 완료 (`claude mcp list`에서 Connected).

---

# Notion

아직 등록되지 않았습니다.

Notion MCP는 실제 Notion Workspace(`integrations/notion/workspace.md`)가 구축된 이후 연동할 예정입니다.

---

# 등록 확인

```bash
claude mcp list
```

---

# Related Documents

| Document | Description |
|---|---|
| [setup.md](setup.md) | MCP Server 등록 절차 |
| [workflow.md](workflow.md) | MCP 사용 흐름 및 권한 원칙 |