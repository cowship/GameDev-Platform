# Photon Fusion Workflow

> 멀티플레이 기능을 개발하고 검증할 때 따르는 절차입니다.

---

# Development Philosophy

멀티플레이 버그는 **혼자서는 재현되지 않습니다.** 따라서 "Editor에서 Play해보니 되더라"는 검증으로 인정하지 않고, 항상 **2개 이상의 클라이언트**로 확인한 뒤 PR을 올립니다.

---

# 코드 배치 규칙

| 대상 | 위치 |
|---|---|
| NetworkRunner 관리, 세션 접속/퇴장, 스폰 로직 | `game/Assets/Scripts/Networking/` |
| 네트워크와 무관한 순수 게임 로직 | `game/Assets/Scripts/Gameplay/` |
| NetworkObject가 붙은 Prefab | `game/Assets/Prefabs/Network/` |

네트워크 코드와 게임플레이 로직을 섞지 않습니다. 섞이면 "이 값이 로컬 값인지 동기화된 값인지" 판단이 어려워지고, 그 혼동이 멀티플레이 버그의 가장 흔한 원인입니다.

`game/Assets/Scripts/` 하위 폴더 간 의존성 방향은 [project_template.md](../unity/project_template.md#폴더-간-의존성-방향)를 따르며, `Networking`은 `Core`와 `Systems`에만 의존합니다.

---

# 개발 절차

1. **동기화할 상태를 먼저 정합니다.** 무엇을 네트워크로 보낼지 결정하지 않고 코드를 쓰기 시작하면 대부분 다시 씁니다.
2. **권한(Authority)을 명시합니다.** 이 값을 누가 바꿀 수 있는지(호스트만인지, 소유 클라이언트도 가능한지)를 코드 주석이나 PR 설명에 남깁니다.
3. 로컬에서 단일 클라이언트로 컴파일·기본 동작을 확인합니다.
4. 아래 "멀티플레이 테스트"로 2인 이상 환경에서 검증합니다.
5. PR을 올립니다.

---

# 멀티플레이 테스트

## 방법 1 — Multiplayer Play Mode (권장)

Unity 6의 Multiplayer Play Mode 기능으로 하나의 Editor에서 여러 플레이어를 동시에 실행합니다. 빌드가 필요 없어 반복 검증이 빠릅니다.

## 방법 2 — 빌드 2개 실행

`File > Build And Run`으로 만든 실행 파일을 2개 띄웁니다. Editor에서는 재현되지 않고 빌드에서만 나타나는 문제(코드 스트리핑, 플랫폼 차이)를 잡을 때 사용합니다.

## 확인 항목

- [ ] 두 클라이언트가 같은 방에 들어간다
- [ ] 한쪽의 행동이 다른 쪽에 반영된다
- [ ] 나중에 접속한 클라이언트가 **이미 진행 중인 상태**를 올바르게 받는다 (late join)
- [ ] 한쪽이 나가도 남은 쪽이 정상 동작한다
- [ ] 네트워크 지연 상황에서 눈에 띄는 어긋남이 없다

세 번째 항목(late join)이 특히 자주 누락됩니다. 처음부터 함께 접속한 상태만 테스트하면 놓치게 됩니다.

---

# 협업 시 주의 지점

## 네트워크 Prefab 목록 충돌

Fusion은 스폰 가능한 NetworkObject 목록을 프로젝트 설정 자산으로 관리합니다. 두 사람이 각자 네트워크 Prefab을 추가하면 **같은 파일을 동시에 수정**하게 되어 충돌이 납니다.

- 네트워크 Prefab 추가는 되도록 작은 PR로 빠르게 병합합니다.
- 충돌이 났다면 한쪽을 채택한 뒤 나머지 Prefab을 Unity에서 다시 등록하는 편이 안전합니다. 텍스트로 직접 병합하지 마세요.

## 동기화 프로퍼티 변경

`[Networked]` 프로퍼티를 추가·삭제·순서 변경하면 클라이언트 간 호환이 깨집니다. 관련 PR은 병합 후 팀 채널에 공지하고, 전원이 pull 받은 것을 확인한 뒤 다음 테스트를 진행합니다.

## App Id

팀 공용 1개를 사용합니다. 개인적으로 발급한 App Id로 바꿔 커밋하면 팀 전체가 서로 접속되지 않습니다. 자세한 내용은 [setup.md](setup.md#22-app-id-입력)를 참고합니다.

---

# Agent Collaboration

| 상황 | 참고 Agent |
|---|---|
| 네트워크 코드 작성 | [Unity Agent](../../agents/unity.md) |
| 동기화 구조 설계, 권한 모델 결정 | [Technical Lead Agent](../../agents/technical_lead.md) |
| 멀티플레이 테스트 계획, 버그 분석 | [QA Agent](../../agents/qa.md) |

---

# Related Documents

| Document | Description |
|---|---|
| [setup.md](setup.md) | SDK 설치 및 App Id 설정 |
| [docs/team/README.md](../../docs/team/README.md) | 팀 협업 규칙 |
| [integrations/unity/workflow.md](../unity/workflow.md) | Unity 버전 관리 및 충돌 대응 규칙 |
| [Fusion 2 Documentation](https://doc.photonengine.com/fusion/current/fusion-intro) | 공식 문서 |
