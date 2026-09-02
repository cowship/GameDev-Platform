# ADR 0006: 게임 개발을 플랫폼 저장소에서 진행하고 5인 팀 협업 모델을 도입

## Status

Accepted (2026-09-02)

## Context

지금까지 GameDev-Platform은 다음 전제로 운영되어 왔다.

- `README.md`의 **Repository Policy**: "실제 게임 프로젝트는 별도 Repository에서 관리한다"
- [ADR 0004](0004-unity-starter-template.md): GameDev-Platform에는 실제 Unity 프로젝트 파일을 두지 않고 **스펙 문서**만 둔다
- `integrations/github/workflow.md`, `templates.md`: Branch 전략과 Issue/PR 템플릿은 "Stage 6에서 생성될 게임 Repository"용 표준이며, 플랫폼 저장소 자신은 `main` 직접 커밋으로 운영
- `integrations/github/automation.md`: CI는 머지 게이트가 아니라 사후 안전망

그런데 실제 상황이 바뀌었다.

1. **팀원 5명이 이미 `cowship/GameDev-Platform`을 clone한 상태**이며, 이 저장소로 Unity + Photon Fusion 멀티플레이 게임을 개발하기로 결정했다.
2. 즉 Stage 5(Team Collaboration)와 Stage 6(First Game Project)가 동시에, 그리고 **새 저장소가 아니라 기존 저장소에서** 시작된다.
3. 기존의 "main 직접 커밋" 운영은 1인 문서 작업을 전제로 한 것이라, 5명이 Unity 프로젝트를 동시에 만지는 상황에는 맞지 않는다. Scene/Prefab처럼 병합이 어려운 파일이 들어오면 사고가 즉시 팀 전체로 번진다.
4. 팀원들은 게임 개발과 별개로 **개인적인 기능 실험과 학습**을 할 공간도 필요로 한다. 이 실험이 `main`의 안정성에 영향을 주어서는 안 된다.

## Decision

1. **게임 프로젝트를 이 저장소의 `game/` 하위 폴더에서 개발한다.** 저장소 루트에 Unity 프로젝트를 두지 않는 이유는, 루트에 이미 `agents/`, `docs/`, `integrations/`, `scripts/` 등 플랫폼 자산이 있어 Unity가 이들을 Asset으로 인식하려 하기 때문이다. `game/`으로 감싸면 Unity Hub가 그 폴더만 프로젝트로 인식하고, 플랫폼 문서와 게임 코드가 한 저장소 안에서 물리적으로 분리된 채 공존한다.

2. **`README.md`의 Repository Policy를 "게임과 플랫폼을 한 저장소에서 운영하되 디렉토리로 분리"로 갱신한다.** 두 번째 게임 프로젝트가 생기는 시점에 다시 분리를 검토한다.

3. **Branch 전략을 `main` + `feature|fix|chore/*` + `sandbox/{이름}`으로 확정한다.**
   - `main`: 게임 개발 본류. 직접 push 금지, PR로만 병합, 리뷰 1명 이상, Squash and merge.
   - `feature|fix|chore/*`: 실제 개발 작업. `main`에서 분기해 PR로 되돌아온다.
   - `sandbox/{팀원이름}`: 팀원 개인의 실험·학습 전용. 소유자만 push하고 force push를 허용하며 리뷰가 없고, **`main`으로 직접 병합하지 않는다.** 실험 결과를 반영할 때는 `main`에서 새 `feature/*`를 만들고 필요한 파일만 골라 옮긴다.

4. **`develop` 통합 Branch는 두지 않는다.** 5인 규모에 배포 대상이 아직 없어 이중 관리 비용이 얻는 안정성보다 크다.

5. **플랫폼 저장소의 운영 모델을 "main 직접 커밋"에서 "PR 기반"으로 전환한다.** 단, 이는 사람이 지키는 규칙에서 출발하며, GitHub Branch Protection(Ruleset) 적용은 저장소 플랜이 허용하는 범위에서 별도로 설정한다(Private 저장소의 Ruleset은 유료 플랜을 요구한다).

6. **`.github/ISSUE_TEMPLATE/`과 `PULL_REQUEST_TEMPLATE.md`를 이 저장소에 실제로 생성한다.** `integrations/github/templates.md`가 "문서로만 보관하고 실제 파일은 만들지 않는다"고 정한 것은 이 저장소에 게임이 없다는 전제 때문이었으며, 그 전제가 사라졌다.

7. **팀원 관점의 운영 문서를 `docs/team/`에 신설한다** (`README.md` = 협업 규칙, `ONBOARDING.md` = 최초 환경 구축). `integrations/*`가 "도구별 표준"이라면 `docs/team/`은 "사람이 매일 따르는 절차"로 역할을 나눈다.

8. **팀원 온보딩을 `scripts/setup_team_member.sh`로 자동화한다** (Git LFS, UnityYAMLMerge 병합 드라이버, sandbox 브랜치 생성). Automation First 원칙에 따라, 5명이 각자 수동으로 맞춰야 하는 항목을 스크립트 1회 실행으로 대체한다.

## Alternatives

- **(A) 원래 정책대로 게임용 새 Repository를 만든다**: 플랫폼과 게임의 관심사가 깔끔히 분리되고 ADR 0004와도 일치한다. 그러나 팀원 5명이 **이미 이 저장소를 clone한 상태**라 전원이 다시 clone·설정해야 하고, 초기 학습 비용이 두 배가 된다. 저장소가 2개면 문서(플랫폼)와 코드(게임)를 오가는 참조 비용도 계속 발생한다. 팀이 실제로 움직이기 시작하는 것이 정책 정합성보다 우선이라고 판단해 기각한다. 대신 `game/` 디렉토리 분리로 "언제든 별도 저장소로 떼어낼 수 있는" 구조는 유지한다.
- **(B) 저장소 루트에 Unity 프로젝트를 직접 둔다**: Unity Hub로 저장소를 그대로 열 수 있어 한 단계 단순해진다. 그러나 Unity가 `docs/`, `scripts/`, `agents/`까지 Asset 후보로 취급해 불필요한 `.meta` 생성과 import 경고가 발생하고, `.gitignore` 규칙도 플랫폼 파일과 뒤섞인다. 기각.
- **(C) `develop`을 포함한 Git Flow 전체 도입**: 릴리즈 관리에는 유리하지만, 배포 대상이 없는 현 시점에서는 브랜치 하나를 더 동기화하는 비용만 남는다. 보류하고 정식 릴리즈 시점에 재검토.
- **(D) sandbox를 별도 저장소(playground)로 분리**: 게임 저장소가 깨끗하게 유지된다. 그러나 실험 결과를 본 프로젝트로 옮길 때 Unity 프로젝트 설정과 패키지 버전이 달라 그대로 동작하지 않는 경우가 많고, 저장소를 하나 더 관리해야 한다. 같은 저장소 안의 브랜치로 두면 프로젝트 환경이 동일해 실험 결과의 이식성이 높다. 기각.
- **(E) 개인 Fork 기반 협업**: 오픈소스에서 흔한 모델이나, 5명이 상시 협업하는 사내 팀에서는 upstream 동기화 부담만 늘어난다. 기각.

## Consequences

**장점**
- 팀원 5명이 추가 clone 없이 즉시 개발을 시작할 수 있다.
- `sandbox/*`가 있어 개인 실험이 `main`의 안정성을 위협하지 않으면서도 같은 프로젝트 환경에서 이루어진다.
- PR 기반 전환으로 Scene/Prefab처럼 위험한 변경이 최소 1명의 눈을 거친다.
- 플랫폼 문서와 게임 코드가 한 저장소에 있어, 표준 문서와 실제 구현이 어긋나면 즉시 드러난다.

**단점**
- `README.md`가 선언한 "플랫폼 저장소" 정체성이 흐려진다. 두 번째 게임이 생기면 이 저장소의 표준을 어떻게 재사용할지 다시 설계해야 한다.
- 저장소가 무거워진다. Unity Asset과 Photon SDK가 들어오면 문서만 있던 시절 대비 clone 비용이 크게 늘어난다(Git LFS로 완화).
- 기존 문서 다수(`integrations/github/workflow.md`, `templates.md`, `automation.md`, `docs/architecture/overview.md`)의 "적용 범위" 서술을 함께 고쳐야 한다.
- Private 저장소에서 Branch Protection을 강제하려면 유료 플랜이 필요해, 당분간 `main` 보호는 **규칙 합의에 의존**한다.

**후속 작업**
- `.github/CODEOWNERS`에 팀원 5명의 실제 GitHub 계정을 채우고 주석을 해제한다.
- 저장소 플랜을 확인해 가능하다면 `main`에 Branch Protection(PR 필수, force push 금지)을 적용한다.
- 두 번째 게임 프로젝트가 필요해지는 시점에 플랫폼/게임 저장소 분리를 재검토하고 본 ADR을 갱신한다.
- Unity 프로젝트가 들어오면서 기존 CI(`automation.md`의 단계적 도입 계획)에 Unity 관련 검증을 추가할지 재검토한다.
