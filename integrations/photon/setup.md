# Photon Fusion Setup

> Fusion 2 SDK를 이 프로젝트에 설치하고 App Id를 연결하는 절차입니다.

---

# 전제 조건

| 항목 | 값 / 조건 |
|---|---|
| Unity Editor | 6000.3.22f1 (Fusion 2가 지원하는 6.3.x 계열) |
| Asset Serialization | **Force Text** — Fusion의 필수 요구사항이며, 이 저장소는 이미 그렇게 설정되어 있습니다 (`game/ProjectSettings/EditorSettings.asset`의 `m_SerializationMode: 2`) |
| Photon 계정 | 무료 가입 — [dashboard.photonengine.com](https://dashboard.photonengine.com/) |

> Fusion 2가 지원하는 Unity 버전은 2021.3.45 / 2022.3.45 / 6.0.x / 6.3.x입니다. 이 프로젝트가 고정한 6000.3.22f1은 6.3.x에 해당합니다.

---

# 이미 설치되어 있는지 먼저 확인합니다

```bash
ls game/Assets/Photon
```

폴더가 존재하면 **이미 팀의 누군가가 import해서 커밋한 상태**입니다. 아래 "2. App Id 입력"만 수행하면 됩니다. 중복 import하지 마세요.

---

# 1. Fusion SDK import (최초 1명만 수행)

1. [Fusion 2 SDK & Download](https://doc.photonengine.com/fusion/current/getting-started/sdk-download) 페이지에서 Photon 계정으로 로그인합니다.
2. Fusion 2 SDK(`.unitypackage`)를 내려받습니다.
3. Unity에서 `game/` 프로젝트를 연 뒤 `Assets > Import Package > Custom Package...`로 내려받은 파일을 선택하고 전부 import합니다.
4. import가 끝나면 **Fusion Hub** 창이 자동으로 열립니다.
5. import 결과(`game/Assets/Photon/`)를 **커밋**합니다.

```bash
git switch -c chore/import-fusion-sdk
git add game/Assets/Photon
git commit -m "chore: Photon Fusion 2 SDK import"
git push -u origin chore/import-fusion-sdk
```

> **`.unitypackage` 파일 자체는 커밋하지 않습니다** (`.gitignore`가 제외합니다). 저장소에 들어가는 것은 import된 결과물입니다.

---

# 2. App Id 발급 및 입력

## 2.1 App Id 발급 (팀에서 1개만)

1. [Photon Dashboard](https://dashboard.photonengine.com/)에 로그인합니다.
2. **Create a New App**을 선택하고 유형을 **Fusion**으로 지정합니다.
3. 생성된 App Id(`cab92e97-f9c5-4373-9199-c8ece033bb63` 형태의 GUID)를 복사합니다.

> ⚠️ **팀 전체가 같은 App Id를 사용해야 합니다.** 각자 다른 App Id를 쓰면 같은 방에 들어갈 수 없어 "접속이 안 된다"는 증상이 납니다.

## 2.2 App Id 입력

Unity에서 `Tools > Fusion > Realtime Settings`를 열고 **App Id Fusion** 칸에 붙여넣습니다.

이 값은 `game/Assets/Photon/Fusion/Resources/PhotonAppSettings.asset`에 저장됩니다.

## 2.3 App Id를 커밋할 것인가

**커밋합니다.** 근거는 다음과 같습니다.

- Photon App Id는 클라이언트 빌드에 그대로 포함되는 식별자라 근본적으로 비밀 값이 아닙니다.
- 커밋하지 않으면 팀원 5명이 각자 수동 입력해야 하고, 누락 시 원인을 찾기 어려운 접속 실패로 이어집니다.

단, **이 저장소가 Private일 때를 전제**로 합니다. 저장소를 Public으로 전환한다면 App Id를 회수(Dashboard에서 재발급)하고, 그 시점에 `PhotonAppSettings.asset`을 `.gitignore`로 옮기는 방식을 재검토해야 합니다.

---

# 3. 확인

- [ ] `Tools > Fusion` 메뉴가 보인다
- [ ] Console에 Fusion 관련 에러가 없다
- [ ] `Tools > Fusion > Realtime Settings`에 App Id가 채워져 있다

---

# Troubleshooting

## import 후 컴파일 에러가 대량으로 발생합니다

Unity 버전이 Fusion 2 지원 범위를 벗어났을 가능성이 큽니다. `game/ProjectSettings/ProjectVersion.txt`의 버전과 실제로 연 Editor 버전이 같은지 확인하세요.

## `Tools > Fusion` 메뉴가 없습니다

import가 중간에 실패했거나 일부 항목만 선택해 import했을 수 있습니다. `game/Assets/Photon` 폴더를 지우고 다시 import합니다(이 작업은 커밋 전에 하세요).

## 방에 들어가지지 않습니다

1. App Id가 비어 있지 않은지
2. 팀원 전원이 **동일한** App Id를 쓰는지
3. Photon Dashboard에서 해당 App의 상태가 정상인지

순서대로 확인합니다.

---

# Related Documents

| Document | Description |
|---|---|
| [README.md](README.md) | Photon Integration 개요 |
| [workflow.md](workflow.md) | 네트워크 개발·테스트 절차 |
| [docs/team/ONBOARDING.md](../../docs/team/ONBOARDING.md) | 팀원 최초 환경 구축 절차 |
