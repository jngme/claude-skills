---
name: prd-format
description: Structures PRDs, product specs and design docs so a reader grasps them fast — labelled parts instead of prose blocks, without stripping explanation. Corrects common drafting defaults such as claim-shaped headers, bullets that echo their header, unlabelled negations, edge cases inlined into flows, and milestones that restate the spec. Use when writing, reviewing or restructuring a PRD, spec or design doc, and when asked to make one clearer, more scannable, or easier to grok.
---

# PRD format

**Before applying anything below, invoke the `writing-that-works` skill.** Not optional, and not a footnote to get to later — do it before you read the target doc.

This skill only sees layout. Sentence-level defects are invisible to it: a claim asserted more broadly than the cited evidence supports, a vague quantity where a number exists, an opinion phrased as fact, a grading word doing an argument's work. Those are the defects that change what a spec commits you to. Run this skill alone and you produce a well-shaped doc with unchecked claims sitting inside the labels.

The goal is a reader grasping the point fast, without the doc losing anything they will need later.

Two mechanisms get you there, and confusing them is the main failure:

- **Structure** — how the same content is laid out. Keeps every fact.
- **Relevance** — whether a line belongs at all. Deletes some.

Most editing is structure. Reach for it first.

**Concise means fewer words, not less content.** Never strip a caveat, a risk or a rejected option to make a section look tight. When something reads badly the fix is usually labels, not cuts.

## Structure: labelled parts, not blocks

A block carrying three ideas separated by full stops is hard to parse. Nothing marks where one idea ends, and nothing tells the reader how many there are.

❌
> **No max run duration in v1.** Deliberate — a duration rail risks stopping a large run someone actually wants. Cover it with observability instead: alert when a run passes a threshold and have a human look. Revisit once we can see the real distribution.

✅
> **No max run duration in v1**
> - **Why:** a duration limit stops a stalled run and a genuinely large run the same way, and we can't tell them apart
> - **Instead:** alert on a wall-clock or spend threshold and have a human look
> - **Revisit when:** observability shows the real distribution

Same three facts, and the second version explains *more* — it gained the clause about not being able to tell the two cases apart. The labels do two jobs: they separate the ideas, and they name what kind of claim each one is.

Structure changes like this delete nothing. If a rewrite makes a section shorter, that was relevance doing the work, and it should be a separate decision.

**Labels are one technique. Match the shape to the content:**

| Content | Shape |
|---|---|
| One idea with sub-rules | Bold label, bullets beneath |
| Several ideas in a block | A label per idea — `Why:` `Instead:` `Trade-off:` |
| Comparison across options | Table |
| Steps someone follows | Numbered list |
| Detail most readers skip | One-line answer + `<details>` toggle |
| Anything doing arithmetic | Notation: `Rate = cost × 1.5`, `balance >= minimum`, `allocated → released` |
| A section with no shape at all | Split into named `##` chunks so the reader can pick one |

**Where this stops.** `writing-that-works` says *prose for reasoning, lists for parallel items, don't bullet a paragraph*. That still holds — this doesn't override it. The test is whether the ideas are parallel or dependent. `Why` / `Instead` / `Revisit when` are three facets of one decision, so labels fit. A chain where each sentence earns the next stays prose; bulleting it snaps the links that were carrying the argument.

## Relevance: every line answers a question

Every line answers a question the reader is holding at that moment. Not *is it true*, not *is it relevant* — **who asked?**

**Mechanical version: try to write the label.** If you can't name the question a line answers, it isn't answering one. The working set: `Why:` · `Context:` · `Instead:` · `Trade-off:` · `Optimising for:` · `Revisit when:` · `Depends on:`

When a line fails the test, work in this order: **relocate → demote → label → cut**. Reaching for a label first justifies a line into staying where it doesn't belong. Justification is cheap and always available, which is why it's the wrong first move.

Note that the first three are structure moves. Most relevance failures are a line sitting in the wrong place, not a line that shouldn't exist — cutting is the last resort, not the default.

Two guardrails:

- **Unnecessary is not the same as short.** A section answering a question nobody asks today but everyone asks in three months earns its length. Cutting caveats, risks and rejected options is a worse failure than padding, and it feels identical to good editing while you do it.
- **You cannot exempt a line by asserting the reader's prior.** "They arrive expecting a spend cap" is a claim about someone not in the room. If the expectation matters, something in the doc has to create it.

## Defaults to correct

Habits, not occasional slips. Check for each one.

**Headers that assert instead of name**

- ❌ **We bill the way our cloud bills us: per second, for the time a runner is yours.**
- ✅ **Billed on runner time**

A header is a name the reader skips past. A claim forces them to parse it before they know what's underneath.

**Bullets that echo their header**

The same content two or three times at decreasing abstraction. Test: delete the header. If nothing is lost it was never a header — it was a first draft of the line below.

**Asserting deliberateness instead of giving a reason**

Cut *deliberate, intentionally, by design, note that, importantly*. They claim a choice was considered and give the reader nothing to check. Replace each with a label naming what follows — see the example above.

**Defining by absence**

- ❌ No reservation, no hold, no spend cap
- ✅ Balance decrements when a run finishes, not while it runs

A reader who never used the mechanism learns nothing from its absence; one who has now wonders what you removed and why. A negation earns its place two ways — the line above created the expectation (**Billable:** … **Not billable:** …), or you label the reason (**Keep it simple for v1:** no invoices, no arrears, no collections). The label turns *things we don't have* into *scope we chose not to take*.

Watch for vocabulary orphaned by a design change. If holds were cut, "nothing is held" describes a concept that no longer exists.

**Importing your own deliberation**

- ❌ `stripe logs` rather than `stripe events` matches the noun they know
- ✅ `stripe logs` matches the noun they know

The alternatives you weighed feel like part of the subject because you spent time on them. Test: would the reader independently arrive at this alternative? Yes → pre-empt it. No → don't plant it. Rejected alternatives belong in *Options we considered*, not in spec lines.

**Characterising sources instead of citing them**

- ❌ Their **own** docs are **explicit**: the application must do the blocking
- ✅ Their docs say the application must do the blocking

Grading words — *explicit, damning, telling, notably, revealingly, even their own* — mean you've stopped reporting and started arguing. Same for your own findings: `We found that X` → `X`.

**Narrating your own structure**

- ❌ *In the order a run meets them.* followed by the list
- ✅ the list, in that order

Structure that needs announcing isn't working; structure that works needs no announcement.

**Numbering what isn't sequential**

Numbered lists are steps where 2 genuinely follows 1. Everything else is bullets, however tidy it looks numbered. The tell that you've over-numbered: you reorder content so the numbers make sense. Parallel checks, rejected options and pricing rules are sets, not sequences.

Exception: numbering for addressability, so other sections can point at `Flow 2`. That's naming.

**Nominalizations instead of the moment**

- ❌ checked at dispatch · blocked at submit · debit on settlement
- ✅ checked when dispatching a run · blocked when they submit · charge when a run finishes

Anchor to a moment in the user's flow, not a stage in the system — the reader is tracking a person doing a thing. Keep a term of art only when no plain phrase covers it.

**Prose that should be notation**

`Rate = cost × 1.5` · `balance >= minimum` · `runner allocated → runner released` · `1000 frames stopped at 400 → charge 400`

Use `→` for outcomes and transitions.

## PRD anatomy

### Sections

A typical shape, not a template to fill. Drop what a given doc doesn't need.

- **Problem** — named and numbered, not a paragraph
- **Goals** — customer-facing split from internal. Without this, nothing in the doc states what success is
- **Solution** — named `##` chunks, usually *how it works* and *mechanics at runtime*
- **Options we considered but decided against** — one line per decision, detail in a toggle. Consolidate options that share a reason
- **Usage scenarios** — flows
- **Open questions** — a callout, for items owned by someone else
- **Milestones** — verifiable checklist, plus deferred scope grouped by reason

### Flows

Happy path only. Numbered steps carry what the user does and what they see back — nothing else. Every branch, flag and failure case inlined is mental tax charged before the reader has understood the main road.

Move failure paths, flags and policy rules into `<details>`. Cut anything already stated in the mechanics section and point at it instead.

The worst version is a failure branch sitting as a numbered step mid-flow: the reader is following a person doing a thing, and step 2 suddenly describes that person failing.

Repeat a rule from the mechanics only when it is genuinely the point of *this* flow.

### Toggles

**Reach for a toggle last.** When a section reads long, the first question is whether it should be shorter — not whether it should be folded away. Folding weak content hides it instead of fixing it, and the doc still carries the weight. Good PRDs often ship with no toggles at all.

Use one only when the detail is genuinely needed *and* most readers genuinely skip it: the full reasoning behind a rejected option, a calculation method, a policy edge case.

A toggle is a pre-emptive FAQ. Closed by default means the reader has already decided the doc works without it, so the summary's only job is telling them what they get for clicking.

- ❌ `Considerations` / `Details` — names nothing
- ❌ `Simulated time, fixed price, seats` — the contents, not the question
- ❌ `Why pausing looked right, and the two things that kill it` — describes the argument's shape
- ✅ `Why not just pause?` — the reader's actual, slightly impatient question
- ✅ `Alternatives considered: simulated time, fixed price, seats` — when it holds a list

Never repeat the decision line above it.

### Milestones

Header them `Done when`, then checkboxes phrased as observable behaviour — something demonstrable, not a component you can claim to have built.

- ❌ Admission check at dispatch: minimum balance plus a concurrency limit
- ✅ `- [ ]` A run is blocked at dispatch when the balance is below the minimum
- ✅ `- [ ]` A run is blocked at dispatch when the namespace is at its concurrency limit

Splitting is the point — one line can't be half-done, and the checklist form is what exposes a single bullet hiding two deliverables. It also surfaces dependencies: "zero-charge decided by how the run ended" is unfalsifiable, while "a run that fails on infra settles at $0" makes obvious that those states need classifying first.

Group deferred scope by why it's deferred, so the headers carry the reason: **Needs data we don't have yet** · **Not worth building at this scale** · **Costs more than it returns right now**. If you catch yourself writing *"recorded so this doesn't get re-litigated"*, the grouping was supposed to do that.

## Before shipping

- [ ] No block carries more than one idea without labels separating them
- [ ] Every heading is a label, not a sentence
- [ ] No header restates its own bullets
- [ ] Every negation either follows a stated expectation or carries a reason label
- [ ] Numbered lists are sequences; everything else is bullets
- [ ] Flows contain no branches
- [ ] Milestones are checkable, not restatements
- [ ] Arithmetic is notation
- [ ] Uncertain numbers are marked as uncertain
- [ ] Nothing was cut to make a section look tight

The second-to-last matters most. Clean formatting flattens confidence — `Rate = cost × 1.5` reads as settled fact even when the number was a guess. Say so explicitly, or the layout launders a guess into a decision nobody made.
