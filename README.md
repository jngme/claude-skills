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

## Restoring a whole setup

The five skills above are the ones I wrote. I also run a dozen or so I didn't — mostly [mattpocock/skills](https://github.com/mattpocock/skills). Those are **not** copied into this repo, and that's deliberate:

- Redistributing someone else's MIT code means carrying their copyright notice with the copies. Real obligation, no benefit.
- Copies go stale the moment upstream ships. You end up maintaining a silent fork of files you didn't write.
- A repo that's 80% someone else's work under your name is hard to read. Which parts did I actually write?

So this repo records **where they came from**, not what they contain. [`vendor/skill-lock.json`](vendor/skill-lock.json) is the manifest — one entry per third-party skill with its source repo, path within that repo, and a content hash:

```json
"grill-with-docs": {
  "source": "mattpocock/skills",
  "skillPath": "skills/engineering/grill-with-docs/SKILL.md",
  "skillFolderHash": "…"
}
```

[`install.sh`](install.sh) reads it and rebuilds the machine:

```bash
./install.sh            # this repo's skills, then the third-party ones
./install.sh --mine     # just this repo's
./install.sh --vendor   # just the third-party ones
```

The skills in this repo get **symlinked** rather than copied, so edits land in git instead of drifting from it. The third-party ones get reinstalled from source with [skills.sh](https://skills.sh), which puts them in `~/.agents/skills/` and symlinks them into each agent's directory. Real directory means mine; symlink means someone else's — a provenance check that costs one `find`.

### Sanitise before pushing

**A skill written for yourself is not a skill fit to publish.** Skills get drafted against whatever was on screen at the time, so the private details are load-bearing by accident — an internal tool used as the worked example, a hardcoded home directory, your employer's product names in a ❌/✅ pair. None of it looks like a leak while you're writing it.

Anything in this repo goes public the moment it's pushed, and git history keeps it. A force-push does not remove a bad commit; it stays fetchable by SHA until GitHub garbage-collects.

So before every push, grep the staged tree for:

- your employer's name, and internal product or command names
- your own name (the `LICENSE` copyright line is the expected hit — anything else is not)
- absolute home paths (`/Users/…`, `/home/…`)
- customer names, ticket IDs, internal URLs

```bash
git diff --cached | grep -niE 'your-employer|internal-product|your-name|/Users/|/home/'
```

Two rules that make this survivable:

- **Generalise, don't strip.** A worked example carries most of a skill's teaching weight, so deleting it guts the skill. Swap the private referent for a public one of the same shape — an internal CLI command becomes `stripe logs`, not nothing.
- **Fix both copies.** Sanitise the local skill too, so the published and installed versions stay identical. A sanitised fork drifts, and then you're diffing two things you wrote.

If a skill can't survive generalising — it hardcodes a personal path, or the whole point is internal — keep it out of this repo. `human-review` is local-only for that reason.

### Patches

Sometimes an installed skill needs a local change. Those live in [`vendor/patches/`](vendor/patches/) as idempotent scripts, not as forked copies.

[`rename-code-review.sh`](vendor/patches/rename-code-review.sh) is the one that exists so far. Claude Code ships a built-in `/code-review`; mattpocock's repo has a skill by the same name doing something different (Standards and Spec axes in parallel sub-agents). Rather than let one shadow the other, the patch renames the installed one to `spec-review` and repoints the two skills that call it. `npx skills update` restores the upstream name, so `install.sh` re-runs the patch every time.

## Adapting these

The rules encode one person's taste, and taste is the point — a style guide that tries to please everyone stops changing any output. Fork it and edit the rules you disagree with rather than layering exceptions on top.

Two things are worth knowing if you edit them:

- **Cross-skill loading is advisory.** There's no `requires:` field in skill frontmatter. One skill telling Claude to load another is plain text it may skip, which is why `prd-format` puts that instruction in its first line with the reason attached rather than as a footnote.
- **Examples do the teaching.** Most of the length in these files is ❌/✅ pairs. Abstract rules get acknowledged and ignored; a pair showing the same content written both ways gets applied.
- **A rule the model can check itself against beats a rule it can only agree with.** The depth ceiling in `learning-session` works because it names a specific sentence that is now disallowed. "Match their level" names nothing and changes nothing.

## License

MIT — see [LICENSE](LICENSE).
