# Templates

> GameDev-Platform에서 이미 반복적으로 쓰이고 있는 문서 형식을 재사용 가능한 템플릿으로 모아둔 디렉토리입니다.

---

# Overview

이 디렉토리는 새로운 형식을 정의하지 않습니다. 저장소 안에서 이미 검증되어 반복 사용 중인 문서 관례를 그대로 뽑아 템플릿화한 것입니다. 각 템플릿의 진짜 원본(Single Source of Truth)은 아래 표의 문서이며, 원본이 바뀌면 템플릿도 함께 갱신합니다.

---

# Directory Structure

```text
templates/

├── README.md          (본 문서, 인덱스)
├── adr.md              (ADR 작성 템플릿)
├── dev-log.md           (1인 개발일지 템플릿)
├── meeting-notes.md    (회의록 작성 템플릿)
└── sprint-report.md    (Sprint/PM 보고 템플릿)
```

---

# Related Documents (템플릿과 원본)

| Template | 원본 관례 |
|---|---|
| [adr.md](adr.md) | `docs/decisions/0001~0003-*.md`의 실제 ADR 구조 (agents/documentation.md의 "ADR Guidelines" 섹션과 대조해 실제 관례에 맞춤) |
| [dev-log.md](dev-log.md) | 기존 관례 없이 신설. PM Agent가 확정한 Stage 6(First Game Project) 트리거에 맞춰, 여러 명이 참석하는 `meeting-notes.md`와 구분되는 혼자 쓰는 개발일지 형식 |
| [meeting-notes.md](meeting-notes.md) | `agents/documentation.md`의 "Meeting Documentation" 섹션 + `agents/pm.md`의 "Meeting Management" 절차 + `integrations/notion/databases.md`의 Meeting Notes Database 속성 |
| [sprint-report.md](sprint-report.md) | `agents/pm.md`의 "Output Format" 섹션 |

---

# Usage

각 템플릿은 그대로 복사해 `{...}`, `[...]` 형태의 빈 칸을 채워 사용합니다. Slash Command로 Agent를 호출할 때 템플릿 구조를 그대로 요청에 포함하면 더 일관된 결과를 얻을 수 있습니다. 반복되는 요청 문구 자체를 템플릿화한 것은 [prompts/](../prompts/README.md)를 참고하세요.

---

# Update Policy

원본 관례(ADR 실제 파일, `agents/*.md`, `integrations/notion/databases.md`)가 바뀌면 이 디렉토리의 템플릿도 함께 갱신합니다. 반대로 템플릿을 먼저 바꾸고 원본을 나중에 맞추지 않습니다 — 원본이 항상 Single Source of Truth입니다.
