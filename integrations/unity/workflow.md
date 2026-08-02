# Unity Workflow

---

# Development Philosophy

모든 Unity 게임 프로젝트는 동일한 구조와 절차에서 시작합니다.

표준화된 구조를 유지함으로써 프로젝트 간 이동 비용을 줄이고, Unity Agent와 사람 모두 프로젝트 문맥을 빠르게 이해할 수 있도록 합니다.

---

# Project Creation Workflow

새로운 게임 프로젝트 시작 시 다음 순서를 따릅니다.

1. GameDev-Platform 기준으로 신규 Repository 생성
2. Unity Hub에서 지정된 LTS 버전으로 프로젝트 생성
3. Git LFS 설정 (첫 Commit 이전)
4. 표준 프로젝트 구조 적용
5. `CLAUDE.md` 및 `agents/` 복사 또는 참조 연결
6. 초기 Commit

---

# Standard Project Structure

표준 `Assets/` 폴더 구조와 패키지 의존성은 [`project_template.md`](project_template.md)의 "Assets Structure" 섹션이 Source of Truth입니다. 본 문서는 프로젝트 생성 절차 개요만 다루므로, 구조 자체가 필요하면 해당 문서를 참고합니다.

> 세부 코딩 규칙(네이밍, Architecture 선호/지양 패턴)은 [`agents/unity.md`](../../agents/unity.md)를 따릅니다.

---

# Version Control 규칙

## Git LFS 대상

이미지, 모델, 오디오, 비디오 등 바이너리 Asset은 Git LFS로 관리합니다.

## Scene / Prefab 충돌 주의

Scene, Prefab 파일은 동시 편집 시 Merge Conflict 위험이 높습니다.

- 가능한 한 기능 단위로 작업을 분리합니다.
- 동일 Scene을 동시에 여러 명이 수정하지 않습니다.

## Meta 파일

`.meta` 파일은 항상 함께 Commit합니다. 삭제하거나 무시하지 않습니다.

---

# Build Workflow

1. Target Platform 확인
2. Build Settings 검토
3. Build 실행
4. QA Agent 검증
5. 문제 발견 시 Fix → 재검증

---

# Agent Collaboration

| 상황 | 참고 Agent |
|---|---|
| 코드 작성/구조 설계 | [Unity Agent](../../agents/unity.md) |
| Architecture 결정 | Technical Lead Agent |
| 빌드/기능 검증 | QA Agent |
| 게임 시스템 기획 | Game Designer Agent |

---

# Long-term Vision

향후 Unity Integration은 다음을 목표로 합니다.

- 표준 프로젝트 템플릿(Starter Kit) 제공
- CI 기반 자동 Build
- Unity MCP를 통한 Editor 상태 실시간 연동

이를 통해 새로운 게임 프로젝트를 최소한의 설정으로 즉시 시작할 수 있는 환경을 구축합니다.