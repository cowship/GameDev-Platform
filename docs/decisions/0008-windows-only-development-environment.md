# ADR 0008: 개발 환경을 Windows 단일 환경으로 통일 (WSL 폐기)

## Status

Accepted (2026-09-02)

## Context

이 저장소는 지금까지 **WSL2(Ubuntu) 기준**으로 구축되어 있었다. `scripts/check_environment.sh`는 `apt`/`nvm`으로 도구를 설치했고, `scripts/setup_unity_workspace.sh`는 WSL Mirrored Networking 점검·WSL용 Git LFS 설치·Windows Git Credential Manager 연동을 자동화했으며, `.github/workflows/check-environment-dry-run.yml`은 Ubuntu 컨테이너에서 그 스크립트를 검증했다. 저장소가 Markdown 문서와 Bash 스크립트만 담고 있던 동안에는 이 구성이 자연스러웠다.

[ADR 0006](0006-game-development-in-platform-repository.md)으로 `game/`에 실제 Unity 프로젝트가 들어오면서 전제가 무너졌다.

1. **Unity Editor는 WSL 경로의 프로젝트를 열지 못한다.** 실측 결과 `\\wsl.localhost\Ubuntu\...` 경로로 프로젝트를 열면 Unity가 `Project folder or disk is read only. Please move the project folder somewhere readable and writable.`로 거부하고 종료한다. 성능 저하가 아니라 동작 자체가 불가능하다.
2. 따라서 Unity 프로젝트는 Windows 파일 시스템에 있어야 하고, git 작업도 같은 위치에서 이루어진다. WSL은 중간에 끼는 계층이 될 뿐 기여하는 것이 없다.
3. Claude Code는 Windows 네이티브로 동작하며, Git for Windows가 설치되어 있으면 Bash 도구를 그대로 쓸 수 있다.
4. 실측한 Windows 환경에는 이미 Git for Windows 2.51(**Git LFS 3.7.0 번들 포함**)과 Windows OpenSSH가 있었다. WSL에서 수동 설치하던 항목 상당수가 애초에 불필요했다.
5. Unity CLI는 `unity mcp configure claude-code` / `unity skill install claude-code`로 Claude Code를 1급 클라이언트로 지원한다. WSL에서는 `unity`가 PATH에 없어 `/mnt/c/...` 전체 경로를 직접 조립해야 했지만, Windows에서는 이 명령들이 그대로 동작한다.
6. 팀원 5명 중 WSL을 쓰는 사람은 저장소 관리자 1명뿐이었다. 나머지는 Windows에서 Unity를 쓴다.

## Decision

1. **개발 환경을 Windows + Git Bash 단일 환경으로 통일한다.** WSL은 지원 대상에서 제외한다. 저장소는 Windows 드라이브에 clone한다.

2. **WSL 전용 스크립트와 그 검증 CI를 삭제한다.**

   | 파일 | 처리 | 근거 |
   |---|---|---|
   | `scripts/setup_unity_workspace.sh` | 삭제 | 4개 항목 중 3개(Mirrored Networking, WSL Git LFS 설치, GCM 연동)가 WSL 전용. 남는 Unity MCP 등록은 `setup_mcp.sh`로 흡수 |
   | `scripts/check_environment.sh` | 삭제 | `apt`/`nvm` 기반 Linux 자동 설치가 전부 무의미해짐. Windows에서는 GUI 설치가 대부분이라 자동화 가치가 없고, 확인 항목은 문서 체크리스트로 충분 |
   | `scripts/setup.sh` | 삭제 | 위 두 스크립트를 묶는 오케스트레이터라 존재 이유가 사라짐 |
   | `.github/workflows/check-environment-dry-run.yml` | 삭제 | Ubuntu 컨테이너에서 `check_environment.sh`를 검증하던 CI. 검증 대상이 사라짐 |

3. **스크립트를 3개로 축소한다.** 각각 대상 독자가 다르다.

   | 스크립트 | 대상 | 역할 |
   |---|---|---|
   | `scripts/setup_team_member.sh` | 팀원 **전원 필수** | Git 사용자 확인, Git LFS 초기화, UnityYAMLMerge 병합 드라이버 등록, sandbox 브랜치 준비 |
   | `scripts/setup_mcp.sh` | Claude Code 사용자만 | MCP 서버 등록 (filesystem / sequential-thinking / context7 / github / Unity) |
   | `scripts/setup_claude_skills.sh` | Claude Code 사용자만 | Unity 전용 Claude Skill 설치 |

   (`scripts/check_agent_drift.sh`는 CI 전용 검증 도구라 이 분류 밖이며 그대로 유지한다.)

4. **`setup_mcp.sh`가 Unity MCP를 직접 등록한다.** 기존에는 안내 문구만 출력하고 WSL 스크립트로 넘겼으나, Windows에서는 `unity mcp configure claude-code`와 `unity skill install claude-code`를 그대로 호출할 수 있다.

5. **`setup_team_member.sh`를 Git Bash 기준으로 재작성한다.** `wslpath` 경로 변환 래퍼를 제거하고, Unity Hub의 `secondaryInstallPath.json`과 기본 설치 경로에서 `UnityYAMLMerge.exe`를 찾아 Windows 형식 경로(`F:/...`)로 등록한다. Git LFS는 Git for Windows 번들을 사용하므로 설치 로직을 제거한다.

6. **`.gitattributes`의 `*.sh eol=lf` 규칙은 유지한다.** Git Bash도 LF를 요구하며, CRLF가 섞이면 스크립트 실행이 실패한다.

7. **GitHub Free 플랜을 유지하고, `main` 보호는 팀의 합의로만 운영한다.** Private 저장소에서 Branch Protection(Ruleset)을 쓰려면 Team 이상의 유료 플랜이 필요하다. 5인 규모에서 유료 전환은 과하고, 저장소를 Public으로 돌리면 Photon App Id를 커밋에서 빼야 해서 온보딩이 복잡해진다. 대신 `docs/team/README.md`에 "커밋 전 브랜치 확인"과 "실수로 main에 커밋했을 때 되돌리는 법"을 명시해 사고 비용을 낮춘다. ([ADR 0006](0006-game-development-in-platform-repository.md)의 후속 작업 "가능하다면 Branch Protection 적용"은 이로써 종결한다.)

## Alternatives

- **(A) Unity 프로젝트만 Windows에 두고 Claude Code는 WSL에서 `/mnt/d/...`로 접근**: 기존 WSL 환경을 그대로 쓸 수 있다. 그러나 파일시스템 경계를 넘는 접근이라 git 명령과 파일 탐색이 눈에 띄게 느려지고, 얻는 이점이 없다. 두 환경을 모두 유지·문서화해야 하는 비용도 남는다. 기각.
- **(B) WSL과 Windows를 모두 지원**: 팀원이 선택할 수 있어 유연하다. 그러나 스크립트마다 분기가 두 배가 되고, 실제로 WSL을 쓰는 사람이 1명뿐인 상황에서 유지비만 늘어난다. Simplicity 원칙에 반해 기각.
- **(C) `check_environment.sh`를 Windows용으로 재작성**: 온보딩 자동화를 유지할 수 있다. 그러나 Windows에서는 Unity Hub·Git·VS Code가 모두 GUI 설치라 스크립트가 "설치 여부 확인 + 링크 안내"에 그친다. 그 정도는 `docs/team/ONBOARDING.md`의 준비물 표로 충분하다. 기각.
- **(D) 개발을 Linux/macOS까지 확장**: Unity는 Linux Editor를 제공하지만 팀 전원이 Windows를 쓰고 있어 실익이 없다. 기각.

## Consequences

**장점**
- 팀원 5명이 모두 같은 환경을 쓰게 되어 "내 환경에서만 되는" 문제의 원인이 하나 줄어든다.
- 유지할 스크립트가 6개에서 4개(온보딩용 3개 + CI용 1개)로 줄고, 각 스크립트에서 OS 분기가 사라져 읽기 쉬워졌다.
- Git LFS 설치, Mirrored Networking 설정, 경로 변환 래퍼 등 WSL 때문에 필요했던 우회 장치가 전부 사라졌다.
- Unity MCP 등록이 `unity mcp configure claude-code` 한 줄로 끝난다.

**단점**
- Linux/macOS 사용자가 팀에 합류하면 온보딩 경로가 없다. 그 시점에 재검토가 필요하다.
- `check_environment.sh`가 제공하던 "환경 점검 한 방에" 경험이 사라지고, 준비물 확인이 사람의 체크리스트 작업으로 돌아간다.
- CI가 2개(`agent-drift-check`, `shellcheck`)로 줄어 스크립트의 **실제 실행 동작**을 검증하는 수단이 없어졌다. 정적 분석만 남는다.

**후속 작업**
- WSL 전제가 남아 있는 문서(`integrations/claude/setup.md`, `integrations/mcp/servers.md`, `README.md`, `docs/setup/README.md`)를 Windows 기준으로 정리한다.
- 팀원 5명이 실제로 `setup_team_member.sh`를 Git Bash에서 돌려본 뒤, 실패 지점이 있으면 스크립트를 보완한다. (작성 시점에는 WSL에서 구문·정적 분석만 검증했고 Git Bash 실행은 검증하지 못했다.)
