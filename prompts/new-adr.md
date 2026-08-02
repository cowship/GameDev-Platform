# 새 ADR 작성 요청

**언제 사용**: 아키텍처/기술 관련 결정을 내려야 하고, Technical Lead의 검토를 거쳐 ADR로 기록까지 남기고 싶을 때 사용합니다.

---

## 1단계 — Technical Lead에게 검토 요청 (`/technical-lead`)

```
아래 결정에 대해 검토해줘.

- 배경: [왜 이 결정이 필요한가]
- 검토 대상 결정: [무엇을 결정하려고 하는가]
- 후보안: [고려 중인 옵션 1], [고려 중인 옵션 2]
- 제약 조건: [일정, 기술 스택, 팀 규모 등]
```

## 2단계 — Documentation Agent에게 ADR 기록 요청 (`/documentation`)

```
아래 내용을 templates/adr.md 형식에 맞춰 docs/decisions/에 새 ADR로 기록해줘.

- 번호: [다음 ADR 번호, 예: 0004]
- 제목: [ADR 제목]
- Context: [1단계에서 Technical Lead가 검토한 배경/문제 상황]
- Decision: [최종 채택한 결정]
- Alternatives: [기각된 대안과 이유]
- Consequences: [장단점, 후속 작업]
```

---

Technical Lead는 제안만 하고 문서를 직접 만들지 않습니다([ADR 0001](../docs/decisions/0001-agent-adapter-strategy.md)의 Role Separation). 반드시 2단계를 거쳐 Documentation Agent가 기록해야 `docs/decisions/`에 실제 ADR 파일이 생성됩니다.
