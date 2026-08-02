# Notion Workspace Structure

---

# 상태

실제 Notion Workspace에 아래 구조로 구축 완료했습니다 (2026-08-02, Notion MCP 통해 생성).

- Database로 구현: Projects, Tasks, Meeting Notes, Bug Reports, Features (`databases.md` 참고)
- ADR Database는 계획을 보완해 🏛 Architecture 하위로 이동 배치 (본 문서의 Architecture 섹션은 원래 페이지였으나, 실제로는 ADR Database를 담는 컨테이너 페이지로 구축됨)
- 나머지(Game Design Documents, Knowledge Base, Releases, Archive)는 일반 페이지로 생성, 아직 콘텐츠는 비어있음

🏠 Home이 Workspace의 Base Page입니다. 새 페이지 생성 규칙과 작성 채널(Documentation Agent 전용)은 [workflow.md](workflow.md)를 참고하세요.

---

# Purpose

모든 프로젝트는 동일한 Workspace 구조를 사용합니다.

표준화된 구조를 유지함으로써 프로젝트 간 이동 비용을 줄이고 AI Agent가 문맥을 쉽게 이해할 수 있도록 합니다.

---

# Workspace Structure

```text
🏠 Home

├── 🎮 Projects
├── 📋 Tasks
├── 📝 Meeting Notes
├── 📖 Game Design Documents
├── 🏛 Architecture
├── 📚 Knowledge Base
├── 🐞 Bug Reports
├── 🚀 Releases
└── 📦 Archive
```

---

# Description

## 🏠 Home

프로젝트 전체 현황을 확인하는 Dashboard입니다.

---

## 🎮 Projects

진행 중인 게임 프로젝트를 관리합니다.

---

## 📋 Tasks

프로젝트 작업(Task)을 관리합니다.

---

## 📝 Meeting Notes

회의록을 저장합니다.

향후 Claude + MCP를 통해 자동 생성됩니다.

---

## 📖 Game Design Documents

게임 기획서를 관리합니다.

예시

- Core Loop
- System Design
- Character Design
- Level Design

---

## 🏛 Architecture

기술 문서를 관리합니다.

예시

- ADR
- Architecture Diagram
- Coding Convention

---

## 📚 Knowledge Base

프로젝트에서 축적되는 모든 지식을 관리합니다.

---

## 🐞 Bug Reports

버그를 기록하고 추적합니다.

---

## 🚀 Releases

릴리즈 이력을 관리합니다.

---

## 📦 Archive

종료된 프로젝트와 오래된 문서를 보관합니다.

---

# Design Principles

Workspace는 다음 원칙을 따릅니다.

- Simple
- Consistent
- Reusable
- AI Friendly