# MCP Setup

---

# Quick Start (자동화 스크립트)

비밀정보 없이 등록 가능한 서버(Filesystem, Sequential Thinking, Context7)와 GitHub(Token 입력 안내 포함)는 아래 스크립트로 한 번에 등록할 수 있습니다. 이미 등록된 서버는 자동으로 건너뛰므로 여러 번 실행해도 안전합니다.

```bash
./scripts/setup_mcp.sh
```

Notion(계정 연동)과 Unity MCP(Unity 프로젝트 필요)는 성격상 자동화할 수 없어 스크립트가 안내 문구만 출력합니다. 아래는 각 서버를 수동으로 등록할 때 참고하는 절차입니다.

---

# Requirements

MCP 사용 전 다음 환경이 준비되어 있어야 합니다.

- Claude Code 설치 완료
- Node.js
- 연동 대상 서비스의 API Key / Token (예: Notion Integration Token)

---

# MCP Server 등록

Claude Code CLI를 통해 MCP Server를 등록합니다.

```bash
claude mcp add {server-name} {command}
```

예시 (Notion MCP Server 등록)

```bash
claude mcp add notion npx -- -y @notionhq/notion-mcp-server
```

---

# 인증 정보 관리

API Key, Token 등 민감 정보는 다음 원칙을 따릅니다.

- Repository에 직접 커밋하지 않습니다.
- `.env` 파일 또는 OS 환경변수를 사용합니다.
- `.env`는 `.gitignore`에 의해 Git 추적에서 제외됩니다.

---

# 등록된 Server 확인

```bash
claude mcp list
```

---

# Server 제거

```bash
claude mcp remove {server-name}
```

---

# Verify

MCP Server 등록 후 Claude Code 세션에서 정상적으로 Tool이 노출되는지 확인합니다.

```bash
claude
```

세션 내에서 해당 MCP Server의 기능(예: Notion 조회)이 동작하면 설정이 완료된 것입니다.

---

# Troubleshooting

## Server가 목록에 나타나지 않음

→ 등록 명령이 정상적으로 실행되었는지, Node.js 버전이 요구사항을 만족하는지 확인합니다.

---

## 인증 오류

```text
401 Unauthorized
```

→ API Key/Token이 만료되었거나 잘못 입력되었을 가능성이 높습니다. 환경변수를 재확인합니다.

---

# References

- Model Context Protocol 공식 문서
- Claude Code MCP 문서