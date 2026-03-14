# FastAPI Backend Guidelines Skill

## Overview

A skill providing architecture patterns and best practices for FastAPI backend development.

- **FastAPI** (async Python framework)
- **SQLModel + SQLAlchemy** (ORM)
- **PostgreSQL** with asyncpg
- **Domain-Driven Design** architecture
- **Layered Architecture** (Router → Service → Repository)

## What This Skill Covers

1. **Layered Architecture** — Router → Service → Repository layer structure
2. **API Routes & Routers** — FastAPI routers, dependency injection
3. **Database & ORM** — SQLModel models, async queries, session management
4. **Domain-Driven Design** — Domain-centric project organization
5. **Service Layer** — Business logic separation, orchestration
6. **Repository Pattern** — Data access layer, BaseRepository
7. **DTOs & Validation** — Pydantic DTOs, request/response validation
8. **Async/Await Patterns** — Async patterns, asyncio.gather for parallel queries
9. **Error Handling** — Custom exceptions, middleware error handling
10. **Complete Examples** — Full CRUD domain implementation examples

## Architecture Patterns

### Prefixed ULID (Stripe-style Entity IDs)
ULID-based identifiers with entity-specific prefixes. Popularized by Stripe with `cus_`, `sub_`, etc.
```python
from ulid import ULID

def generate_user_id() -> str:
    return f"usr_{ULID()}"  # usr_01HQ5K3NXYZ...
```

### CQRS — Read/Write Session Separation
Separates read and write sessions to support Read Replica routing via the CQRS pattern.
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
Prevents N+1 queries using the DataLoader pattern, originally designed by Facebook for GraphQL.
```python
user_with_relations = await self._data_loader.load_user_with_relations(
    user_id,
    load_profile=True,
    load_photos=True,
)
```

### Field-level Validator (Pydantic v2)
DTO input validation using Pydantic v2's `field_validator`.
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
Logical deletion via `deleted_at` timestamp instead of physical row removal.

## Skill Activation

### Prompt Triggers
- Keywords: "backend", "FastAPI", "service", "repository", "router", "async", "SQLModel", "domain", "dto"

### Enforcement
- **Type**: Domain (suggests, doesn't block)
- **Priority**: High

## Files

```
.claude/skills/harness-fastapi/
  ├── skill.md                              # Skill overview
  ├── README.md                             # This document
  └── resources/
      ├── layered-architecture.md           # Router → Service → Repository
      ├── api-routes.md                     # FastAPI routers & endpoints
      ├── database-orm.md                   # SQLModel queries & models
      ├── domain-driven-design.md           # Domain organization
      ├── service-layer.md                  # Business logic layer
      ├── repository-pattern.md             # Data access layer
      ├── dtos-validation.md                # Pydantic DTOs
      ├── async-patterns.md                 # Async/await patterns
      ├── error-handling.md                 # Custom exception handling
      └── complete-examples.md              # Full CRUD implementation
```

## Core Principles

| # | Principle | Pattern |
|---|-----------|---------|
| 1 | Never bypass layers (Router → Service → Repository) | **Layered Architecture** |
| 2 | Organize by domain, not by type | **Domain-Driven Design (DDD)** |
| 3 | Use async/await throughout the stack | **Async/Await** |
| 4 | All data access through repositories | **Repository Pattern** |
| 5 | Business logic belongs in services, not routers | **Service Layer Pattern** |
| 6 | Use DTOs for API input/output | **DTO (Data Transfer Object)** |
| 7 | Explicit type hints on all functions | **Type Hints** |
| 8 | Map custom exceptions to HTTP status codes | **Exception Mapping** |
| 9 | Separate read/write sessions | **CQRS / Read Replica Routing** |
| 10 | Use FastAPI Depends() for injection | **Dependency Injection** |
| 11 | Entity-prefixed identifiers | **Prefixed ULID** |
| 12 | Logical deletion via deleted_at | **Soft Delete** |
| 13 | Prevent N+1 on relation loading | **DataLoader Pattern** |

---

**Updated**: 2026-03-15
