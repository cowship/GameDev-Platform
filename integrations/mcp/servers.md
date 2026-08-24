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
| 실행 위치 | Unity CLI가 설치된 Windows 환경 (본 Repository의 Claude Code는 WSL에서 실행 중이라 WSL 경로(`/mnt/c/...`)로 바이너리를 직접 지정해서 등록) |
| CLI 바이너리 경로 | `%LOCALAPPDATA%\Unity\bin\unity.exe` → WSL에서는 `/mnt/c/Users/<사용자>/AppData/Local/Unity/bin/unity.exe` |
| 등록 명령 | `claude mcp add --scope user --transport stdio unity-editor-mcp -- "<unity.exe 경로>" mcp` (`scripts/setup_unity_workspace.sh`가 자동 탐색 + 등록) |
| 상태 | **연결 완료** — `claude mcp list`에서 Connected 확인함 (2026-08-25) |

> 폐기된 이전 방식: 기존에는 Unity 6000.0+ 내장 `com.unity.ai.assistant` 패키지의 in-Editor MCP Bridge + `relay_win.exe`를 사용했으나(서버 이름 `unity-mcp`), Unity가 in-Editor MCP server를 폐기하고 Unity CLI로 대체한다고 공식 발표(2026-08)함에 따라 프로젝트 시작 전인 이 시점에 미리 CLI 방식으로 전환했습니다. `unity-mcp`/relay 등록은 제거됨.
>
> Unity 공식 `unity mcp configure claude-code` 명령은 `claude mcp add --scope user --transport stdio unity-editor-mcp unity mcp`를 실행하려 시도하지만, 이는 Claude Code와 Unity CLI가 같은 OS에서 도는 걸 전제로 `unity`가 PATH에 있다고 가정합니다. WSL 환경에서는 `unity`가 PATH에 없으므로(Windows 바이너리) 위처럼 WSL에서 보이는 전체 경로로 직접 등록해야 합니다.

> **자동화**: 아래 1~5단계 중 WSL 쪽 준비(Git LFS, Windows Git Credential Manager 연동, Unity MCP 등록)는 `scripts/setup_unity_workspace.sh`로 자동화되어 있습니다 (여러 번 실행해도 안전).

**연결 범위 — 계정이 아니라 "그 순간 열려 있는 Unity 프로젝트" 기준입니다**

- CLI 바이너리와 Claude Code `mcpServers` 등록은 **Windows 사용자 계정/머신 단위**로 각자 설치해야 합니다 (relay와 마찬가지로 공유하지 않음).
- 실제로 어떤 게임 데이터를 조작하는지는 **그 순간 Unity Editor에서 열려 있는 프로젝트**로 결정됩니다. `unity status` 명령으로 현재 CLI가 인식하는 연결된 Editor 목록(포트/프로젝트 경로/버전/PID)을 확인할 수 있습니다.
- 따라서 팀원이 같은 프로토타입 콘텐츠를 Claude와 함께 다루려면, CLI를 각자 설치하는 것과 별개로 **프로토타입 Unity 프로젝트(레포)를 그대로 클론해서 열어야** 합니다. 다른/빈 프로젝트를 열면 Claude는 그 프로젝트를 보게 됩니다.

**새 팀원 온보딩 체크리스트** (사람이 직접 해야 하는 GUI 단계 포함 — 완전 자동화 불가):

1. 프로토타입 레포 클론
2. **[사람이 직접]** Unity Editor(6000.0+, 이번 전환의 최소 요구 버전)로 그 프로젝트를 최소 1회 실행
3. **[사람이 직접 또는 스크립트]** 해당 프로젝트에 Unity Pipeline 패키지 설치: `unity pipeline install --project-path <프로젝트 경로>` (기존 `com.unity.ai.assistant` 패키지 대신 이 패키지가 CLI와 Editor를 연결하는 역할을 함)
4. WSL 환경이면 GameDev-Platform 레포에서 `./scripts/setup_unity_workspace.sh` 실행 → Mirrored Networking 점검 + Unity CLI 자동 탐색/등록까지 처리 (Claude Code에게 이 스크립트 실행을 요청하면 됨)
5. Claude Code 세션 재시작 → `unity status`로 Editor가 목록에 뜨는지 확인

> 아직 실측 검증 안 된 부분: 위 3~5단계는 실제 Unity 프로젝트가 아직 없어(2026-08-25 기준 프로젝트 시작 전) 처음부터 끝까지 실제로 붙여보지는 못했습니다. 첫 Unity 프로젝트를 만들 때 Pipeline 패키지 설치 및 Editor 연결 과정에서 이전 방식에 있던 "Pending Connections 수동 Accept" 같은 추가 확인 단계가 남아있는지 다시 확인하고 이 섹션을 갱신해야 합니다.

**WSL ↔ Windows 네트워크 주의사항** (relay 시절에 확인된 내용 — Unity CLI 방식에서도 재현되는지는 미검증):

Unity Editor 내부 Bridge(구 방식) 및 Pipeline 패키지(신규 방식으로 추정)는 기본적으로 `127.0.0.1`(로컬호스트)에만 바인딩되어 외부 네트워크에서 접근할 수 없습니다. 이 Repository의 Claude Code는 WSL2(NAT 모드, `.wslconfig`에 `networkingMode=mirrored` 미설정) 안에서 실행 중이라, WSL의 `localhost`와 Windows의 `localhost`가 서로 다른 주소로 취급되어 **기본 설정으로는 연결되지 않을 가능성이 높습니다.** 다만 Unity CLI 바이너리 자체는 Windows 프로세스로 실행되므로(WSL은 프로세스만 실행시킬 뿐), CLI ↔ Editor 구간은 순수 Windows 내부 통신이라 이 문제가 아예 없을 수도 있습니다 — 첫 연결 시 실제로 막히는지 확인이 필요합니다. 확인된 Windows 빌드(10.0.26200)는 Mirrored Networking을 지원하므로, 문제가 재현되면 Unity 프로젝트 생성 후 다음 중 하나를 선택합니다.

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