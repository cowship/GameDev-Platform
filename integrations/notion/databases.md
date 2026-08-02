# Notion Database Design

---

# Purpose

프로젝트의 핵심 정보를 Database 형태로 관리합니다.

향후 MCP를 통해 Claude Code와 자동으로 연동됩니다.

---

# Databases

## Projects

게임 프로젝트를 관리합니다.

### Properties

| Property | Type |
|-----------|------|
| Name | Title |
| Status | Select |
| Genre | Select |
| Start Date | Date |
| Repository | URL |

---

## Tasks

작업을 관리합니다.

### Properties

| Property | Type |
|-----------|------|
| Title | Title |
| Status | Status |
| Priority | Select |
| Assignee | Person |
| Sprint | Select |
| GitHub Issue | URL |
| Due Date | Date |

---

## Meeting Notes

회의 내용을 관리합니다.

### Properties

| Property | Type |
|-----------|------|
| Title | Title |
| Date | Date |
| Participants | Multi-select |
| Summary | Text |
| Action Items | Relation |

---

## ADR (Architecture Decision Record)

기술 의사결정을 기록합니다.

### Properties

| Property | Type |
|-----------|------|
| Title | Title |
| Status | Select |
| Decision | Text |
| Reason | Text |
| Date | Date |

---

## Features

기능을 관리합니다.

### Properties

| Property | Type |
|-----------|------|
| Name | Title |
| Status | Status |
| Priority | Select |
| Related Task | Relation |

---

## Bug Reports

버그를 관리합니다.

### Properties

| Property | Type |
|-----------|------|
| Title | Title |
| Severity | Select |
| Status | Status |
| Assigned To | Person |
| GitHub Issue | URL |

---

# Future Databases

향후 다음 Database를 추가할 예정입니다.

- NPC
- Dialogue
- Quest
- Items
- Localization
- Assets
- Sound
- Analytics

---

# AI Integration

향후 Claude Code와 MCP를 통해 다음 작업을 자동화합니다.

- 회의록 생성
- Action Item 생성
- Task 생성
- ADR 생성
- Bug Report 생성
- Release Note 생성

---

# Design Principles

모든 Database는 다음 원칙을 따릅니다.

- 명확한 역할
- 최소한의 필수 속성
- AI 자동화 친화적 구조
- GitHub 및 Unity 연동 고려