---
name: learning-commit
description: Commits a finished learning session to the concept map and learning log. Reads the session scratch file, judges each candidate against strict promotion rules, proposes every write as a diff, and writes only after the learner confirms. Use only when explicitly invoked as /learning-commit.
disable-model-invocation: true
---

# /learning-commit — the only writer

This is the **only** skill that edits `concept-map.md` and `learning-log.md`. `/learning-session` is read-only by design, so nothing reaches these files without the learner seeing it first.

## Setup

Three files, in a knowledge base directory that defaults to `~/knowledge base/`. Change the path here if yours differs — nothing else in this skill hardcodes it.

| file | role |
|---|---|
| `session-candidates.md` | scratch buffer written by `/learning-session` |
| `concept-map.md` | depths + prerequisites |
| `learning-log.md` | prose entries |

Resolve `~` to the home directory before reading — file tools need an absolute path.

## Step 1: Read the evidence

Read, in order:

1. `session-candidates.md` — **the source of truth**, not the conversation. Long sessions get compacted and the transcript may be lossy.
2. `concept-map.md` — current depths and edges.
3. Only the `learning-log.md` sections named in the scratch file. Never the whole file.

If the scratch file is empty or missing, say so and stop. Do not reconstruct a session from memory.

## Step 2: Judge each candidate against the promotion rules

These rules are the point of the skill. Apply them strictly — the failure mode is optimistic promotion, and a wrong depth is worse than a missing one because it makes the next session calibrate confidently wrong.

| rule | test |
|---|---|
| **Playback required** | Promote only if the scratch line records the concept explained back in the learner's own words. "Covered it" or "they nodded" is not evidence. |
| **One level per session** | `— → @model`, or `@model → @read`. Never `— → @read` in a single session. |
| **Evidence must match the tag** | `@read` needs recognition in real code. `@write` needs using or debugging it. An analogy that landed is `@model`, nothing more. |
| **Demote on mismatch** | A `MISMATCH` line means the map was wrong. Lower the tag. Demotion needs no playback — doubt is sufficient evidence. |

When evidence is ambiguous, hold the current depth and say why. Not promoting costs one session. Over-promoting silently corrupts every future calibration.

## Step 3: Propose the diff — never write first

Show every change as a diff, grouped by file, with the evidence line beside each. Then stop and wait.

```
concept-map.md
  + middleware        @read    ← functions, express-routes
      "a chain where each link can stop it" — playback correct
  ~ event-loop        @model → @model  (HOLD)
      recognized in app.ts:14, no playback — not enough for @read
  ~ async-await       @read  → @model  (DEMOTE)
      MISMATCH: asked what await does

learning-log.md
  + ## Middleware · the chain framing  (12 lines, under existing "Middleware")
```

Number them so they can be rejected individually: "commit 1 and 3, skip 2."

## Step 4: Write what is confirmed

**Concept map** — one line per concept, kept in the existing group:

```
middleware   @read   ← functions, express-routes
```

- Add `←` prerequisites for every new concept. A concept with no edges is invisible to the frontier calculation and defeats the map's purpose.
- Prerequisites are what the *explanation actually leaned on* this session — not everything conceptually related.
- Never store reverse edges (`unlocks`). They're derivable and drift.
- Keep it short. This file is read in full every session; that only stays cheap if it stays small.

**Learning log** — prose, conservative:

- Log only what solidified. Not the running content, not the Q&A transcript.
- **Distill into returnable reference.** The learner should re-find the concept in seconds, months later. Write for the person coming back cold, not the person who just had the conversation.
- Tone: short sentences. Concrete over abstract — tables and named examples beat prose. No hedging ("it can sometimes be"); state the rule, then state the exception.
- **Update the existing section, don't append a duplicate.** If a concept was re-taught with a sharper framing, replace the old framing.
- File under the existing topic heading. Date inline: `· _YYYY-MM-DD_`.
- Record the *framing that landed* — the analogy, the sentence that clicked. That's what the log is for; depths live in the map.
- Preserve the learner's own edits. Never overwrite anything they wrote.

**Session log** — one bullet per concept at the bottom, chronological, brief.

**Open questions** — add anything the scratch file marked as parked.

## Step 5: Clear the scratch

Empty `session-candidates.md` after a successful write, leaving only its header. Anything rejected in Step 3 stays in the file — it's still an open candidate for next session, not a decision.

Report what was written in one line. Do not re-teach anything.
