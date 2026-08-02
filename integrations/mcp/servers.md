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

| 항목 | 내용 |
|---|---|
| Transport | Remote |
| 인증 방식 | Notion 계정 연동 (Claude Code 환경에서 자동 등록) |
| 상태 확인 | `notion-get-users`(user_id: self) 또는 `notion-fetch`(id: self) 호출 |

**상태**: 등록 및 연결 확인 완료. `GameDev-Platform 진행 현황` 페이지를 생성하여 검증했습니다.

`integrations/notion/workspace.md`에 계획된 Workspace 구조(🏠 Home, 🎮 Projects 등)와 `databases.md`에 설계된 Database는 아직 실제 Notion에 구축되지 않았습니다.

---

# Context7

| 항목 | 내용 |
|---|---|
| Transport | Local (stdio) |
| 서버 | `npx -y @upstash/context7-mcp` |
| 인증 방식 | 없음 (API Key 미사용, 무료 등급 — 요청량이 많아지면 [context7.com/dashboard](https://context7.com/dashboard)에서 키 발급 후 `-e CONTEXT7_API_KEY=<key>` 형태로 추가 가능) |
| 용도 | 라이브러리/프레임워크의 최신 공식 문서·예제를 실시간 조회 (Unity API, C# 라이브러리 등에서 환각 방지) |
| 등록 명령 | `claude mcp add context7 -- npx -y @upstash/context7-mcp` |
| 상태 확인 | `claude mcp list` |

**상태**: 등록 및 연결 확인 완료 (`claude mcp list`에서 Connected).

---

# Unity MCP

| 항목 | 내용 |
|---|---|
| 성격 | Unity Editor(런타임 상태, Scene, Console 등)를 Claude Code가 직접 조회/조작하도록 연결하는 서버 |
| 선택된 방식 | Unity 공식 MCP (Unity 6000.0+ 내장 `com.unity.ai.assistant` 패키지, Editor 자체가 서버 역할) |
| 실행 위치 | Unity Editor가 설치된 Windows 환경 (본 Repository의 Claude Code는 WSL에서 실행 중이라 환경이 분리되어 있음) |
| 상태 | **대기** — 아직 Unity 프로젝트가 생성되지 않아 실제 등록 불가 |

**연결 전 필요한 것**:

1. Unity 프로젝트 생성 (Unity 6000.0 이상, `com.unity.ai.assistant` 패키지 포함 여부 확인 — 없으면 Package Manager에서 추가)
2. Unity Editor: `Edit > Project Settings > AI > Unity MCP` 에서 Unity Bridge 상태가 초록색 `Running`인지 확인 (Editor 시작 시 자동 실행됨)
3. 같은 화면에서 Claude Code용 연결 설정(Config 스니펫 또는 릴레이 실행 파일 경로)을 **그 시점에 Editor가 보여주는 그대로** 복사해서 사용 — 패키지 버전에 따라 `http://localhost:<port>/mcp` 형태이거나 플랫폼별 relay 실행 파일(`~/.unity/relay/...`)을 쓰는 방식일 수 있어, 오래된 블로그 글의 설정값을 그대로 베끼지 않고 Editor가 보여주는 최신 안내를 기준으로 삼습니다.
4. Claude Code에서 세션을 시작하면 Unity MCP 설정 창의 "Pending Connections"에 연결 요청이 뜨고, 여기서 **Accept**해야 실제로 연결됩니다.

**WSL ↔ Windows 네트워크 주의사항**:

Unity Bridge는 기본적으로 `127.0.0.1`(로컬호스트)에만 바인딩되어 외부 네트워크에서 접근할 수 없습니다. 이 Repository의 Claude Code는 WSL2(NAT 모드, `.wslconfig`에 `networkingMode=mirrored` 미설정) 안에서 실행 중이라, WSL의 `localhost`와 Windows의 `localhost`가 서로 다른 주소로 취급되어 **기본 설정으로는 Unity MCP에 연결되지 않을 가능성이 높습니다.** 확인된 Windows 빌드(10.0.26200)는 Mirrored Networking을 지원하므로, Unity 프로젝트 생성 후 다음 중 하나를 선택합니다.

- **(권장) WSL Mirrored Networking 활성화**: Windows 사용자 홈의 `.wslconfig`에 아래 내용을 추가한 뒤 PowerShell에서 `wsl --shutdown` 실행 (현재 세션도 함께 종료되므로 재시작 필요)
  ```ini
  [wsl2]
  networkingMode=mirrored
  ```
  이후 WSL의 `localhost`와 Windows의 `localhost`가 동일하게 취급되어 Unity Bridge에 그대로 접속 가능합니다.
- **(대안) Unity 작업 세션은 Windows 네이티브 터미널에서 실행**: Unity MCP를 쓸 때만 PowerShell/CMD에서 직접 `claude`를 실행 — 네트워크 경계 문제 자체가 사라지지만 세션을 분리해서 써야 합니다.

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