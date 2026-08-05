# Concept map

Read by `/learning-session` at the start of every session. Written only by `/learning-commit`.

Keep this file small. It is loaded in full every session; `learning-log.md` is not.

It records what has been **probed**, not what has been covered. A concept from an old note belongs here only once a probe confirms the depth.

## Format

```
concept-name   @depth   ← prerequisite, prerequisite
```

| state | means | what a session does |
|---|---|---|
| `@write` | mastery — uses it, debugs it, builds with it | lean on it freely |
| `@read` | reading fluency — recognizes it in real code | lean on it freely |
| `@model` | mental model — explains it by analogy | use only the analogy-level version |
| `—` | probed, found untaught | hard stop; teach before using |
| **absent** | never probed — depth unknown | **probe it** (`/learning-session` Step 2) |

**`—` and absent are different states.** `—` is a finding. Absent is a gap in the map. Never treat an absent concept as `—`; probe it instead, or an empty map blocks every explanation.

- `←` reads **requires**.
- Reverse edges (`unlocks`) are derivable. Never store them.
- **Frontier** = concepts tagged `—` whose prerequisites are all `@read` or better. Those are worth teaching next.

## Concepts

Shared foundations. Nothing probed yet.

## project: example

Add one group per codebase. Concepts that only make sense inside one project live here; shared foundations stay above.
