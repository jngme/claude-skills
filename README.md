# claude-skills

Three [Claude Code](https://claude.com/claude-code) skills for writing and reviewing documents.

A skill is a markdown file Claude loads on demand. The `description` in its frontmatter decides when it fires; the body is the instruction set Claude follows once it does.

## The skills

| Skill | Fires when | Does |
|---|---|---|
| [`writing-that-works`](writing-that-works/) | Writing anything a person reads — replies, docs, PR descriptions, commit messages | Lead with the answer, cut padding, specifics over generalities, jargon only when it's the precise name for the thing |
| [`prd-format`](prd-format/) | Writing, reviewing or restructuring a PRD, spec or design doc | Labelled parts instead of prose blocks. Catches claim-shaped headers, bullets that echo their header, unlabelled negations, branches inlined into flows, milestones that restate the spec |
| [`explain-diff-html`](explain-diff-html/) | Asked to explain a diff, branch or PR | Renders the change as HTML rather than a wall of terminal text |

`prd-format` and `writing-that-works` are designed to run together — the first covers layout, the second covers sentences. `prd-format` loads the other as its first instruction, because applying structure rules alone produces a well-shaped document with unchecked claims inside the labels.

## Install

Clone into your personal skills directory:

```bash
git clone https://github.com/jngme/claude-skills.git /tmp/claude-skills
cp -R /tmp/claude-skills/{prd-format,writing-that-works,explain-diff-html} ~/.claude/skills/
```

Or per-project, so a team shares them — copy the same directories into `.claude/skills/` at the repo root and commit them.

Claude picks them up on the next session. Invoke by name with `/prd-format`, or let the description trigger them.

## Adapting these

The rules encode one person's taste, and taste is the point — a style guide that tries to please everyone stops changing any output. Fork it and edit the rules you disagree with rather than layering exceptions on top.

Two things are worth knowing if you edit them:

- **Cross-skill loading is advisory.** There's no `requires:` field in skill frontmatter. One skill telling Claude to load another is plain text it may skip, which is why `prd-format` puts that instruction in its first line with the reason attached rather than as a footnote.
- **Examples do the teaching.** Most of the length in these files is ❌/✅ pairs. Abstract rules get acknowledged and ignored; a pair showing the same content written both ways gets applied.

## License

MIT — see [LICENSE](LICENSE).
