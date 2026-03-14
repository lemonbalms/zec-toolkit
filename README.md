# zec-toolkit

ZEC Development Toolkit — Claude Code plugin for unified development orchestration.

## Overview

`zec-toolkit`는 [MoAI-ADK](https://github.com/modu-ai/moai-adk)를 기반으로 만든 개인용 Claude Code 플러그인입니다. MoAI-ADK의 에이전트 오케스트레이션, 스킬 시스템, 품질 게이트 등 실제로 자주 쓰는 기능만 추려서 가볍게 재구성했고, 다른 플러그인(oh-my-claudecode 등)과 충돌 없이 함께 사용할 수 있도록 네이밍과 구조를 분리했습니다.

개인 워크플로우에 맞춰 커스터마이징한 설정이므로, 범용 사용보다는 개인 프로젝트 간 일관된 개발 환경을 유지하는 데 목적이 있습니다.

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
