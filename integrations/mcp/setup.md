# MCP Setup

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