# Netcode Integration

> 이 프로젝트의 멀티플레이 네트워킹 계층인 Unity Netcode for GameObjects(NGO) 연동 표준입니다.

---

# Overview

이 게임은 **Unity Netcode for GameObjects(NGO)** 를 멀티플레이 네트워킹 솔루션으로 사용합니다. 채택 근거는 [ADR 0009](../../docs/decisions/0009-netcode-for-gameobjects.md)를 참고하세요.

NGO는 Unity 공식 패키지라 **Package Manager로 설치됩니다.** `game/Packages/manifest.json`에 이미 포함되어 있으므로, 팀원은 저장소를 pull하고 프로젝트를 열기만 하면 자동으로 받아집니다. 별도의 SDK import나 계정 발급 절차가 없습니다.

| 항목 | 값 |
|---|---|
| 패키지 | `com.unity.netcode.gameobjects` 2.13.1 |
| 의존 패키지 | `com.unity.transport` 2.6.0+ (자동 해결) |
| 테스트 도구 | `com.unity.multiplayer.playmode` 2.0.2 |
| 최소 Unity | 6000.0 (이 프로젝트는 6000.3.22f1) |

---

# Responsibilities

Netcode Integration은 다음을 담당합니다.

- NGO 패키지 버전 관리
- NetworkManager / 네트워크 Prefab 배치 규칙
- 멀티플레이 동작 검증 방법
- 인터넷 연결(Relay) 도입 시점 판단

---

# Directory Structure

```text
netcode/

├── README.md
├── setup.md      (프로젝트 최초 설정, NetworkManager 구성)
└── workflow.md   (개발·테스트·협업 규칙)
```

---

# Related Documents

| Document | Description |
|---|---|
| [setup.md](setup.md) | NetworkManager 배치, 네트워크 Prefab 등록, 최초 설정 |
| [workflow.md](workflow.md) | 네트워크 코드 작성 및 멀티플레이 테스트 절차 |
| [docs/team/README.md](../../docs/team/README.md) | NGO 관련 협업 규칙 (Prefab 목록 충돌 등) |
| [docs/decisions/0009-netcode-for-gameobjects.md](../../docs/decisions/0009-netcode-for-gameobjects.md) | NGO 채택 결정 근거 (ADR) |

---

# References

- [Netcode for GameObjects Documentation](https://docs-multiplayer.unity3d.com/netcode/current/about/)
- [Unity Multiplayer Play Mode](https://docs-multiplayer.unity3d.com/mppm/current/about/)
