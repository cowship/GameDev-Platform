---
description: Documentation Agent에게 문서/ADR/회의록 작성을 요청합니다.
argument-hint: [요청 내용]
---

Agent 툴로 subagent_type: "documentation"을 호출하고, 아래 요청을 그대로 전달하세요.

요청: $ARGUMENTS

$ARGUMENTS가 비어 있으면 사용자에게 어떤 문서를 작성/정리해야 하는지 먼저 물어보세요.