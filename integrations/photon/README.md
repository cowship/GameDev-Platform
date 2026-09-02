# Photon Integration

> 이 프로젝트의 멀티플레이 네트워킹 계층인 Photon Fusion 2 연동 표준입니다.

---

# Overview

이 게임은 **Photon Fusion 2**를 멀티플레이 네트워킹 솔루션으로 사용합니다. 채택 근거는 [ADR 0007](../../docs/decisions/0007-photon-fusion-multiplayer-stack.md)을 참고하세요.

Fusion은 Unity Package Manager로 설치할 수 없고 `.unitypackage`로 배포되므로, **팀에서 최초 1명이 import한 뒤 저장소에 커밋**하고 나머지는 pull로 받는 방식을 사용합니다. 이렇게 해야 5명이 동일한 SDK 버전을 쓰는 것이 보장됩니다.

---

# Responsibilities

Photon Integration은 다음을 담당합니다.

- Fusion SDK 버전 관리
- App Id 관리 (팀 공용 1개)
- 네트워크 Prefab 배치 규칙
- 멀티플레이 동작 검증 방법

---

# Directory Structure

```text
photon/

├── README.md
├── setup.md      (SDK 설치, App Id 발급/입력)
└── workflow.md   (개발·테스트·협업 규칙)
```

---

# Related Documents

| Document | Description |
|---|---|
| [setup.md](setup.md) | Photon 계정, App Id 발급, Fusion SDK import |
| [workflow.md](workflow.md) | 네트워크 코드 작성 및 멀티플레이 테스트 절차 |
| [docs/team/README.md](../../docs/team/README.md) | Fusion 관련 협업 규칙 (Prefab 충돌 등) |
| [docs/decisions/0007-photon-fusion-multiplayer-stack.md](../../docs/decisions/0007-photon-fusion-multiplayer-stack.md) | Fusion 채택 결정 근거 (ADR) |

---

# References

- [Fusion 2 SDK & Download](https://doc.photonengine.com/fusion/current/getting-started/sdk-download)
- [Fusion 2 Documentation](https://doc.photonengine.com/fusion/current/fusion-intro)
- [Photon Dashboard](https://dashboard.photonengine.com/)
