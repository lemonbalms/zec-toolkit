# zec-toolkit

ZEC Development Toolkit — Claude Code plugin for unified development orchestration.

## Overview

`zec-toolkit`는 Claude Code 프로젝트에서 공통으로 사용하는 스킬, 규칙, 템플릿을 제공하는 플러그인입니다.

## Contents

### Skills
- `zec/` — ZEC 오케스트레이터 (plan, run, sync, review, fix, loop, mx 등)
- `harness-fastapi/` — FastAPI 백엔드 개발 가이드
- `harness-pytest/` — pytest 테스팅 가이드
- `harness-nextjs/` — Next.js 15 프론트엔드 가이드
- `harness-react-perf/` — React/Next.js 성능 최적화
- `harness-web-design/` — Web Interface Guidelines 리뷰
- `harness-frontend-design/` — 프론트엔드 디자인 생성
- `harness-mermaid/` — Mermaid 다이어그램 생성
- `harness-pdf/` — PDF 조작 도구

### Rules
- `core/zec-constitution.md` — ZEC 핵심 원칙
- `development/coding-standards.md` — 코딩 표준
- `development/skill-authoring.md` — 스킬 작성 가이드
- `workflow/file-reading-optimization.md` — 파일 읽기 최적화
- `workflow/team-protocol.md` — 팀 프로토콜
- `workflow/mx-tag-protocol.md` — MX 태그 프로토콜

### Templates
- `templates/zec-config/sections/` — 기본 설정 YAML 템플릿

## Installation

```bash
# Claude Code 프로젝트에서 플러그인 추가
claude plugin add lemonbalms/zec-toolkit
```

## License

MIT
