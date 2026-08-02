# Unity Setup

---

# Requirements

Unity 개발 전 다음 환경이 준비되어 있어야 합니다.

- Unity Hub
- Unity Editor (LTS 버전)
- Git
- Git LFS

---

# Unity Hub 설치

공식 사이트에서 Unity Hub를 다운로드하여 설치합니다.

설치 후 Unity 계정으로 로그인합니다.

---

# Unity Editor 버전 규칙

프로젝트 간 호환성을 위해 **LTS(Long Term Support) 버전 고정**을 원칙으로 합니다.

| 항목 | 규칙 |
|---|---|
| Editor 버전 | 최신 LTS 고정 |
| 버전 변경 | Technical Lead 검토 후 결정 |
| 버전 기록 | Repository의 `ProjectVersion.txt`로 관리 |

---

# Git LFS 설정

Unity 프로젝트는 바이너리 Asset(이미지, 모델, 오디오 등)이 많아 Git LFS 사용을 필수로 합니다.

설치

```bash
git lfs install
```

추적 대상 지정 (게임 프로젝트 Repository 내에서 실행)

```bash
git lfs track "*.psd"
git lfs track "*.fbx"
git lfs track "*.png"
git lfs track "*.wav"
git lfs track "*.mp4"
```

---

# Unity .gitignore

Unity 프로젝트 생성 시 Unity 공식 `.gitignore` 템플릿 적용을 권장합니다.

제외 대상 예시

```text
/[Ll]ibrary/
/[Tt]emp/
/[Oo]bj/
/[Bb]uild/
/[Bb]uilds/
/[Ll]ogs/
/[Uu]ser[Ss]ettings/
```

---

# Verify

```bash
git lfs version
```

Unity Hub에서 프로젝트가 정상적으로 열리고, Console에 오류가 없으면 설정이 완료된 것입니다.

---

# Troubleshooting

## Git LFS 미적용으로 인한 Repository 용량 증가

→ 프로젝트 생성 직후, 첫 Commit 이전에 반드시 Git LFS 설정을 완료합니다.

---

## Unity Editor 버전 불일치

```text
This project was last opened with a different version of the Editor.
```

→ `ProjectVersion.txt`에 명시된 버전과 동일한 Unity Editor를 Unity Hub로 설치합니다.

---

# References

- Unity Hub Documentation
- Git LFS Documentation
- Unity 공식 .gitignore Template (GitHub gitignore Repository)