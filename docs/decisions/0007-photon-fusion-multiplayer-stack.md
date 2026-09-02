# ADR 0007: Unity 프로젝트 구성과 Photon Fusion 2 멀티플레이 스택

## Status

Accepted (2026-09-02)

## Context

[ADR 0006](0006-game-development-in-platform-repository.md)에 따라 이 저장소의 `game/`에서 실제 게임을 개발하기로 했다. 팀은 **Unity + Photon Fusion으로 멀티플레이 게임을 만든다**는 방향을 이미 정한 상태였고, 남은 것은 그 방향을 실제 프로젝트 구성으로 확정하는 일이었다.

제약 조건은 다음과 같았다.

- 팀원 5명이 각자 다른 PC를 쓰며, 전원이 동일한 Editor 버전과 패키지 구성을 사용해야 한다. 버전이 갈리면 `ProjectSettings`와 Asset이 자동 업그레이드되어 대량 변경이 팀 전체로 퍼진다.
- 개발 PC에 설치된 Unity Editor는 **6000.3.22f1** 하나다.
- [ADR 0004](0004-unity-starter-template.md)가 필수 패키지 5종(Addressables, Input System, TextMeshPro, Test Framework, URP)과 Assets 폴더 구조를 이미 표준으로 정해 두었다. 이번 프로젝트는 그 표준의 **첫 실제 적용 사례**다.
- Photon Fusion은 Unity Package Manager 레지스트리로 배포되지 않고 `.unitypackage`로 제공되며, 다운로드에 Photon 계정 로그인이 필요하다. 즉 스크립트로 자동 설치할 수 없다.

## Decision

1. **Editor 버전을 `6000.3.22f1`로 고정한다.** `game/ProjectSettings/ProjectVersion.txt`가 Single Source of Truth이며, 변경은 Technical Lead 검토를 거친다(`integrations/unity/setup.md`의 기존 원칙). Fusion 2가 지원하는 Unity 버전은 2021.3.45 / 2022.3.45 / 6.0.x / 6.3.x이고, 6000.3.22f1은 6.3.x에 해당해 지원 범위 안이다.

2. **2D + URP 템플릿(`com.unity.template.2d-cross-platform`)을 기준으로 프로젝트를 구성한다.** HDRP는 팀원 5명의 PC 사양이 제각각인 상황에서 부담이 크고, Render Pipeline은 나중에 바꾸기 어려운 선택이라 착수 시점에 확정했다.

3. **프로젝트를 Unity Hub GUI가 아니라 Editor에 내장된 템플릿 패키지를 추출해 생성한다.** Hub가 만드는 결과물과 동일한 `Assets`/`Packages`/`ProjectSettings`를 얻으면서, 생성 과정이 재현 가능하고 리뷰 가능한 형태로 남는다.

4. **패키지 구성은 템플릿 기준선에 아래 조정을 적용한다.**

   | 조정 | 내용 | 근거 |
   |---|---|---|
   | 추가 | `com.unity.addressables` 2.10.2 | ADR 0004의 필수 패키지 5종 충족. 2.10.2는 `unity: 6000.0` 요구로 6.3.x와 호환 |
   | 제거 | `com.unity.collab-proxy` | Unity Version Control(Plastic SCM)용. 이 팀은 Git을 쓰므로 두 개의 버전 관리 UI가 공존하면 혼선만 생긴다 |
   | 유지 | URP 17.0.3, Input System 1.12.0, Test Framework 1.4.5, ugui 2.0.0, 2D 패키지 일체 | 템플릿이 지정한 버전을 그대로 사용. 임의 최신화하지 않는다(`setup.md`의 버전 고정 원칙) |

   ADR 0004가 필수로 지정한 `com.unity.textmeshpro`는 별도 추가하지 않는다. Unity 6부터 TextMeshPro는 `com.unity.ugui` 2.0.0에 통합되어 있어, 별도 패키지를 넣으면 오히려 중복이 된다.

5. **Assets 폴더 구조는 ADR 0004의 표준을 따르되 `Scripts/Networking/`을 추가한다.** 멀티플레이 게임에서 네트워크 계층(NetworkRunner 관리, 세션 접속, 스폰)은 `Gameplay`와 성격이 뚜렷이 다르고, 이를 섞으면 "이 값이 로컬 값인지 동기화된 값인지" 판단이 어려워져 버그의 주된 원인이 된다. 의존성 방향은 `Networking → Core, Systems`로 두어 기존 규칙과 정합을 유지한다. 아울러 NetworkObject Prefab을 `Assets/Prefabs/Network/`에 모아 충돌 지점을 예측 가능하게 한다.

6. **Fusion SDK는 팀에서 최초 1명이 import한 뒤 `game/Assets/Photon/`을 저장소에 커밋한다.** 나머지 팀원은 pull로 받는다. 각자 다운로드하면 SDK 버전이 갈릴 위험이 있고, `.unitypackage`는 자동 설치가 불가능하기 때문이다. `.unitypackage` 파일 자체는 `.gitignore`로 제외한다.

7. **Photon App Id는 팀 공용 1개를 사용하고 `PhotonAppSettings.asset`을 커밋한다.** App Id는 클라이언트 빌드에 포함되는 식별자라 근본적으로 비밀 값이 아니며, 커밋하지 않으면 5명이 각자 입력해야 하고 누락 시 원인 파악이 어려운 접속 실패로 이어진다. **이 저장소가 Private임을 전제로 하며**, Public 전환 시 App Id 재발급과 커밋 제외를 재검토한다.

8. **Test Framework용 asmdef를 `Assets/Tests/EditMode/`와 `Assets/Tests/PlayMode/`에 생성한다.** ADR 0004가 "Tests에만 asmdef 필수"로 정한 결정을 그대로 적용한다. `Scripts/` 하위 카테고리의 asmdef 분리는 여전히 보류한다.

## Alternatives

- **(A) Unity Netcode for GameObjects (NGO)**: Unity 공식 솔루션이라 Package Manager로 설치되어 SDK 커밋이 불필요하고, 버전 관리가 단순하다. 그러나 팀이 이미 Photon Fusion으로 방향을 정한 상태였고, Fusion은 릴레이/매치메이킹 인프라를 자체 제공해 별도 서버 구축 없이 시작할 수 있다는 이점이 있다. 팀의 기존 결정을 존중해 기각한다.
- **(B) Photon PUN 2**: 학습 자료가 많고 진입 장벽이 낮지만 Photon이 신규 프로젝트에 Fusion을 권장하는 방향이라, 지금 시작하는 프로젝트에 채택하면 처음부터 유지보수 관점의 부채를 안게 된다. 기각.
- **(C) Fusion SDK를 커밋하지 않고 각자 import**: 저장소가 가벼워진다. 그러나 5명의 SDK 버전이 갈리는 순간 원인 파악이 매우 어려운 동기화 버그가 생긴다. 저장소 용량보다 버전 일치가 중요하다고 판단해 기각.
- **(D) 3D + URP 템플릿**: Fusion 공식 샘플 다수가 3D 기준이라 참고 자료를 그대로 쓰기 좋다. 게임 방향이 2D로 정해져 기각.
- **(E) Editor를 batch mode로 실행해 프로젝트 생성**: Hub와 가장 동일한 결과를 얻지만, 라이선스 상태와 실행 환경에 따라 결과가 달라질 수 있고 시간이 오래 걸린다. 템플릿 패키지 추출이 더 결정적(deterministic)이라 기각.

## Consequences

**장점**
- 팀원 5명이 clone → `game/` 열기만으로 동일한 프로젝트 환경을 얻는다.
- Editor 버전과 패키지 버전이 저장소에 고정되어, "내 PC에서만 되는" 문제의 주된 원인이 제거된다.
- ADR 0004의 Unity Starter Template 스펙이 실물 프로젝트로 처음 검증되었다. 스펙의 과부족(예: Networking 카테고리 누락)이 실제로 드러났고 본 ADR에서 보완했다.
- 네트워크 코드 배치 규칙을 착수 시점에 정해, 나중에 대규모 리팩토링으로 분리해야 하는 상황을 예방한다.

**단점**
- Fusion SDK import와 App Id 입력은 자동화할 수 없어 수동 절차로 남는다(`integrations/photon/setup.md`).
- Fusion SDK를 커밋하면 저장소 용량이 크게 늘고, SDK 업데이트 시 대량 변경 커밋이 발생한다.
- Addressables 2.10.2와 URP 17.0.3 조합은 이 프로젝트에서 아직 실사용 검증되지 않았다. 첫 빌드 시점에 문제가 드러날 수 있다.
- `Scripts/Networking/` 추가로 ADR 0004의 5개 카테고리 표준에서 벗어났다. 다음 프로젝트에서 이 카테고리를 표준에 정식 편입할지 판단이 필요하다.

**후속 작업**
- 게임 제목이 정해지면 `game/ProjectSettings/ProjectSettings.asset`의 `productName`(현재 임시값 `FusionGame`)과 `applicationIdentifier`를 갱신한다.
- Fusion SDK import 후 실제 접속 테스트를 거쳐 `integrations/photon/setup.md`의 절차를 실측 검증한다.
- 첫 빌드 이후 Addressables 사용 여부를 재평가한다. 실제로 쓰지 않는다면 제거를 검토하고 ADR 0004의 필수 패키지 목록을 함께 갱신한다.
- `Scripts/Networking/` 카테고리를 `integrations/unity/project_template.md`의 표준 구조에 반영할지 두 번째 프로젝트 시점에 결정한다.
