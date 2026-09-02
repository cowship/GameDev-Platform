# ADR 0009: 멀티플레이 스택을 Photon Fusion에서 Netcode for GameObjects로 변경

## Status

Accepted (2026-09-02) — [ADR 0007](0007-photon-fusion-multiplayer-stack.md)의 네트워킹 솔루션 결정(Decision 6, 7)을 대체한다. ADR 0007의 나머지 결정(Editor 버전 고정, 2D+URP 템플릿, 패키지 버전 기준, Assets 구조)은 그대로 유효하다.

## Context

[ADR 0007](0007-photon-fusion-multiplayer-stack.md)에서 Photon Fusion 2를 채택했다. 당시 판단 근거는 "팀이 이미 Fusion으로 방향을 정한 상태"였고, ADR 0007의 Alternatives에서 Unity Netcode for GameObjects(NGO)를 검토했으나 **팀의 기존 결정을 존중해 기각**했다.

부트스트랩을 진행하던 중 팀이 방향을 NGO로 바꾸기로 했다. 시점상 다행인 점이 있다.

- Unity 최초 실행 커밋(Phase 0-2)은 `main`에 병합됐지만, **Fusion SDK import(Phase 0-4)는 아직 수행하지 않았다.** 즉 저장소에 Fusion 관련 코드나 자산이 하나도 들어가 있지 않다.
- Photon App Id도 아직 발급·공유하지 않았다.
- 따라서 되돌릴 것이 문서와 `manifest.json`뿐이며, 게임 코드 마이그레이션 비용은 0이다.

ADR 0007을 쓰던 시점에 이미 기록해 둔 NGO의 장점이 이번 결정으로 그대로 실현된다.

> "(A) Unity Netcode for GameObjects (NGO): Unity 공식 솔루션이라 Package Manager로 설치되어 SDK 커밋이 불필요하고, 버전 관리가 단순하다."

## Decision

1. **멀티플레이 네트워킹을 `com.unity.netcode.gameobjects` 2.13.1로 한다.** Editor 6000.3.22f1의 권장 목록에 있는 버전이며, `unity: 6000.0` 요구를 만족한다. 의존 패키지 `com.unity.transport`(2.6.0+)와 `com.unity.nuget.mono-cecil`은 Package Manager가 자동 해결한다.

2. **`com.unity.multiplayer.playmode` 2.0.2를 함께 넣는다.** 빌드 없이 한 Editor에서 여러 플레이어를 띄울 수 있어, 5명이 각자 멀티플레이 동작을 확인하는 비용을 크게 낮춘다. 네트워크 코드는 혼자 검증하기 어렵다는 점이 이 프로젝트의 구조적 위험이므로, 테스트 도구를 표준에 포함한다.

3. **부트스트랩 절차에서 "SDK import"와 "App Id 발급·공유" 단계를 삭제한다.** NGO는 Package Manager로 설치되므로 `manifest.json` 한 줄이면 팀 전원이 동일 버전을 받는다. 그 결과 온보딩의 Phase 0-4/0-5가 통째로 사라지고, 부트스트랩 담당자가 해야 할 일은 Unity 최초 실행 커밋 하나로 줄어든다.

4. **Relay(인터넷 접속)는 지금 도입하지 않는다.** 현재 구성은 UnityTransport 기본값이라 localhost와 LAN에서만 접속된다. 서로 다른 네트워크에서 붙으려면 `com.unity.services.multiplayer` 패키지와 Unity Gaming Services 프로젝트 연결이 필요한데, 인증 흐름과 사용량 관리가 함께 따라와 초기 복잡도를 크게 올린다. 개발·테스트는 localhost와 LAN으로 충분하므로, 팀원이 각자 집에서 붙어야 하는 시점에 별도 ADR로 결정한다.

5. **`integrations/photon/`을 `integrations/netcode/`로 교체한다.** 문서 3종(README / setup / workflow)의 역할 구분은 그대로 유지한다.

6. **네트워크 Prefab 목록(`NetworkPrefabsList` 자산)을 팀의 주요 충돌 지점으로 명시한다.** Fusion의 `NetworkProjectConfig`가 차지하던 자리를 NGO에서는 이 자산이 대신한다. 대응 원칙(작은 PR로 빠르게 병합, 충돌 시 텍스트 병합 금지·재등록)은 동일하게 적용한다.

7. **NetworkManager를 씬이 아니라 Prefab으로 관리한다.** 씬에 직접 두면 그 씬이 팀의 병목이 된다. Prefab으로 빼면 네트워크 설정 변경이 Prefab 파일에만 생겨, 씬 작업자와 네트워크 작업자가 서로를 막지 않는다. `docs/team/README.md`의 "Prefab 우선" 원칙과 같은 논리다.

## Alternatives

- **(A) Photon Fusion 2 유지**: 릴레이·매치메이킹 인프라를 Photon이 제공해 인터넷 멀티플레이를 별도 서버 구축 없이 바로 시작할 수 있다. 그러나 SDK가 `.unitypackage`로만 배포되어 자동 설치가 불가능하고, "한 명이 import해서 커밋" 절차와 App Id 공유가 온보딩에 계속 남는다. 팀이 방향을 바꾸기로 한 이상, 아직 저장소에 SDK가 들어가지 않은 지금이 전환 비용이 가장 낮은 시점이다.
- **(B) NGO + Relay를 처음부터 함께 도입**: 인터넷 멀티플레이까지 한 번에 갖춘다. 그러나 UGS 프로젝트 연결, 익명 인증, 할당량 관리가 학습 항목으로 추가되어 첫 네트워크 코드를 작성하기까지의 거리가 멀어진다. 지금 필요한 것은 "동기화가 되는가"를 빨리 확인하는 것이므로 보류.
- **(C) Netcode for Entities (`com.unity.netcode`)**: 대규모·고성능 시뮬레이션에 유리하다. 그러나 DOTS/ECS 학습이 전제되어 2D 소규모 프로젝트에는 과하다. 기각.
- **(D) 직접 소켓 구현**: 학습 목적이라면 의미가 있으나, 게임을 만드는 것이 목표인 이 프로젝트에서는 몇 달을 네트워크 계층에 쓰게 된다. 기각.

## Consequences

**장점**
- 온보딩이 눈에 띄게 짧아졌다. 부트스트랩 담당자의 작업이 2건에서 1건으로 줄고, 나머지 4명은 pull 한 번으로 네트워크 라이브러리까지 받는다.
- SDK가 저장소에 들어가지 않아 clone 용량과 커밋 diff가 가벼워진다. Fusion SDK를 커밋했다면 수천 개 파일이 한 커밋에 들어갔을 것이다.
- 버전 관리가 `manifest.json` 한 줄로 일원화된다. "누가 언제 받은 SDK인가"로 인한 버전 불일치가 구조적으로 불가능해진다.
- 외부 계정(Photon)과 공유 비밀(App Id)에 대한 의존이 사라졌다.
- Unity 공식 패키지라 Editor 버전과의 호환이 Editor 권장 목록으로 보증된다([ADR 0007](0007-photon-fusion-multiplayer-stack.md)에서 겪은 패키지 버전 불일치 문제의 재발 위험이 낮다).

**단점**
- **인터넷 멀티플레이가 당장은 불가능하다.** Photon은 릴레이를 기본 제공했지만 NGO는 LAN/localhost까지만 된다. 팀원이 각자 집에서 테스트해야 하는 시점에 Relay 도입 작업이 별도로 필요하다.
- Fusion에 비해 상태 동기화·예측·보간을 직접 다뤄야 하는 부분이 많다. 학습 곡선이 코드 쪽으로 옮겨왔다.
- ADR 0007과 이 문서가 부분적으로 겹쳐, 나중에 읽는 사람이 두 문서를 함께 봐야 전체 맥락을 안다.

**후속 작업**
- NetworkManager Prefab을 만들어 `game/Assets/Prefabs/Network/`에 커밋한다([setup.md](../../integrations/netcode/setup.md)).
- 팀원이 서로 다른 네트워크에서 테스트해야 하는 시점에 Relay 도입을 별도 ADR로 검토한다.
- 첫 네트워크 기능 구현 후, `Scripts/Networking/`과 `Scripts/Gameplay/`의 경계가 실제로 지켜지는지 코드 리뷰에서 확인한다.
