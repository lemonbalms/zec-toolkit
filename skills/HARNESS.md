# Harness Skills Catalog

출처: https://github.com/lemonbalms/claude-code-harness
적용일: 2026-03-15

## 현재 프로젝트 활용

| 스킬 | 디렉터리 | 용도 | 보강 대상 |
|------|----------|------|-----------|
| harness-fastapi | `harness-fastapi/` | FastAPI DDD, 라우터/서비스/리포지토리 패턴 | backend 에이전트 |
| harness-pytest | `harness-pytest/` | pytest 테스팅 가이드 (TestClient, fixture, 커버리지) | tester 에이전트 |
| harness-web-design | `harness-web-design/` | 웹 접근성(WCAG), UX 가이드라인 | quality 에이전트 |
| harness-frontend-design | `harness-frontend-design/` | UI 디자인 품질, 프로덕션급 인터페이스 | frontend 에이전트 |
| harness-mermaid | `harness-mermaid/` | Mermaid 다이어그램 생성 (18+ 타입) | docs 에이전트 |
| harness-pdf | `harness-pdf/` | PDF 생성/편집/추출 | 리포트 출력 시 |

## 향후 통합 대비 (Next.js 프로젝트)

| 스킬 | 디렉터리 | 용도 | 비고 |
|------|----------|------|------|
| harness-nextjs | `harness-nextjs/` | Next.js 15 App Router, Server/Client Components | 현재 미사용 |
| harness-react-perf | `harness-react-perf/` | React 성능 최적화 (Vercel 엔지니어링 기준) | 현재 미사용 |

## 커스텀 변경 이력

- harness-fastapi: 원본 그대로 (동기 SQLAlchemy 사용 시 async 패턴 참고용으로만 활용)
- harness-nextjs: YGS(영영사) 특화 내용 포함 — 범용 사용 시 프로젝트별 커스텀 필요

## 사용 방법

harness 스킬은 기존 zec/omc 에이전트가 자동으로 참조합니다.
직접 호출: `/harness-fastapi`, `/harness-pytest` 등 슬래시 커맨드로도 사용 가능.
