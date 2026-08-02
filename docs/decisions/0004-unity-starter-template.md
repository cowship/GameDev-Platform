# ADR 0004: Unity Starter Template 구조

## Status

Accepted

## Context

`README.md`의 Roadmap에서 Stage 4는 "Unity Starter Template"이며, `docs/architecture/overview.md`의 Roadmap Mapping은 이를 `integrations/unity/`, `templates/`(예정) 산출물로 연결한다. PM Agent는 `integrations/unity/README.md`에 "Planned"로만 남아있는 `project_template.md`(Unity Starter Template 요구사항)를 Stage 4 진입의 Must 항목으로 지목했다.

기존 Unity Integration 문서 3종은 이미 부분적으로 표준을 정해두었다.

- [`agents/unity.md`](../../agents/unity.md): Assets 하위 Script Organization(Scripts/Core,Gameplay,UI,Systems,Utilities + Prefabs/Scenes/ScriptableObjects/Materials/Art), 네이밍 규칙, Architecture Prefer/Avoid 패턴
- [`integrations/unity/setup.md`](../../integrations/unity/setup.md): Editor는 최신 LTS 버전 고정(`ProjectVersion.txt`로 기록), Git LFS 필수, 최소한의 `.gitignore` 대상
- [`integrations/unity/workflow.md`](../../integrations/unity/workflow.md): 프로젝트 생성 6단계 절차, 4단계로 "표준 프로젝트 구조 적용"이 이미 자리 잡혀 있으나 그 구조가 Assets 내부 수준에 그침

이 세 문서는 서로 모순되지 않지만, Repository 전체 트리(Packages, ProjectSettings, gitignore 대상)와 필수 패키지 의존성 수준까지는 정의하지 않는다. 또한 `README.md`의 "실제 게임 프로젝트는 별도 Repository에서 개발" 원칙에 따라, GameDev-Platform 자체에는 실제 Unity 프로젝트 파일이 존재하지 않는다. 즉 이번에 만들 것은 복사 가능한 실제 폴더가 아니라, 각 게임 Repository가 최초 생성 시 참조하는 **스펙 문서**다.

---

## Decision

1. **Assets 하위 구조는 `agents/unity.md`의 기존 5개 Scripts 카테고리(Core, Gameplay, UI, Systems, Utilities)를 그대로 유지하고 확장**한다. `Editor`(Unity가 폴더명으로 빌드에서 자동 제외), `Tests/EditMode`, `Tests/PlayMode`(Unity Test Framework 요구사항)를 Scripts와 별도로 추가한다. Assets 최상위에는 `Audio`, `Settings`(Input Actions 자산, URP Asset), `AddressableAssetsData`(Addressables 최초 설정 시 자동 생성, Git 추적 대상), `ThirdParty`(Asset Store 등 외부 자산, 직접 수정 금지)를 추가한다. 상세 트리는 `integrations/unity/project_template.md`에 둔다.

2. **Scripts 폴더 간 의존성 방향을 명시적으로 고정**한다. Core/Utilities는 무의존, Systems→Core, Gameplay→Core+Systems, UI→Core+Systems이며 UI는 Gameplay를 직접 참조하지 않고 Event로 통신한다. 이는 `agents/unity.md`의 "낮은 결합도", "Event 기반 설계" 원칙을 폴더 구조 수준에서 강제하기 위함이다. Assembly Definition으로의 물리적 강제는 지금 단계에서는 도입하지 않고, Tests 폴더에 요구되는 최소 asmdef(EditMode/PlayMode)만 필수로 한다.

3. **필수 패키지(Packages/manifest.json 기준선)를 5종으로 고정**한다: `com.unity.addressables`(`agents/unity.md`에 이미 명시), `com.unity.inputsystem`(New Input System, Event 기반 설계와 정합), `com.unity.textmeshpro`, `com.unity.test-framework`, `com.unity.render-pipelines.universal`(URP). 버전 번호는 Unity Hub가 지정 LTS Editor로 프로젝트를 생성할 때 채우는 값을 그대로 쓰고 임의로 최신화하지 않는다(`setup.md`의 Editor 버전 고정 원칙과 동일 이유).

4. **Repository 루트 수준의 Git 추적/제외 기준을 확정**한다. `Assets/`, `Packages/manifest.json`, `Packages/packages-lock.json`, `ProjectSettings/`는 Git 추적, `Library/`, `Temp/`, `Obj/`, `Logs/`, `Build(s)/`, `UserSettings/`, `.vs/`, `.idea/`는 gitignore 대상이다. Git LFS 추적 확장자 목록은 `setup.md`의 기존 목록을 기준선으로 삼는다.

5. **"게임마다 다른 것"과 "플랫폼 표준으로 고정할 것"을 명시적으로 구분**한다. 고정: 폴더 스켈레톤/이름, 의존성 방향, 네이밍 규칙, gitignore/LFS 표준, 필수 패키지 5종, 프로젝트 생성 절차. 게임별 재량: Render Pipeline 세부 조정(URP 내 Renderer Feature 등), Art/Audio 세부 분류, ScriptableObjects 내부 카테고리, Cinemachine/2D·3D 전용 패키지/Netcode/Localization 등 장르 종속 패키지.

6. **`integrations/unity/project_template.md`를 신설**하고 `integrations/unity/README.md`의 "Planned" 표기를 실제 링크로 교체한다.

---

## Alternatives

- **(A) Assets 하위에 `_Project/` 루트 폴더를 두고 그 아래로 Scripts 등을 몰아넣는 구조** (Unity 커뮤니티에서 흔한 관례): `agents/unity.md`에 이미 정의된 Assets 직속 구조와 달라져 기존 문서와 즉시 불일치가 생기고 학습 비용만 늘어난다. 기각.
- **(B) 실제 Unity 프로젝트를 GameDev-Platform 저장소 안에 통째로 커밋해두고 게임 시작 시 그대로 복사/fork**: `README.md`의 "실제 게임 프로젝트는 별도 Repository" 원칙과 정면으로 충돌하고, Unity 프로젝트 특유의 바이너리·Editor 버전 종속성 때문에 플랫폼 저장소가 무거워진다. 기각. 대신 문서 기반 스펙을 채택하고, 필요성이 검증되면 후속 작업에서 재검토한다.
- **(C) Cinemachine, 2D/3D 전용 패키지까지 포함한 넓은 패키지 표준**: 게임 장르마다 필요 여부가 갈려 Reusability First에 위배되고, 불필요한 패키지는 컴파일 시간과 프로젝트 복잡도만 늘린다. 기각.
- **(D) Scripts 카테고리 전체를 Assembly Definition으로 분리해 의존성 방향을 물리적으로 강제**: 유지보수성 측면에서는 이상적이지만 현재 단계(첫 게임 프로젝트 이전)에서는 과도한 추상화(Decision Criteria 3순위 단순성 위배)다. 보류하고 Tests에만 필수 적용, 나머지는 프로젝트 규모가 커졌을 때 재검토한다.

---

## Consequences

**장점**
- Stage 4 게이트가 충족되어 Stage 6(First Game Project)에서 신규 게임 저장소가 동일한 골격에서 즉시 시작할 수 있다.
- `agents/unity.md`의 원칙(Data Driven, Component 기반, 낮은 결합)이 폴더/의존성 구조로 구체화되어 Unity Agent가 실제 구현 시 참조할 기준이 생긴다.
- "게임마다 다른 것"을 명시적으로 분리해 두어, 두 번째 게임 프로젝트가 생겼을 때 표준의 재사용성을 실제로 검증할 수 있다.

**단점**
- 문서(스펙)만 존재하고 실제로 복사 가능한 폴더 스켈레톤이나 `manifest.json` 프리셋 파일은 아직 없어, 신규 프로젝트 생성 시 여전히 수작업이 필요하다.
- URP·Input System 등 패키지 표준이 실제 게임에 한 번도 적용되어 검증된 적이 없어, Stage 6 첫 게임에서 재조정될 가능성이 있다.

**후속 작업**
- Stage 6 첫 게임 프로젝트 적용 후 실제 사용 경험을 바탕으로 본 ADR을 재검토한다(특히 Assembly Definition 분리 필요 시점, 패키지 목록의 과부족).
- 신규 프로젝트 생성 시 반복 수작업이 확인되면, `templates/unity-starter/`에 실제 복사 가능한 폴더 스켈레톤과 `manifest.json` 프리셋을 자동화 스크립트(`scripts/`)와 함께 추가하는 것을 Automation First 원칙에 따라 별도 ADR로 검토한다.
- `integrations/unity/README.md`의 "Planned" 표기 제거 및 `project_template.md` 링크 반영은 Documentation Agent가 함께 수행한다.
