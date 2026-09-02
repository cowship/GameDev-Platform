# Onboarding

> 팀원이 이 저장소에서 Unity 개발을 시작할 때 **처음 한 번** 수행하는 절차입니다.

---

# 준비물

- Windows 11 (+ WSL2 Ubuntu — Claude Code를 쓸 경우)
- Unity Hub
- Unity Editor **6000.3.22f1** (버전이 다르면 프로젝트 파일이 갈립니다)
- Git, Git LFS
- Photon 계정 (무료)
- GitHub 계정 + 이 저장소 Collaborator 권한

---

# 1. 저장소 clone

이미 clone 되어 있다면 건너뜁니다.

```bash
git clone git@github.com:cowship/GameDev-Platform.git
cd GameDev-Platform
```

> **어디에 clone 할지**: Unity Editor는 Windows에서 실행되므로, **Windows 파일 시스템**(예: `D:\Work\GameDev-Platform`)에 clone하는 것을 권장합니다. WSL 내부 경로(`/home/...`)에 둔 프로젝트를 Windows Unity로 열면 파일 접근이 네트워크 경유가 되어 Asset import와 컴파일이 눈에 띄게 느려집니다.

---

# 2. 개발 환경 자동 설정

```bash
./scripts/setup_team_member.sh
```

이 스크립트가 하는 일입니다.

| 단계 | 내용 | 왜 필요한가 |
|---|---|---|
| 1 | Git 사용자 정보 확인 | 커밋 작성자가 비어 있으면 리뷰·추적이 안 됩니다 |
| 2 | Git LFS 설치 및 초기화 | LFS 없이 pull하면 이미지·오디오가 텍스트 포인터 파일로 받아집니다 |
| 3 | UnityYAMLMerge 병합 드라이버 등록 | Scene/Prefab 충돌을 Unity 전용 도구로 자동 해결합니다 |
| 4 | `sandbox/{본인이름}` 브랜치 생성 | 개인 실험 공간 |

여러 번 실행해도 안전합니다.

## Claude Code까지 함께 쓴다면

```bash
./scripts/setup.sh                    # 환경 점검 + MCP 서버 등록
./scripts/setup_unity_workspace.sh    # Unity CLI 기반 MCP 등록 (Unity Editor 1회 실행 후)
```

---

# 3. Unity 프로젝트 열기

1. Unity Hub → **Add** → **Add project from disk**
2. 저장소 안의 **`game/` 폴더**를 선택합니다 (저장소 루트가 아닙니다)
3. Editor 버전이 `6000.3.22f1`인지 확인 후 엽니다

처음 여는 데는 몇 분이 걸립니다. Unity가 `game/Library/`를 새로 만드는 과정이며, 이 폴더는 Git에 올라가지 않습니다(각자 로컬 캐시).

## 버전이 다르다는 경고가 뜨면

```text
This project was last opened with a different version of the Editor.
```

→ **그냥 열지 마세요.** Unity Hub에서 `6000.3.22f1`을 설치한 뒤 그 버전으로 엽니다. 다른 버전으로 열면 `ProjectSettings`와 Asset이 자동 업그레이드되어 전원에게 대량 변경이 퍼집니다.

---

# 4. Photon Fusion 설정

[integrations/photon/setup.md](../../integrations/photon/setup.md)를 따릅니다. 요약하면 이렇습니다.

1. Fusion SDK(`.unitypackage`)를 프로젝트에 import — **최초 1명만 수행하고 커밋**합니다. 이미 `game/Assets/Photon/`이 있다면 건너뜁니다.
2. 팀 공용 App Id를 `Tools > Fusion > Realtime Settings`에 입력합니다.

---

# 5. 동작 확인

- [ ] Unity Console에 빨간 에러가 없다
- [ ] `game/Assets/Scenes/SampleScene.unity`가 열리고 Play가 된다
- [ ] `Window > General > Test Runner`에서 EditMode/PlayMode 탭이 보인다
- [ ] `git status`에 **기존 파일의 수정**이 없다

## 프로젝트를 처음 여는 사람에게만 나타나는 변화

프로젝트를 처음 연 사람은 `git status`에 **폴더별 `.meta` 파일이 새로 생성**된 것을 보게 됩니다. Unity가 `Assets/` 하위 폴더마다 GUID를 부여하면서 만드는 파일이며, **정상입니다.** 이 `.meta`들은 반드시 커밋해야 합니다. 커밋하지 않으면 다음 사람이 열 때 또 다른 GUID가 생성되어 팀원 간 참조가 어긋납니다.

```bash
git switch -c chore/unity-meta-files
git add game/Assets
git commit -m "chore: Unity가 생성한 폴더 .meta 파일 추가"
```

반대로 **기존 파일이 수정된 것**으로 나온다면 주의해야 합니다. 특히 `ProjectSettings`나 Asset이 무더기로 수정됐다면 **Editor 버전이 다를 가능성이 높습니다.** 커밋하지 말고 팀에 알려주세요.

---

# 6. 다음 단계

[docs/team/README.md](README.md)의 Branch 전략과 Unity 공동 작업 규칙을 읽습니다. 특히 아래 3가지는 사고가 잦은 지점입니다.

- `.meta` 파일 함께 커밋하기
- 하나의 Scene은 한 명만 수정하기
- 바이너리 자산은 `git lfs lock`으로 선점하기

---

# Troubleshooting

## 이미지 파일이 열리지 않고 텍스트로 보입니다

Git LFS가 설정되지 않은 상태에서 pull한 경우입니다.

```bash
git lfs install --local
git lfs pull
```

## Unity에서 스크립트 참조가 전부 Missing으로 뜹니다

`.meta` 파일이 누락된 커밋을 받았을 가능성이 큽니다. 누가 언제 빠뜨렸는지 확인하고 해당 `.meta`를 복구합니다.

## `git push`가 LFS lock 때문에 거부됩니다

다른 팀원이 그 파일을 잠가둔 상태입니다. `git lfs locks`로 누가 잠갔는지 확인하고 협의하세요.

## Unity가 프로젝트를 인식하지 못합니다

저장소 루트가 아니라 `game/` 폴더를 선택했는지 확인하세요.

---

# Related Documents

| Document | Description |
|---|---|
| [README.md](README.md) | 팀 협업 규칙 (Branch 전략, Unity 공동 작업 규칙) |
| [integrations/photon/setup.md](../../integrations/photon/setup.md) | Photon Fusion SDK 설치 |
| [integrations/unity/setup.md](../../integrations/unity/setup.md) | Unity Hub / Editor / Git LFS 기본 설정 |
| [docs/setup/README.md](../setup/README.md) | Claude Code / MCP 를 포함한 전체 개발 환경 설정 |
