# 버그 분석 요청

**언제 사용**: 발견된 버그의 원인을 분석하고 수정 방향을 정리해야 할 때 사용합니다.

---

## `/qa` 에 붙여 쓰는 예시

```
아래 버그를 분석해줘.

- 발생 환경: [OS/Unity 버전/디바이스 등]
- 재현 단계: [1. ... 2. ... 3. ...]
- 예상 결과: [원래 어떻게 동작해야 하는가]
- 실제 결과: [실제로 어떻게 동작했는가]
- 체감 영향도: [Critical/Major/Minor 중 추정]

결과는 agents/qa.md의 Bug Report Format(Environment/Description/Steps To Reproduce/Expected Result/Actual Result/Severity/Possible Cause/Solution)에 맞춰 정리해줘.
```

---

QA Agent는 분석만 하고 기록은 직접 남기지 않습니다([ADR 0001](../docs/decisions/0001-agent-adapter-strategy.md)의 Role Separation). 분석 결과를 Notion Bug Reports Database에 남기고 싶다면 이어서 `/documentation`에 분석 결과를 붙여 기록을 요청하세요.
