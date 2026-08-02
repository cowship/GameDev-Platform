# GameDev-Platform AI Agents

## Overview

GameDev-Platform은 게임 개발 과정에서 AI Agent를 팀 구성원처럼 활용하기 위한 Agent Framework입니다.

각 Agent는 실제 개발 조직의 역할(Role)을 기준으로 설계되어 있으며, 담당 분야에 맞는 분석과 작업 지원을 제공합니다.

Agent는 단순한 코드 생성 도구가 아니라 프로젝트의 생산성, 품질, 협업 효율을 높이기 위한 AI 팀원입니다.

---

# Agent Structure


agents/

├── technical_lead.md
├── pm.md
├── documentation.md
├── unity.md
├── qa.md
└── game_designer.md


---

# Available Agents

## Technical Lead Agent

File:


technical_lead.md


### Role

프로젝트의 기술 방향과 아키텍처를 담당합니다.

### Responsibilities

- 기술 선택
- 시스템 구조 설계
- 개발 환경 설계
- 코드 구조 검토
- 리팩토링 방향 제안

### Use When

다음과 같은 상황에서 사용합니다.

- 새로운 기술 도입 검토
- 프로젝트 구조 결정
- 코드 설계 방향 고민
- 확장 가능한 구조 설계


---

## PM Agent

File:


pm.md


### Role

프로젝트 목표와 진행 과정을 관리합니다.

### Responsibilities

- 일정 관리
- Sprint 계획
- 우선순위 설정
- 회의 준비
- TODO 관리

### Use When

다음과 같은 상황에서 사용합니다.

- 개발 일정 작성
- 작업 우선순위 결정
- 프로젝트 진행 상황 정리
- 팀 목표 설정


---

## Documentation Agent

File:


documentation.md


### Role

프로젝트 지식을 기록하고 관리합니다.

### Responsibilities

- README 작성
- 기술 문서 작성
- ADR 작성
- 회의록 정리
- Notion 문서 관리

### Use When

다음과 같은 상황에서 사용합니다.

- 내용을 문서화해야 할 때
- 중요한 결정을 기록할 때
- 팀 공유 자료를 만들 때
- 프로젝트 지식을 정리할 때


---

## Unity Agent

File:


unity.md


### Role

Unity 기반 게임 개발을 담당합니다.

### Responsibilities

- C# 코드 작성
- Unity 구조 설계
- Gameplay 구현
- 게임 시스템 개발
- 성능 개선

### Use When

다음과 같은 상황에서 사용합니다.

- Unity 기능 구현
- 게임 시스템 개발
- 코드 작성
- Unity 프로젝트 구조 설계


---

## QA Agent

File:


qa.md


### Role

프로젝트 품질을 검증합니다.

### Responsibilities

- 테스트 계획
- 버그 분석
- 코드 검토
- 품질 관리
- 릴리즈 검증

### Use When

다음과 같은 상황에서 사용합니다.

- 기능 테스트가 필요할 때
- 버그 원인을 분석할 때
- 코드 리뷰가 필요할 때
- 배포 전 검증이 필요할 때


---

## Game Designer Agent

File:


game_designer.md


### Role

게임 경험과 시스템을 설계합니다.

### Responsibilities

- 게임 컨셉 설계
- Gameplay Loop 설계
- 게임 시스템 기획
- 밸런스 설계
- GDD 작성

### Use When

다음과 같은 상황에서 사용합니다.

- 새로운 게임 아이디어 구체화
- 게임 시스템 설계
- 플레이 경험 설계
- 기획 문서 작성


---

# Agent Selection Guide

| 상황 | 사용할 Agent |
|---|---|
| 기술 구조 결정 | Technical Lead Agent |
| 일정 및 우선순위 관리 | PM Agent |
| 게임 아이디어 및 시스템 기획 | Game Designer Agent |
| Unity 구현 | Unity Agent |
| 테스트 및 검증 | QA Agent |
| 문서 작성 및 정리 | Documentation Agent |

---

# Collaboration Flow

일반적인 게임 개발 흐름은 다음과 같습니다.


Game Designer Agent

↓

PM Agent

↓

Technical Lead Agent

↓

Unity Agent

↓

QA Agent

↓

Documentation Agent


각 Agent는 자신의 전문 영역을 담당하며 필요한 경우 다른 Agent와 협업합니다.

---

# Agent Usage Principles

## Role Separation

각 Agent는 자신의 역할에 집중합니다.

예:

- Unity Agent는 구현을 담당합니다.
- PM Agent는 일정과 목표를 관리합니다.
- Technical Lead Agent는 기술 의사결정을 담당합니다.
- Documentation Agent는 기록과 정리를 담당합니다.


---

## Documentation Required

중요한 프로젝트 결정 사항은 반드시 기록합니다.

예:

- 기술 선택
- 구조 변경
- 개발 방향 변경
- 주요 시스템 설계


---

## Human Decision

Agent는 분석과 제안을 수행합니다.

최종 결정과 책임은 항상 프로젝트 구성원이 담당합니다.


---

# Future Expansion

추후 필요에 따라 다음 Agent를 추가할 수 있습니다.

- Build Engineer Agent
- DevOps Agent
- Marketing Agent
- Localization Agent
- Community Agent