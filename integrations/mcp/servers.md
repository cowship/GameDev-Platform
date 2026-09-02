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

**상태**: 등록 및 연결 확인 완료 (`claude mcp list`에서 Connected). 부작용 없는 읽기 전용 서버라 6개 Adapter Agent 전체에 접근을 허용했습니다 ([ADR 0005](../../docs/decisions/0005-context7-mcp-access.md)).

---

# Unity MCP

| 항목 | 내용 |
|---|---|
| 성격 | Unity Editor(런타임 상태, Scene, Console 등)를 Claude Code가 직접 조회/조작하도록 연결하는 서버 |
| 선택된 방식 | **Unity CLI의 MCP Mode** (`unity mcp`). Unity Hub(43.4.0+)가 자동 설치하는 독립 CLI 바이너리가 Editor 안의 Pipeline 패키지와 통신하고, Claude Code에는 stdio로 붙는다 |
| 서버 이름 | `unity-editor-mcp` |
| Transport | Local (stdio) |
| Scope | **user**(전역) — 이 Windows 계정에서 여는 모든 Unity 프로젝트에 공용으로 재사용됨 (프로젝트별 등록 아님) |
| 실행 위치 | Windows (Claude Code와 Unity CLI가 같은 OS에서 동작) |
| CLI 바이너리 경로 | `%LOCALAPPDATA%\Unity\bin\unity.exe` — Unity Hub(43.4.0+)가 자동 설치하며 PATH에 등록됨 |
| 등록 명령 | `unity mcp configure claude-code` (`scripts/setup_mcp.sh`가 자동 호출) |
| 스킬 | `unity skill install claude-code` — Unity CLI 사용법 스킬을 `~/.claude/skills/unity-cli/`에 설치 |
| 상태 | **등록 검증 완료 (2026-09-02, Windows)** — `scripts/setup_mcp.sh`가 `unity mcp configure claude-code`로 등록에 성공하고 `claude mcp list`에서 `unity-editor-mcp: unity mcp - Connected` 확인. `unity skill install claude-code`도 성공. Editor 연결(`unity status`) 확인은 프로젝트 최초 실행 이후 |

> 폐기된 이전 방식: 기존에는 Unity 6000.0+ 내장 `com.unity.ai.assistant` 패키지의 in-Editor MCP Bridge + `relay_win.exe`를 사용했으나(서버 이름 `unity-mcp`), Unity가 in-Editor MCP server를 폐기하고 Unity CLI로 대체한다고 공식 발표(2026-08)함에 따라 프로젝트 시작 전인 이 시점에 미리 CLI 방식으로 전환했습니다. `unity-mcp`/relay 등록은 제거됨.

> **자동화**: Unity MCP 등록과 스킬 설치는 `scripts/setup_mcp.sh`가 처리합니다 (여러 번 실행해도 안전). Windows에서는 `unity`가 PATH에 있어 공식 명령이 그대로 동작하므로, 예전처럼 바이너리 전체 경로를 직접 조립할 필요가 없습니다.

**연결 범위 — 계정이 아니라 "그 순간 열려 있는 Unity 프로젝트" 기준입니다**

- CLI 바이너리와 Claude Code `mcpServers` 등록은 **Windows 사용자 계정/머신 단위**로 각자 설치해야 합니다 (relay와 마찬가지로 공유하지 않음).
- 실제로 어떤 게임 데이터를 조작하는지는 **그 순간 Unity Editor에서 열려 있는 프로젝트**로 결정됩니다. `unity status` 명령으로 현재 CLI가 인식하는 연결된 Editor 목록(포트/프로젝트 경로/버전/PID)을 확인할 수 있습니다.
- 따라서 팀원이 같은 프로토타입 콘텐츠를 Claude와 함께 다루려면, CLI를 각자 설치하는 것과 별개로 **프로토타입 Unity 프로젝트(레포)를 그대로 클론해서 열어야** 합니다. 다른/빈 프로젝트를 열면 Claude는 그 프로젝트를 보게 됩니다.

**새 팀원 온보딩 체크리스트** (사람이 직접 해야 하는 GUI 단계 포함 — 완전 자동화 불가):

1. 프로토타입 레포 클론
2. **[사람이 직접]** Unity Editor(6000.0+, 이번 전환의 최소 요구 버전)로 그 프로젝트를 최소 1회 실행
3. **[사람이 직접 또는 스크립트]** 해당 프로젝트에 Unity Pipeline 패키지 설치: `unity pipeline install --project-path <프로젝트 경로>` (기존 `com.unity.ai.assistant` 패키지 대신 이 패키지가 CLI와 Editor를 연결하는 역할을 함)
4. GameDev-Platform 레포에서 `./scripts/setup_mcp.sh` 실행 → `unity mcp configure claude-code` + `unity skill install claude-code` 자동 수행
5. Claude Code 세션 재시작 → `unity status`로 Editor가 목록에 뜨는지 확인
6. 만약 4번 직후 `unity status`가 비어있다면, **Unity Editor 창을 한 번 클릭해서 포커스를 주세요.** Unity는 외부 프로세스(CLI)가 `manifest.json`을 바꿔도 창이 포커스를 받아야 그 변경을 재스캔합니다 — 포커스를 주고 나면 Pipeline 패키지 리졸브/컴파일이 끝난 뒤 자동으로 연결됩니다. "Pending Connections 수동 Accept" 같은 별도 승인 단계는 필요 없었습니다.

> **실측 이력 (2026-08-25, WSL 환경)**: 당시 Unity 6000.3.22f1 프로젝트(`rlawkd`)에 위 절차를 적용해 `unity status`에서 `State: ready`, `unity pipeline list`에서 `Server Reachable: true`까지 확인했고, `unity command`로 GameObject 생성/컴포넌트 부착/빌드/Console 조회 도구가 노출되는 것도 확인했습니다. 다만 그때는 WSL의 Claude Code가 Windows 바이너리를 전체 경로로 호출하는 구성이었습니다. Windows 단일 환경으로 전환한 뒤에는 이 저장소의 `game/` 프로젝트로 다시 확인해야 합니다.

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