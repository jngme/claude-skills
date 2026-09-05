---
name: learning-commit
description: Commits a finished learning session to the concept files, the reference map and the student model. Reads the lesson document rather than the transcript, judges each candidate, shows the map diff, proposes every write as a numbered diff, and writes only after the learner confirms. Use only when explicitly invoked as /learning-commit.
disable-model-invocation: true
---

# /learning-commit — the only writer

The only thing permitted to edit `model.md`, `ai/concepts/`, `ai/maps/` and `maps/`. `/learning-session` writes the lesson document and nothing else, so no judgement reaches these files without the learner seeing it first.

## Config

```
VAULT   = ~/knowledge base
LESSONS = $VAULT/ai/lessons
```

| path | role |
|---|---|
| `$LESSONS/<topic>.md` | the lesson document — **the source of truth** |
| `$VAULT/ai/model.md` | position + open gaps |
| `$VAULT/ai/concepts/` | one file per concept |
| `$VAULT/ai/maps/` | reference territory per domain |
| `$VAULT/maps/<domain>/<date>.md` | the learner's own map snapshot |

## Step 1 — Read the evidence

In order:

1. The lesson document's `## Candidates` block. **This, not the conversation.** Long sessions get compacted and the transcript is lossy; the file is not.
2. `$VAULT/ai/model.md`.
3. Only the concept files named in the candidates.

If there is no candidates block, say so and stop. Do not reconstruct a session from memory.

## Step 2 — Judge each candidate

Two rules. The old ladder rules ("one level per session", "evidence must match the tag") are gone with the ladder.

| rule | test |
|---|---|
| **Playback required** | Add to `holds` only if the line records the concept explained back in the learner's own words. "Covered it" is not evidence. |
| **Contradictions win** | A `MISMATCH` line means the model was wrong. Record the gap. Doubt needs no playback. |

A gap is cleared only by a playback that contradicts it. Nothing else clears a gap.

When evidence is ambiguous, hold and say why. Not recording costs one session. Recording something false corrupts every future one.

## Step 3 — Render the map diff

**This is the screen the learner sees.** Show what moved on the map, not a list of file writes. Reviewing it is retrieval practice and it is the last piece of learning in the session.

```
robot-subgoals

  subgoal ──── terminal-state ──── episode-horizon
                        │
                  credit-assignment      gap cleared
                        │
                  reward-shaping         NEW gap: conflated with horizon

  still blank:  discount-factor · bootstrapping
```

Mark: what gained a `holds` line, what gap cleared, what gap is new, what is still untaught.

## Step 4 — Propose every write as a diff

Grouped by file, evidence beside each, numbered so they can be rejected individually. Then stop and wait.

```
ai/concepts/terminal-state.md
  1 + holds: "the episode ends so there's no more reward to collect"

ai/concepts/reward-shaping.md
  2 + gap: conflates shaping with horizon length. It addresses sparsity.

ai/maps/robot-subgoals.md
  3 ~ add edge terminal-state → episode-horizon

maps/robot-subgoals/2026-09-08.md
  4 + new snapshot, transcribed verbatim
```

Nothing is written before confirmation.

## Step 5 — Write what is confirmed

**Concept files** — `$VAULT/ai/concepts/<name>.md`, one per concept:

```markdown
---
type: concept
domain: <domain>
updated: YYYY-MM-DD
---
# <name>

## holds
- <their own words> — _YYYY-MM-DD, how it was demonstrated._

## gaps
- <the specific wrong belief>. <the correction>.

## relations
- needs [[x]]
- enables [[y]]

## taught by
- [[<lesson>]]
```

- `holds` lines are the learner's phrasing, dated, never rewritten. Add, never replace.
- `gaps` are named beliefs with corrections. No ratings, no depth tags.
- `relations` are what the explanation actually leaned on, not everything related.
- `taught by` links the lesson. This is how a future session re-shows the original for recall.

**Reference map** — `$VAULT/ai/maps/<domain>.md`. One living file, corrected in place. It references concepts, never contains them. Keep the mermaid block current: solid edges taught, dotted edges untaught. Maps may reference other maps; that is how altitude works.

**Learner's snapshot** — `$VAULT/maps/<domain>/<YYYY-MM-DD>.md`. A new dated file each time, **never edited**. Transcribed verbatim including errors. The series is the only direct record of understanding changing.

**Student model** — `$VAULT/ai/model.md`. Update the position row for this domain and the open-gaps list. Always current; git holds the history.

## Step 6 — Clear and commit

- Remove the `## Candidates` block from the lesson document, leaving the lesson itself. Anything rejected in step 4 stays in the block as an open candidate.
- `git add ai/ maps/ && git commit` inside the vault. Commit only `ai/` and `maps/`; leave the learner's own folders for them.
- Report what was written in one line. Do not re-teach anything.

## Generating HTML

On request only: render a lesson to `$LESSONS/html/<topic>.html` from the markdown. It is derived and disposable. Regenerate it rather than editing it, and never treat it as the record.
