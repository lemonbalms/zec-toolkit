# FastAPI Backend Guidelines Skill

## Overview

FastAPI 백엔드 개발을 위한 아키텍처 패턴과 베스트 프랙티스를 제공하는 스킬입니다.

- **FastAPI** (async Python framework)
- **SQLModel + SQLAlchemy** (ORM)
- **PostgreSQL** with asyncpg
- **Domain-Driven Design** architecture
- **Layered Architecture** (Router → Service → Repository)

## What This Skill Covers

1. **Layered Architecture** — Router → Service → Repository 계층 구조
2. **API Routes & Routers** — FastAPI 라우터, dependency injection
3. **Database & ORM** — SQLModel 모델, async 쿼리, 세션 관리
4. **Domain-Driven Design** — 도메인 중심 구조 설계
5. **Service Layer** — 비즈니스 로직 분리, 오케스트레이션
6. **Repository Pattern** — 데이터 접근 계층, BaseRepository
7. **DTOs & Validation** — Pydantic DTO, 요청/응답 검증
8. **Async/Await Patterns** — 비동기 패턴, asyncio.gather 병렬 쿼리
9. **Error Handling** — 커스텀 예외, 미들웨어 에러 처리
10. **Complete Examples** — 전체 CRUD 도메인 구현 예제

## Architecture Patterns

### Prefixed ULID (Stripe-style Entity IDs)
엔티티별 접두사를 붙인 ULID 기반 식별자 생성. Stripe가 `cus_`, `sub_` 등으로 대중화한 방식.
```python
from ulid import ULID

def generate_user_id() -> str:
    return f"usr_{ULID()}"  # usr_01HQ5K3NXYZ...
```

### CQRS — Read/Write Session Separation
읽기와 쓰기 세션을 분리하여 Read Replica 라우팅을 지원하는 CQRS 패턴.
```python
# Read operations (GET)
@router.get("/{user_id}")
async def get_user(
    session: AsyncSession = Depends(get_read_session_dependency),
): ...

# Write operations (POST/PATCH/DELETE)
@router.post("")
async def create_user(
    session: AsyncSession = Depends(get_write_session_dependency),
): ...
```

### DataLoader Pattern — N+1 Query Prevention
Facebook이 GraphQL용으로 설계한 DataLoader 패턴을 활용한 N+1 쿼리 방지.
```python
user_with_relations = await self._data_loader.load_user_with_relations(
    user_id,
    load_profile=True,
    load_photos=True,
)
```

### Field-level Validator (Pydantic v2)
Pydantic v2의 `field_validator`를 활용한 DTO 입력 검증.
```python
class StatusUpdateRequest(BaseModel):
    status: Optional[str] = Field(None)
    model_config = {"extra": "forbid"}

    @field_validator("status")
    @classmethod
    def validate_status(cls, v: Optional[str]) -> Optional[str]:
        if v is not None:
            valid_values = [e.value for e in StatusEnum]
            if v not in valid_values:
                raise ValueError(f"Invalid: {v}")
        return v
```

### Soft Delete (Logical Delete)
물리 삭제 대신 `deleted_at` 타임스탬프 기반의 논리 삭제.

## Skill Activation

### Prompt Triggers
- Keywords: "backend", "FastAPI", "service", "repository", "router", "async", "SQLModel", "domain", "dto"

### Enforcement
- **Type**: Domain (suggests, doesn't block)
- **Priority**: High

## Files

```
.claude/skills/harness-fastapi/
  ├── skill.md                              # 스킬 개요
  ├── README.md                             # 이 문서
  └── resources/
      ├── layered-architecture.md           # Router → Service → Repository
      ├── api-routes.md                     # FastAPI 라우터 & 엔드포인트
      ├── database-orm.md                   # SQLModel 쿼리 & 모델
      ├── domain-driven-design.md           # 도메인 구조 설계
      ├── service-layer.md                  # 비즈니스 로직 계층
      ├── repository-pattern.md             # 데이터 접근 계층
      ├── dtos-validation.md                # Pydantic DTO
      ├── async-patterns.md                 # Async/await 패턴
      ├── error-handling.md                 # 커스텀 예외 처리
      └── complete-examples.md              # 전체 CRUD 구현 예제
```

## Core Principles

| # | 원칙 | 패턴 명칭 |
|---|------|-----------|
| 1 | 계층 우회 금지 (Router → Service → Repository) | **Layered Architecture** |
| 2 | 도메인 중심 구조 설계 | **Domain-Driven Design (DDD)** |
| 3 | 전 구간 비동기 처리 | **Async/Await** |
| 4 | 데이터 접근은 반드시 Repository 경유 | **Repository Pattern** |
| 5 | 비즈니스 로직은 Service에 집중 | **Service Layer Pattern** |
| 6 | API 입출력에 DTO 사용 | **DTO (Data Transfer Object)** |
| 7 | 모든 함수에 타입 힌트 명시 | **Type Hints** |
| 8 | 커스텀 예외를 HTTP 상태로 매핑 | **Exception Mapping** |
| 9 | 읽기/쓰기 세션 분리 | **CQRS / Read Replica Routing** |
| 10 | FastAPI Depends() 활용 | **Dependency Injection** |
| 11 | 엔티티 접두사 식별자 | **Prefixed ULID** |
| 12 | 논리 삭제 (deleted_at) | **Soft Delete** |
| 13 | 관계 로딩 시 N+1 방지 | **DataLoader Pattern** |

---

**Updated**: 2026-03-15
