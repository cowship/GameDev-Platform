# Unity Workflow

---

# Development Philosophy

모든 Unity 게임 프로젝트는 동일한 구조와 절차에서 시작합니다.

표준화된 구조를 유지함으로써 프로젝트 간 이동 비용을 줄이고, Unity Agent와 사람 모두 프로젝트 문맥을 빠르게 이해할 수 있도록 합니다.

---

# 현재 프로젝트 위치

이 저장소의 Unity 프로젝트는 **`game/`** 폴더에 있습니다. Unity Hub에서는 저장소 루트가 아니라 이 폴더를 열어야 합니다.

| 항목 | 값 |
|---|---|
| 프로젝트 경로 | `game/` |
| Editor 버전 | `6000.3.22f1` (`game/ProjectSettings/ProjectVersion.txt`가 Source of Truth) |
| Render Pipeline | URP (2D) |
| 네트워킹 | Unity Netcode for GameObjects → [integrations/netcode/](../netcode/README.md) |

---

# Project Creation Workflow

새로운 게임 프로젝트를 **처음부터** 시작할 때의 순서입니다 (이 저장소의 `game/`은 이미 이 절차를 마친 상태입니다).

1. Repository 준비
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

Unity 프로젝트는 일반적인 코드 저장소보다 충돌에 취약합니다. 아래 4개 장치가 이 저장소에 이미 적용되어 있습니다.

| 장치 | 구현 위치 | 막아주는 사고 |
|---|---|---|
| Git LFS | 루트 [.gitattributes](../../.gitattributes) | 바이너리 자산 누적으로 인한 저장소 비대화 |
| LFS File Locking (`lockable`) | 루트 [.gitattributes](../../.gitattributes) | 병합 불가능한 바이너리의 동시 편집 |
| UnityYAMLMerge (Smart Merge) | [scripts/setup_team_member.sh](../../scripts/setup_team_member.sh) | Scene/Prefab 병합 시 파일 손상 |
| Force Text 직렬화 | `game/ProjectSettings/EditorSettings.asset` | 바이너리 직렬화로 인한 병합 불가 |

## Git LFS 대상

이미지, 모델, 오디오, 비디오, 폰트 등 바이너리 Asset은 Git LFS로 관리합니다. 대상 확장자는 루트 `.gitattributes`가 Source of Truth입니다. 목록에 없는 새 바이너리 확장자를 쓰게 되면 `.gitattributes`에 추가하는 PR을 올립니다.

> ⚠️ clone 직후 반드시 `git lfs install --local`을 실행해야 합니다. 하지 않으면 이미지가 텍스트 포인터 파일로 받아집니다. [scripts/setup_team_member.sh](../../scripts/setup_team_member.sh)가 자동으로 처리합니다.

## Git LFS File Locking

병합이 원천적으로 불가능한 바이너리는 편집 전에 잠급니다.

```bash
git lfs lock game/Assets/Art/Sprites/player.png
git lfs locks
git lfs unlock game/Assets/Art/Sprites/player.png
```

잠긴 파일은 다른 팀원이 push할 수 없어, "먼저 커밋한 사람의 작업이 조용히 덮이는" 사고를 구조적으로 막습니다.

## Scene / Prefab 충돌 주의

Scene, Prefab 파일은 동시 편집 시 Merge Conflict 위험이 높습니다.

- **Prefab 우선**: Scene에 직접 배치하는 대신 Prefab으로 만들고 Scene에는 Prefab만 올립니다. 각자 다른 파일을 만지게 되어 충돌 자체가 발생하지 않습니다.
- **Additive Scene 분리**: UI/레벨을 별도 Scene으로 나눕니다.
- 동일 Scene을 동시에 여러 명이 수정하지 않습니다. 불가피하면 작업 전에 팀에 공지합니다.
- 충돌이 발생하면 UnityYAMLMerge가 자동 호출됩니다. 자동 해결에 실패했을 때 **YAML을 손으로 편집하지 마세요.** 한쪽 버전을 통째로 채택(`git checkout --ours` / `--theirs`)한 뒤 작업을 다시 얹는 편이 안전합니다.

## Meta 파일

`.meta` 파일은 항상 함께 Commit합니다. 삭제하거나 무시하지 않습니다. `.meta`에는 Asset GUID가 들어 있어, 누락되면 다른 팀원의 프로젝트에서 참조가 전부 끊어집니다.

## 공용 설정 파일

`game/ProjectSettings/**`, `game/Packages/manifest.json`은 변경 시 팀 전원에게 영향을 줍니다. 단독 변경 대신 PR + 공지로 처리합니다.

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
| 멀티플레이 동기화 설계 | Technical Lead Agent + [integrations/netcode/workflow.md](../netcode/workflow.md) |

---

# Long-term Vision

향후 Unity Integration은 다음을 목표로 합니다.

- 표준 프로젝트 템플릿(Starter Kit) 제공
- CI 기반 자동 Build
- Unity MCP를 통한 Editor 상태 실시간 연동

이를 통해 새로운 게임 프로젝트를 최소한의 설정으로 즉시 시작할 수 있는 환경을 구축합니다.