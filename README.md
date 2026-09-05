# claude-skills

Six [Claude Code](https://claude.com/claude-code) skills — four for writing and reviewing documents, two for learning technical concepts without being talked over.

A skill is a markdown file Claude loads on demand. The `description` in its frontmatter decides when it fires; the body is the instruction set Claude follows once it does.

## Writing

| Skill | Fires when | Does |
|---|---|---|
| [`writing-that-works`](writing-that-works/) | Writing anything a person reads — replies, docs, PR descriptions, commit messages | Lead with the answer, cut padding, specifics over generalities, jargon only when it's the precise name for the thing |
| [`prd-format`](prd-format/) | Writing, reviewing or restructuring a PRD, spec or design doc | Labelled parts instead of prose blocks. Catches claim-shaped headers, bullets that echo their header, unlabelled negations, branches inlined into flows, milestones that restate the spec |
| [`explain-diff-html`](explain-diff-html/) | Asked to explain a diff, branch or PR | Renders the change as HTML rather than a wall of terminal text |
| [`human-review`](human-review/) | After writing an HTML or Markdown file a person will read | Opens it in the browser so they edit the text in place and comment on specific parts, then sends the whole batch back |

`prd-format` and `writing-that-works` are designed to run together — the first covers layout, the second covers sentences. `prd-format` loads the other as its first instruction, because applying structure rules alone produces a well-shaped document with unchecked claims inside the labels.

## Learning

| Skill | Fires when | Does |
|---|---|---|
| [`learning-session`](learning-session/) | `/learning-session` only | Reads what you already hold, probes against real code, teaches one concept, writes only the lesson document |
| [`learning-commit`](learning-commit/) | `/learning-commit` only | Reads the lesson document, shows the map diff, proposes every write as a numbered diff, writes only what you confirm |

**The problem they solve:** an explanation reaches for a term you don't hold, and neither of you notices. Every term is grounded for the model, so its prerequisite check silently passes on the wrong map.

The fix is a set of notes the model reads before it opens its mouth. They live in a knowledge base you own — a git repo is the right shape, since the value is in watching it change:

```
ai/model.md          position per domain, what's parked, every open gap
ai/concepts/<x>.md   per concept: holds, gaps, relations, taught-by
ai/maps/<domain>.md  reference territory — solid edges taught, dotted untaught
ai/lessons/<x>.md    the live lesson document
maps/<domain>/       your own dated map snapshots, verbatim, never edited
notes/               your own claims. Read by the skills, never written.
```

Two things make it work.

**`holds` lines are your words, not a rating.** A concept file records the sentence you said when you explained it back, dated. Known/unknown is too coarse to pitch an explanation at; a verbatim playback line is specific enough that the model can check a draft sentence against it mid-paragraph. Lines are added, never rewritten.

**Gaps are named wrong beliefs with the correction attached.** Not "shaky on reward-shaping" — "conflates shaping with horizon length; it addresses sparsity". A gap clears only when a later playback contradicts it. Nothing else clears it.

Both skills are `disable-model-invocation: true`, so neither fires on its own.

**Why two skills.** Reading and writing have different failure modes. Teaching sessions that log as they go commit concepts before anyone knows which ones stuck — that biases toward recording everything *covered* rather than everything *solidified*. So `learning-session` can write exactly one file, the lesson document, and is barred from the model, the concepts and the maps. `learning-commit` runs once at the end, when the answer is knowable, and proposes every write as a diff you approve line by line.

The lesson document is also what makes the split survivable: `learning-commit` reads that file rather than the conversation, because long sessions get compacted and the transcript is lossy.

The cost is that a manually-invoked writer gets forgotten, so `learning-session` ends by naming the uncommitted candidates.

## Install

Clone into your personal skills directory:

```bash
git clone https://github.com/jngme/claude-skills.git /tmp/claude-skills
cp -R /tmp/claude-skills/{prd-format,writing-that-works,explain-diff-html,human-review,learning-session,learning-commit} ~/.claude/skills/
```

Or per-project, so a team shares them — copy the same directories into `.claude/skills/` at the repo root and commit them.

Claude picks them up on the next session. Invoke by name with `/prd-format`, or let the description trigger them.

**The learning skills need a knowledge base** that doesn't ship with them, since it holds your notes:

```bash
mkdir -p ~/"knowledge base"/{ai/{concepts,maps,lessons},maps,notes}
cd ~/"knowledge base" && git init
```

Both skills name the path once, in a `## Config` block at the top of each file. They default to `~/knowledge base` — point it anywhere. A private repo is a good choice, since the notes are personal in a way the skills aren't, and `learning-commit` commits to it after every session.

## Restoring a whole setup

The six skills above are the ones I wrote. I also run seventeen I didn't — mostly [mattpocock/skills](https://github.com/mattpocock/skills), plus [`find-skills`](https://github.com/vercel-labs/skills). Those are **not** copied into this repo, and that's deliberate:

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

`skills.sh` installs into every agent directory it knows about, so a run ends with a red `Failed to install 15 — PromptScript does not support global skill installation` block. That is PromptScript refusing, not Claude Code. Check `~/.claude/skills/` rather than the summary.

One skill sits outside both halves. [Interface Craft](https://www.interfacecraft.dev) by Josh Puckett arrived without an install source and ships no license file, so there's nothing to record in the manifest and nothing granting the right to redistribute it. `install.sh` names it and stops. That's the honest failure mode for the lockfile approach: it can only rebuild what came from somewhere it can point at.

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

If a skill can't survive generalising — the worked example *is* the internal system, or the whole point is internal — keep it out of this repo.

A hardcoded path on its own is not that case. Both learning skills point at a real vault on the machine they were written on; the published copies carry the same `## Config` block with `~/knowledge base` in it, so nothing but the value differs and re-pointing after `install.sh` is one line per skill.

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
