# Netcode Setup

> NGO를 이 프로젝트에서 처음 쓸 수 있게 만드는 절차입니다.

---

# 설치는 이미 끝나 있습니다

NGO는 Unity 공식 패키지라 `game/Packages/manifest.json`에 버전이 고정되어 있습니다.

```json
"com.unity.netcode.gameobjects": "2.13.1",
"com.unity.multiplayer.playmode": "2.0.2"
```

저장소를 pull하고 `game/`을 Unity로 열면 Package Manager가 자동으로 받아옵니다. **팀원이 따로 할 일은 없습니다.**

> Photon Fusion을 쓸 때 필요했던 "한 명이 `.unitypackage`를 import해서 커밋" 절차와 "팀 공용 App Id 발급·공유" 절차는 **NGO에서는 존재하지 않습니다.** 배경은 [ADR 0009](../../docs/decisions/0009-netcode-for-gameobjects.md)를 참고하세요.

## 설치 확인

Unity에서 `Window > Package Manager`를 열고 **In Project** 목록에 `Netcode for GameObjects`가 보이면 정상입니다. 메뉴에 `Window > Multiplayer > Multiplayer Play Mode`도 함께 나타납니다.

---

# 1. NetworkManager 배치 (최초 1회)

NGO는 씬에 있는 **NetworkManager** 컴포넌트 하나가 세션 전체를 관장합니다. 아직 프로젝트에 없으므로 최초 1명이 만들어 커밋합니다.

1. 빈 GameObject를 만들고 이름을 `NetworkManager`로 정합니다.
2. `NetworkManager` 컴포넌트를 추가합니다.
3. `Unity Transport` 컴포넌트를 추가합니다 (NetworkManager의 Network Transport 칸에 자동 연결됩니다).
4. 이 GameObject를 **Prefab으로 만들어** `game/Assets/Prefabs/Network/`에 둡니다.

> **왜 Prefab으로 만드나**: NetworkManager를 씬에 직접 두면 그 씬이 팀의 충돌 지점이 됩니다. Prefab으로 빼두면 설정 변경이 Prefab 파일 하나에만 생겨, 씬을 만지는 사람과 네트워크 설정을 만지는 사람이 서로를 막지 않습니다. ([docs/team/README.md](../../docs/team/README.md)의 "Prefab 우선" 원칙과 같은 이유)

---

# 2. 네트워크 Prefab 등록

플레이어처럼 네트워크로 생성(spawn)되는 오브젝트는 **NetworkObject 컴포넌트**를 붙이고, NGO의 네트워크 Prefab 목록에 등록해야 합니다.

1. Prefab에 `NetworkObject` 컴포넌트를 추가합니다.
2. Prefab을 `game/Assets/Prefabs/Network/` 아래에 둡니다.
3. NetworkManager의 **Network Prefabs List**(`NetworkPrefabsList` 자산)에 추가합니다.

> ⚠️ 이 목록 자산이 **팀에서 가장 충돌이 잦은 파일**입니다. 두 사람이 각자 네트워크 Prefab을 추가하면 같은 파일의 같은 위치를 수정하게 됩니다. 대응 방법은 [workflow.md](workflow.md#네트워크-prefab-목록-충돌)를 참고하세요.

---

# 3. 접속 방식

현재 구성은 **UnityTransport 기본값(직접 IP 접속)** 입니다.

| 상황 | 동작 여부 | 비고 |
|---|---|---|
| 같은 PC에서 여러 인스턴스 (localhost) | ✅ | Multiplayer Play Mode로 테스트 |
| 같은 공유기/LAN 안의 다른 PC | ✅ | 호스트의 로컬 IP를 입력해 접속 |
| 서로 다른 네트워크(인터넷) | ❌ | 공유기 NAT 때문에 직접 접속이 막힘 |

인터넷 너머로 붙으려면 중계 서버가 필요하고, Unity는 이를 **Relay**(`com.unity.services.multiplayer` 패키지 + Unity Gaming Services 프로젝트 연결)로 제공합니다.

**지금은 도입하지 않습니다.** 개발과 테스트는 localhost와 LAN으로 충분하고, Relay는 UGS 프로젝트 연결·인증 흐름·사용량 관리가 함께 따라와 초기 복잡도를 크게 올립니다. 팀원이 각자 집에서 붙어 테스트해야 하는 시점이 오면 그때 별도 ADR로 도입을 결정합니다.

---

# 4. 확인

- [ ] `Window > Package Manager`의 In Project에 `Netcode for GameObjects`가 있다
- [ ] `Window > Multiplayer > Multiplayer Play Mode` 메뉴가 있다
- [ ] Console에 NGO 관련 에러가 없다

---

# Troubleshooting

## `NetworkManager` 컴포넌트를 찾을 수 없습니다

패키지가 아직 해석되지 않은 상태입니다. `game/Packages/manifest.json`에 `com.unity.netcode.gameobjects`가 있는지 확인하고, Unity를 닫은 뒤 `game/Library/PackageCache`를 지우고 다시 엽니다.

## 스폰한 오브젝트가 상대에게 보이지 않습니다

대부분 네트워크 Prefab 목록 등록 누락입니다. 해당 Prefab이 NetworkManager의 Network Prefabs List에 들어 있는지, 그리고 그 변경이 **커밋되어 상대도 받았는지** 확인하세요.

## 같은 LAN인데 접속이 안 됩니다

호스트 PC의 Windows 방화벽이 Unity/빌드의 인바운드를 막고 있을 수 있습니다. 처음 실행할 때 뜨는 방화벽 허용 창에서 **개인 네트워크**를 체크했는지 확인하세요.

---

# Related Documents

| Document | Description |
|---|---|
| [README.md](README.md) | Netcode Integration 개요 |
| [workflow.md](workflow.md) | 네트워크 개발·테스트 절차 |
| [docs/team/ONBOARDING.md](../../docs/team/ONBOARDING.md) | 팀원 최초 환경 구축 절차 |
