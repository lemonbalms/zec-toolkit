---
name: zec-tool-ast-grep
description: >
  AST-grep (sg CLI) reference for structural code search, transformation,
  security scanning, and bulk API migrations. Covers pattern syntax, rule
  configuration, sg CLI command flags, and the MCP tools ast_grep_search /
  ast_grep_replace provided by the OMC plugin.
  Use when performing codemod, AST-level search, refactoring across files,
  vulnerability pattern detection, or bulk rename / API migration tasks.
license: Apache-2.0
compatibility: Designed for Claude Code with OMC plugin (ast_grep_search, ast_grep_replace)
allowed-tools: Read, Grep, Glob, Bash
user-invocable: false
metadata:
  version: "1.0.0"
  category: "tool"
  status: "active"
  updated: "2026-03-15"
  modularized: "false"
  tags: "ast-grep, sg, codemod, refactoring, security, structural-search, api-migration"
  related-skills: "zec-foundation-quality, zec-workflow-ddd"
  agents: "expert-backend, expert-frontend, expert-debug, expert-testing, expert-refactoring, expert-security, manager-ddd, manager-quality"

# ZEC Extension: Progressive Disclosure
progressive_disclosure:
  enabled: true
  level1_tokens: 120
  level2_tokens: 4800

# ZEC Extension: Triggers
triggers:
  keywords: ["ast-grep", "sg", "codemod", "structural search", "ast search", "bulk rename", "api migration", "refactor", "security scan", "vulnerability pattern"]
  agents: ["expert-backend", "expert-frontend", "expert-debug", "expert-testing", "expert-refactoring", "expert-security", "manager-ddd", "manager-quality"]
  phases: ["run", "review"]
---

# AST-Grep Tool Reference

AST-grep (`sg`) performs structural code search and transformation at the syntax tree level — immune to irrelevant whitespace, comments, and variable name variations. The OMC plugin exposes `ast_grep_search` and `ast_grep_replace` as MCP tools for in-conversation use.

---

## Quick Reference

### Tool Selection

| Situation | Use |
|-----------|-----|
| Interactive exploration / preview | `sg` CLI via Bash |
| In-conversation search | `ast_grep_search` MCP tool |
| In-conversation replacement | `ast_grep_replace` MCP tool |
| Rule-based security scan | `sg scan --config sgconfig.yml` |
| Bulk codemod across repo | `sg run --update-all` |

### Pattern Metavariables

| Syntax | Matches |
|--------|---------|
| `$VAR` | Exactly one AST node (expression, identifier, type…) |
| `$$$ARGS` | Zero or more nodes (argument lists, statement sequences) |
| `$$_` | One anonymous node (unnamed in the grammar) |
| `$_` | One anonymous or named node (wildcard) |

### Supported Languages (`--lang`)

`python`, `typescript`, `javascript`, `tsx`, `jsx`, `rust`, `go`, `java`, `c`, `cpp`, `css`, `html`

---

## MCP Tools (OMC Plugin)

These tools run directly in Claude's context without a Bash call.

### `ast_grep_search`

Search for a structural pattern in a directory.

```
ast_grep_search(
  pattern   = "console.log($$$ARGS)",
  language  = "typescript",
  path      = "src/"
)
```

Returns: list of matches with file, line, column, and matched source text.

### `ast_grep_replace`

Replace a structural pattern across files. Always preview first.

```
ast_grep_replace(
  pattern     = "console.log($$$ARGS)",
  replacement = "logger.debug($$$ARGS)",
  language    = "typescript",
  path        = "src/",
  dry_run     = true      # set false only after reviewing preview
)
```

Returns: diff preview (dry_run=true) or list of modified files (dry_run=false).

---

## sg CLI Reference

### Core Commands

```bash
# Search — print all matches
sg run --pattern 'PATTERN' --lang LANG PATH

# Transform — preview changes interactively
sg run --pattern 'OLD' --rewrite 'NEW' --lang LANG PATH --interactive

# Transform — apply all without prompting
sg run --pattern 'OLD' --rewrite 'NEW' --lang LANG PATH --update-all

# Scan with rule file(s)
sg scan --config sgconfig.yml

# Scan and emit JSON (for CI / agent parsing)
sg scan --config sgconfig.yml --json

# Test rules defined in a rules directory
sg test

# Output as JSON (search)
sg run --pattern 'PATTERN' --lang LANG PATH --json
```

### Useful Flags

| Flag | Purpose |
|------|---------|
| `--lang LANG` | Target language (required) |
| `--pattern 'P'` | Inline pattern |
| `--rewrite 'R'` | Replacement template (uses captured metavariables) |
| `--interactive` | Review each match before applying |
| `--update-all` | Apply all replacements without prompting |
| `--json` | Machine-readable output |
| `--follow-links` | Follow symlinks |
| `--no-ignore` | Search ignored files (overrides .gitignore) |
| `-A N` / `-B N` | Context lines after / before match |

---

## Implementation Guide

### 1. Structural Code Search

Find all call sites of a function regardless of formatting or inline comments:

```bash
# Python: find all calls to deprecated_fn with any arguments
sg run --pattern 'deprecated_fn($$$ARGS)' --lang python src/

# TypeScript: find object property access chains
sg run --pattern '$OBJ.oldProperty' --lang typescript src/

# Find try/except blocks missing a specific exception type
sg run --pattern 'try: $$$BODY except: $$$HANDLER' --lang python src/
```

With MCP:
```
ast_grep_search(pattern="deprecated_fn($$$ARGS)", language="python", path="src/")
```

### 2. Code Transformation / Refactoring

Always follow the preview-then-apply sequence:

```bash
# Step 1: Count matches
sg run --pattern 'oldApi($ARGS)' --lang typescript src/ --json | jq length

# Step 2: Preview diffs interactively
sg run --pattern 'oldApi($ARGS)' --rewrite 'newApi($ARGS)' \
   --lang typescript src/ --interactive

# Step 3: Apply after review
sg run --pattern 'oldApi($ARGS)' --rewrite 'newApi($ARGS)' \
   --lang typescript src/ --update-all
```

Common transformation patterns:

```bash
# Rename function across entire codebase
sg run --pattern 'getUserById($ID)' \
       --rewrite 'fetchUserById($ID)' \
       --lang typescript src/ --update-all

# Modernize: var -> const (where there is no reassignment signal in pattern)
sg run --pattern 'var $NAME = $VALUE' \
       --rewrite 'const $NAME = $VALUE' \
       --lang javascript src/ --interactive

# Wrap bare await with error handler
sg run --pattern 'await $EXPR' \
       --rewrite 'await withErrorBoundary(() => $EXPR)' \
       --lang typescript src/ --interactive

# Python: replace print() with logger.info()
sg run --pattern 'print($$$ARGS)' \
       --rewrite 'logger.info($$$ARGS)' \
       --lang python src/ --interactive
```

### 3. Security Scanning

Use rule files for repeatable, team-shared vulnerability detection.

#### Rule File Format (`rules/sql-injection.yml`)

```yaml
id: sql-injection-fstring
language: python
severity: error
message: "Possible SQL injection: f-string interpolation in query"
rule:
  pattern: 'cursor.execute(f"$$$QUERY")'
note: "Use parameterized queries: cursor.execute(query, params)"
```

```yaml
id: hardcoded-secret
language: python
severity: error
message: "Hardcoded secret or credential detected"
rule:
  any:
    - pattern: '$VAR = "$SECRET"'
    - pattern: 'password = "$VAL"'
    - pattern: 'api_key = "$VAL"'
```

```yaml
id: xss-innerhtml
language: typescript
severity: error
message: "Direct innerHTML assignment — potential XSS vector"
rule:
  pattern: '$EL.innerHTML = $VAL'
note: "Use textContent or a sanitization library instead"
```

#### Config File (`sgconfig.yml`)

```yaml
ruleDirs:
  - rules/
```

#### Running a Security Scan

```bash
# Scan entire project
sg scan --config .claude/skills/zec-tool-ast-grep/rules/sgconfig.yml

# JSON output for CI integration
sg scan --config .claude/skills/zec-tool-ast-grep/rules/sgconfig.yml --json

# Scan specific directory only
sg scan --config sgconfig.yml src/auth/
```

The expert-security agent references this config path:
`.claude/skills/zec-tool-ast-grep/rules/sgconfig.yml`

### 4. Bulk Rename and API Migration

Systematic workflow for library/API version upgrades:

**Phase 1 — Inventory**
```bash
# Count all usages before starting
sg run --pattern 'oldLib.$METHOD($$$ARGS)' --lang typescript src/ --json \
  | jq '[.[] | .file] | unique | length'
```

**Phase 2 — Simple renames (1-to-1 mapping)**
```bash
sg run --pattern 'import { $NAME } from "old-library"' \
       --rewrite 'import { $NAME } from "new-library"' \
       --lang typescript src/ --update-all
```

**Phase 3 — Signature changes (review each)**
```bash
# Old: connect(host, port, callback)
# New: connect({ host, port }).then(callback)
sg run --pattern 'connect($HOST, $PORT, $CB)' \
       --rewrite 'connect({ host: $HOST, port: $PORT }).then($CB)' \
       --lang javascript src/ --interactive
```

**Phase 4 — Verify**
```bash
# Confirm no old patterns remain
sg run --pattern 'oldLib.$$$' --lang typescript src/ --json | jq length
# Expect: 0
```

---

## Advanced Patterns

### Composite Rules (sgconfig)

Match patterns that satisfy multiple conditions simultaneously:

```yaml
id: unsafe-deserialize
language: python
severity: error
message: "pickle.loads with untrusted input — RCE risk (CWE-502)"
rule:
  all:
    - pattern: 'pickle.loads($DATA)'
    - not:
        pattern: 'pickle.loads(TRUSTED_$DATA)'
```

### Inside / Has Constraints

```yaml
id: async-without-await
language: typescript
severity: warning
message: "async function body contains no await"
rule:
  pattern: 'async function $NAME($$$PARAMS) { $$$BODY }'
  not:
    has:
      pattern: 'await $$$'
```

### Multi-Language Scan

Run separate sg invocations per language or use a CI script:

```bash
for lang in python typescript javascript; do
  sg scan --config sgconfig.yml --lang "$lang" --json >> scan-results.json
done
```

---

## Integration with ZEC Agents

| Agent | Primary ast-grep Usage |
|-------|------------------------|
| expert-refactoring | Pattern search → preview → `--update-all` for codemods |
| expert-security | `sg scan --config sgconfig.yml --json` for vulnerability detection |
| expert-backend | Structural search before modifying API call sites |
| expert-frontend | XSS / DOM pattern detection; component rename migrations |
| expert-debug | Locate all call sites of a suspect function |
| expert-testing | Find untested function patterns; locate test gaps structurally |
| manager-ddd | Verify pattern conformance after DDD implementation cycle |
| manager-quality | Post-implementation structural lint using rule files |

---

## Safety Rules

[HARD] Always run with `--interactive` or `dry_run=true` before `--update-all` / `dry_run=false`.
WHY: Metavariable patterns can match more broadly than expected; preview prevents silent mass corruption.

[HARD] Run tests after every `--update-all` transformation.
WHY: Structural equivalence does not guarantee semantic equivalence in all edge cases.

[SOFT] Commit or stash before running `--update-all` on more than 10 files.
WHY: Provides a clean rollback point if the transformation produces unexpected results.

---

## Works Well With

- `zec-foundation-quality`: Quality gates to run after bulk transformations
- `zec-workflow-ddd`: DDD cycle that uses ast-grep for conformance checks
- `expert-refactoring`: Primary consumer of this skill for all codemod work
- `expert-security`: Uses rule files from this skill's `rules/` directory
