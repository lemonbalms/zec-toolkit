# zec-toolkit

ZEC Development Toolkit — Claude Code를 위한 단일 개발 오케스트레이션 플러그인.

## Overview

`zec-toolkit`는 Claude Code 단일 오케스트레이션 시스템입니다. 워크플로우 설계와 프로덕션급 기능(지속성 엔진, 컨텍스트 보호, LSP 도구)을 결합하여, 외부 플러그인 없이 독립적으로 동작합니다.

## Contents

### Agents (3개)
- `executor.md` — 최소 변경 원칙의 집중 구현 에이전트 (sonnet)
- `deep-executor.md` — 자율 탐색+구현 복잡 태스크 에이전트 (opus)
- `explore.md` — 읽기 전용 코드베이스 탐색 전문 (haiku)

### Bridge (Node.js, 자체 완결형)
- `persistent-mode.cjs` (670줄) — 지속성 엔진 (context-limit, stale, cancel 보호)
- `keyword-detector.mjs` (484줄) — 11개 키워드 감지 + 텍스트 정제 + 모드 활성화
- `context-guard-stop.mjs` (181줄) — 컨텍스트 75% 경고
- `context-safety.mjs` (100줄) — ExitPlanMode 55% 차단
- `verify-deliverables.mjs` (234줄) — 에이전트 산출물 자동 검증
- `post-tool-verifier.mjs` (439줄) — Bash 에러 감지, `<remember>` 태그 처리
- `mcp-lsp-server.cjs` (24,107줄) — LSP diagnostics + state + notepad MCP 서버
- `run.cjs` (114줄) — 크로스 플랫폼 hook 러너
- `lib/stdin.mjs` (65줄) — 타임아웃 보호 stdin 리더
- `lib/atomic-write.mjs` (96줄) — 원자적 파일 쓰기

### Skills (10개)
- `zec/` — ZEC 오케스트레이터 (design, plan, run, sync, review, fix, loop, mx 등)
- `harness-fastapi/` — FastAPI 백엔드 개발 가이드
- `harness-pytest/` — pytest 테스팅 가이드
- `harness-nextjs/` — Next.js 15 프론트엔드 가이드
- `harness-react-perf/` — React/Next.js 성능 최적화
- `harness-web-design/` — Web Interface Guidelines 리뷰
- `harness-frontend-design/` — 프론트엔드 디자인 생성
- `harness-mermaid/` — Mermaid 다이어그램 생성
- `harness-pdf/` — PDF 조작 도구
- `zec-tool-ast-grep/` — AST 기반 구조적 코드 검색/변환

### Rules (6개)
- `core/zec-constitution.md` — ZEC 핵심 원칙
- `development/coding-standards.md` — 코딩 표준
- `development/skill-authoring.md` — 스킬 작성 가이드
- `workflow/file-reading-optimization.md` — 파일 읽기 최적화
- `workflow/team-protocol.md` — 팀 프로토콜
- `workflow/mx-tag-protocol.md` — MX 태그 프로토콜

### Templates
- `templates/zec-config/sections/` — 15개 YAML 설정 템플릿

### Documentation
- `docs/` — Nextra 4 가이드 사이트 (Next.js 15, 28페이지)

## Command Reference

| 명령어 | 별칭 | 설명 |
|--------|------|------|
| `/zec design "기능"` | consult, architect | 전략 합의 (Planner→Architect→Critic) |
| `/zec plan "기능"` | spec | SPEC 생성 (EARS 형식) |
| `/zec run SPEC-XXX` | impl | DDD/TDD 구현 |
| `/zec sync` | docs, pr | 문서 동기화 + PR |
| `/zec review` | code-review | 코드 리뷰 (4관점) |
| `/zec fix` | | 에러 자동 수정 |
| `/zec loop` | | 반복 수정 |
| `/zec clean` | dead-code | 미사용 코드 제거 |
| `/zec mx` | | MX 태그 스캔 |
| `/zec coverage` | cov | 테스트 커버리지 분석 |
| `/zec e2e` | e2e-test | E2E 테스트 |
| `/zec project` | init | 프로젝트 문서 생성 (product/structure/tech) |
| `/zec codemaps` | | 아키텍처 문서 생성 |
| `/zec context` | ctx, memory | Git 기반 컨텍스트 메모리 추출 |
| `/zec feedback` | fb, bug, issue | GitHub 이슈 생성 (버그/기능 요청) |

### 주요 플래그 및 서브옵션

**design**
- `review [SPEC-ID]` — 기존 consensus 재평가 (Critic)
- `--deliberate` — 심층 분석 (pre-mortem + 확장 테스트 계획)

**plan**
- `--worktree` — 격리된 Git worktree에서 작업
- `--branch` — feature 브랜치 자동 생성
- `--team` — 팀 기반 병렬 리서치
- `--no-issue` — GitHub Issue 생성 건너뛰기

**run**
- `--team` — 팀 기반 병렬 구현

**sync**
- `--pr` — 브랜치 push + PR 자동 생성
- `--merge` — PR 자동 머지 + 브랜치 정리
- `--skip-mx` — MX 태그 검증 건너뛰기

**review**
- `--staged` — staged 변경사항만 리뷰
- `--branch BRANCH` — 특정 브랜치와 비교
- `--security` — 보안 집중 리뷰
- `--file PATH` — 특정 파일만 리뷰
- `--team` — 병렬 멀티 관점 리뷰

**fix**
- `--dry` — 미리보기만 (변경 없음)
- `--sequential` — 순차 스캔
- `--level N` — 최대 수정 레벨 (기본 3)
- `--errors` — 에러만 수정 (경고 제외)
- `--security` — 보안 이슈 포함
- `--resume [ID]` — 스냅샷에서 재개
- `--team` — 팀 기반 디버깅

**loop**
- `--max N` — 최대 반복 횟수 (기본 100)
- `--auto-fix` — 자동 수정 활성화
- `--sequential` — 순차 진단
- `--coverage` — 커버리지 임계값 포함

**clean**
- `--dry` — 미리보기만
- `--safe-only` — 확실한 코드만 제거
- `--file PATH` — 특정 파일/디렉토리
- `--aggressive` — 낮은 사용 코드도 포함

**coverage**
- `--target N` — 커버리지 목표 (기본 85%)
- `--file PATH` — 특정 파일만 분석
- `--report` — 리포트만 생성 (테스트 미생성)
- `--critical` — 핵심 경로 집중

**e2e**
- `--tool TOOL` — 브라우저 도구 (playwright, chrome-mcp, agent-browser)
- `--record` — GIF 녹화
- `--url URL` — 대상 URL
- `--journey NAME` — 특정 사용자 여정만

**codemaps**
- `--force` — 전체 재생성
- `--area AREA` — 특정 영역만 (api, auth 등)
- `--format FORMAT` — 출력 형식 (markdown, mermaid, json)

**context**
- `--spec SPEC-XXX` — 특정 SPEC 필터
- `--days N` — N일 이내 커밋 (기본 30)
- `--category CAT` — 카테고리 필터
- `--summary` — 요약만
- `--inject` — 현재 세션에 주입

**글로벌 플래그**
- `--team` — Agent Teams 모드 강제
- `--solo` — sub-agent 모드 강제
- `--deepthink` — Sequential Thinking MCP 활성화

## Installation

### 방법 1: GitHub 마켓플레이스 (권장)

Claude Code에서 `/plugin` → **Marketplaces** 탭 → **Add** 선택 후 입력:

```
lemonbalms/zec-toolkit
```

마켓플레이스 등록 후 **Discover** 탭에서 `zec-toolkit`을 찾아 **Install** 합니다.

설치 범위를 선택할 수 있습니다:

| 범위 | 설명 | 저장 위치 |
|------|------|----------|
| user | 모든 프로젝트에서 사용 (기본) | `~/.claude/` |
| project | 팀 공유 (git에 포함) | `.claude/settings.json` |
| local | 현재 저장소만 (gitignored) | `.claude/settings.local.json` |

### 방법 2: 로컬 소스에서 영구 설치

```bash
# 소스 클론
git clone https://github.com/lemonbalms/zec-toolkit.git

# Claude Code에서 영구 설치
/plugin install ./zec-toolkit --scope project
```

이후 `claude`만 실행하면 자동 로드됩니다.

### 방법 3: 로컬 소스 일회성 로드 (개발/테스트용)

```bash
claude --plugin-dir ./zec-toolkit
```

현재 세션에만 로드됩니다. 변경사항 반영 시 `/reload-plugins`를 실행하세요.

### 설치 확인

Claude Code에서 `/zec`를 실행하여 ZEC 오케스트레이터가 응답하면 설치 완료입니다.

### 관리

| 작업 | 방법 |
|------|------|
| 설치/제거/업데이트 | `/plugin` → **Installed** 탭 |
| 마켓플레이스 추가/제거 | `/plugin` → **Marketplaces** 탭 |
| 로딩 오류 확인 | `/plugin` → **Errors** 탭 |

## License

MIT
