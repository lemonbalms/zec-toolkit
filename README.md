# zec-toolkit

ZEC Development Toolkit — Claude Code를 위한 단일 개발 오케스트레이션 플러그인.

## Overview

`zec-toolkit`는 Claude Code 단일 오케스트레이션 시스템입니다. MoAI-ADK의 워크플로우 설계와 oh-my-claudecode의 프로덕션급 기능(지속성 엔진, 컨텍스트 보호, LSP 도구)을 결합하여, 외부 플러그인 없이 독립적으로 동작합니다.

## Contents

### Agents (3개)
- `executor.md` — 최소 변경 원칙의 집중 구현 에이전트 (sonnet)
- `deep-executor.md` — 자율 탐색+구현 복잡 태스크 에이전트 (opus)
- `explore.md` — 읽기 전용 코드베이스 탐색 전문 (haiku)

### Bridge (Node.js, 자체 완결형)
- `persistent-mode.cjs` (670줄) — 지속성 엔진 (context-limit, stale, cancel 보호)
- `keyword-detector.mjs` (509줄) — 키워드 감지 + 텍스트 정제 + 명세 부족 게이트
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

```
/zec design "기능"       # 전략 합의 (Planner→Architect→Critic)
/zec plan "기능"         # SPEC 생성 (EARS 형식)
/zec run SPEC-XXX        # DDD/TDD 구현
/zec sync                # 문서 동기화 + PR
/zec review              # 코드 리뷰 (4관점)
/zec fix                 # 에러 자동 수정
/zec loop                # 반복 수정
/zec clean               # 미사용 코드 제거
/zec mx                  # MX 태그 스캔
/zec coverage            # 테스트 커버리지 분석
/zec e2e                 # E2E 테스트
```

## Installation

```bash
claude plugin add lemonbalms/zec-toolkit
```

## License

MIT
