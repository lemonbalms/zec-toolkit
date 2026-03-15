---
name: cancel
description: >
  Cancel all active execution modes (ralph, ultrawork, autopilot).
  Clears state files and allows conversation to stop normally.
user-invocable: true
metadata:
  version: "1.0.0"
  category: "utility"
  status: "active"
---

# Cancel

Terminate all active execution modes.

## Behavior

When invoked:
1. Remove `.zec/state/ralph.json` if exists
2. Remove `.zec/state/ultrawork.json` if exists
3. Remove `.zec/state/autopilot.json` if exists
4. Report which modes were cancelled

## Usage

```
/cancel
```

Or say: "stop", "cancel", "abort"

## Implementation

Run these commands via Bash:
```bash
rm -f .zec/state/ralph.json .zec/state/ultrawork.json .zec/state/autopilot.json
```

Then report: "All execution modes terminated."
