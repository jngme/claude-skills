# claude-skills

Five [Claude Code](https://claude.com/claude-code) skills — three for writing and reviewing documents, two for learning technical concepts without being talked over.

A skill is a markdown file Claude loads on demand. The `description` in its frontmatter decides when it fires; the body is the instruction set Claude follows once it does.

## Writing

| Skill | Fires when | Does |
|---|---|---|
| [`writing-that-works`](writing-that-works/) | Writing anything a person reads — replies, docs, PR descriptions, commit messages | Lead with the answer, cut padding, specifics over generalities, jargon only when it's the precise name for the thing |
| [`prd-format`](prd-format/) | Writing, reviewing or restructuring a PRD, spec or design doc | Labelled parts instead of prose blocks. Catches claim-shaped headers, bullets that echo their header, unlabelled negations, branches inlined into flows, milestones that restate the spec |
| [`explain-diff-html`](explain-diff-html/) | Asked to explain a diff, branch or PR | Renders the change as HTML rather than a wall of terminal text |

`prd-format` and `writing-that-works` are designed to run together — the first covers layout, the second covers sentences. `prd-format` loads the other as its first instruction, because applying structure rules alone produces a well-shaped document with unchecked claims inside the labels.

## Learning

| Skill | Fires when | Does |
|---|---|---|
| [`learning-session`](learning-session/) | `/learning-session` only | Probes what you actually hold, teaches one concept, writes nothing |
| [`learning-commit`](learning-commit/) | `/learning-commit` only | Proposes every change as a diff, writes only what you confirm |

**The problem they solve:** an explanation reaches for a term you don't hold, and neither of you notices. Every term is grounded for the model, so its prerequisite check silently passes on the wrong map.

The fix is a **concept map** — a small file recording, per concept, how deeply you hold it and what it rests on:

```
async-await   @read   ← functions, concurrent-vs-parallel
event-loop    @model  ← async-await
```

Depth is the part that makes it work. Known/unknown is too coarse to pitch an explanation at. With `event-loop @model`, "the loop picks up the next queued job" is allowed and "microtasks drain before the next macrotask" is not — a rule the model can check itself against mid-sentence, which "explain it clearly" is not.

Both skills are `disable-model-invocation: true`, so neither fires on its own.

**Why two skills.** Reading and writing have different failure modes. Teaching sessions that log as they go commit concepts before anyone knows which ones stuck — that biases toward recording everything *covered* rather than everything *solidified*, and the log bloats. `learning-session` therefore cannot write; `learning-commit` runs once, at the end, when the answer is knowable. It refuses to promote a depth without recorded playback, and never more than one level per session.

The cost is that a manually-invoked writer gets forgotten, so `learning-session` ends by naming the uncommitted candidates.

## Install

Clone into your personal skills directory:

```bash
git clone https://github.com/jngme/claude-skills.git /tmp/claude-skills
cp -R /tmp/claude-skills/{prd-format,writing-that-works,explain-diff-html,learning-session,learning-commit} ~/.claude/skills/
```

Or per-project, so a team shares them — copy the same directories into `.claude/skills/` at the repo root and commit them.

Claude picks them up on the next session. Invoke by name with `/prd-format`, or let the description trigger them.

**The learning skills need three files** that don't ship with them, since they hold your notes. Starters are in [`learning-session/templates/`](learning-session/templates/):

```bash
mkdir -p ~/"knowledge base"
cp /tmp/claude-skills/learning-session/templates/*.md ~/"knowledge base"/
```

Both skills default to `~/knowledge base/` and name the path once, in a `## Setup` block at the top. Point it anywhere — a private repo is a good choice, since the notes are personal in a way the skills aren't.

## Adapting these

The rules encode one person's taste, and taste is the point — a style guide that tries to please everyone stops changing any output. Fork it and edit the rules you disagree with rather than layering exceptions on top.

Two things are worth knowing if you edit them:

- **Cross-skill loading is advisory.** There's no `requires:` field in skill frontmatter. One skill telling Claude to load another is plain text it may skip, which is why `prd-format` puts that instruction in its first line with the reason attached rather than as a footnote.
- **Examples do the teaching.** Most of the length in these files is ❌/✅ pairs. Abstract rules get acknowledged and ignored; a pair showing the same content written both ways gets applied.
- **A rule the model can check itself against beats a rule it can only agree with.** The depth ceiling in `learning-session` works because it names a specific sentence that is now disallowed. "Match their level" names nothing and changes nothing.

## License

MIT — see [LICENSE](LICENSE).
