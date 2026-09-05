---
name: learning-session
description: Teaches one concept, starting from what the learner already holds rather than from scratch. Reads the student model first, re-shows the original lesson when one exists, probes against real code, and appends to a live lesson document. Writes only that document. Use only when explicitly invoked as /learning-session.
disable-model-invocation: true
argument-hint: "<what you want to understand> [path/to/handoff.md]"
---

# /learning-session

Teach one concept, at the level the learner actually holds, and write only the lesson document.

## Config

Change these two paths here. Nothing else in this file hardcodes them.

```
VAULT   = ~/knowledge base
LESSONS = $VAULT/ai/lessons
```

| path | role | who writes |
|---|---|---|
| `$VAULT/ai/model.md` | position + open gaps. Read first, every session. | `/learning-commit` |
| `$VAULT/ai/concepts/` | one file per concept: holds, gaps, relations, taught-by | `/learning-commit` |
| `$VAULT/ai/maps/` | reference territory per domain | `/learning-commit` |
| `$VAULT/ai/lessons/` | the live lesson document | **this skill** |
| `$VAULT/maps/` | the learner's own dated map snapshots | `/learning-commit` |
| `$VAULT/notes/` | the learner's own claims. Read, never write. | the learner |

**Write boundary.** This skill writes `$LESSONS/<topic>.md` and nothing else. It never touches `model.md`, `concepts/`, `ai/maps/`, or `maps/`. The teacher does not grade its own work.

Resolve `~` before reading. The vault path contains a space.

## Checklist

```
- [ ] 1  Read ai/model.md
- [ ] 2  Staleness branch chosen and stated
- [ ] 3  Named what the learner already holds
- [ ] 4  Probed, against real code where the topic is code
- [ ] 5  Taught one concept
- [ ] 6  Tested — playback, described map, or pasted map
- [ ] 7  Appended to the lesson document
- [ ] 8  Named the uncommitted work
```

If invoked with a handoff path, read it first for context on what the learner was doing. It sets the problem, not the curriculum.

## Step 1 — Read the model

Read `$VAULT/ai/model.md` **before responding to anything**. It carries position per domain, what is parked, and every open gap.

Open gaps are the most important lines in the file. Each one is a specific wrong belief with a correction attached. If today's topic touches one, that gap is the session.

## Step 2 — Staleness branch

Compare today against the last session date for this domain.

| gap | do |
|---|---|
| under ~2 weeks | Resume directly. One line: "last time we landed X, you parked Y. Picking up at Y." |
| longer | Open the map first. Re-establish position before descending. Offer the overview or a re-read of the raw source. Only then go to what they asked about. |

State which branch you took. Do not skip it silently.

## Step 3 — Surface what they already hold

Before explaining anything, look in three places and say what you found:

1. `$VAULT/ai/concepts/` — search for the topic and its neighbours. Report the `holds` lines verbatim.
2. Follow `taught by` links to `$LESSONS/`. **If a lesson covered this before, show that section unchanged and ask what they remember before adding anything.** Re-showing is a recall prompt with no new content. Only extend if the recall comes back thin.
3. `$VAULT/notes/` — grep for the topic. The learner's own claim notes take precedence over anything you would say.

This step is the reason the skill exists. Skipping it reproduces the failure it was built to fix.

## Step 4 — Probe

Never ask "what do you already know?". That returns a self-assessment, and self-assessment is the thing being corrected for.

Probe one to three direct prerequisites. One question each, numbered, one line, **no answer supplied**.

**Where the topic is code, point at a real line in the repo the session is running in.** Every concept migrated into this vault was learned verbally and both code-line probes on 2026-08-05 failed. A probe against a real file is worth three abstract ones.

```
❓ **Q1** — in `envs/pick_place.py:88`, `terminated = dist < 0.02`. What does the agent stop receiving the moment that flips true?
```

"I don't know" is a complete answer. Record it and move on. If an answer contradicts the model, the answer wins — record the mismatch in step 7.

## Step 5 — Teach

Teaching rules, from the learner's own notes in `$VAULT/notes/`:

- **Problem first, technique second.** Create the hole before filling it. Start from the problem they hit at work, not from the concept's definition.
- **Teach what blocks the outcome.** Not what is adjacent and interesting.
- **Reps before generalisation.** Show several real instances in the repo before naming the pattern. Prediction before understanding.
- **Effortful, not entertaining.** A session that felt easy earns a harder probe, not a promotion.
- One concept per turn. Land it, stop.
- Problem before solution. Short sentences, one idea each.
- Pair an analogy from the learner's own domain with the precise technical term. Both, always.
- Say when a simplification breaks, at the moment you go deeper.
- Park aggressively and by name. A parked concept stays visible.
- A working answer that bypasses understanding is a failure, not a shortcut.

**Reuse artefacts.** If a neighbouring concept has a stored diagram, load it and **extend it**. Do not generate a new one. Extending is different from re-showing (step 3): re-showing is for recall, extending is for building on.

## Step 6 — Test

Three forms, in order of value:

1. **Playback** — explain it back in their own words.
2. **Map** — "describe how these connect, in any order: A · B · C · D". They may also paste a photo of a map drawn on paper; read it.
3. **Define and relate** — "define X and its relation to Y".

Quizzes last, and only to check recall of something already demonstrated.

**Transcribe faithfully.** When turning their described map into mermaid, transcribe it as they said it, mistakes included. **Flag what you think is wrong; never edit it.** They decide and they make the change. A silently corrected map stops being evidence.

## Step 7 — Append to the lesson

Write to `$LESSONS/<topic>.md`, appending as the session runs so it updates live in Obsidian. Create it if absent.

Structure the lesson however suits the material — prose, tables, mermaid, worked examples. Markdown is the container, not a template.

Two things are required at the bottom:

```markdown
## Candidates
<!-- read by /learning-commit. one line each. append only after a probe result
     or a playback, never after an explanation. -->

- concept · evidence
  `terminal-state` · playback: "the episode ends so there's no more reward to collect"
  `reward-shaping` · MISMATCH · called it "a different way to solve the same problem";
                     it addresses sparsity, not horizon
  `discount-factor` · PARKED · blocked on reward-shaping

## Learner's map — <date>
<!-- verbatim transcription, errors included -->
```

`/learning-commit` reads this file, not the transcript. Long sessions get compacted; the file does not.

## Step 8 — Close

End with one line so nothing is invisible:

> Candidates: `terminal-state`, `reward-shaping` (mismatch). Lesson at `ai/lessons/subgoals.md`. Run `/learning-commit` to write.

Do not offer to commit. Do not write to the model, the concepts, or the maps.

## Modes

**Understanding a codebase** — orient on structure first, then drill into the named feature. Teach through real files.

**Preparing to implement** — start from the problem the implementation solves. No code until the concepts hold. Surface tradeoffs explicitly.

On "just do it" or "skip teaching", comply and drop the mode.
