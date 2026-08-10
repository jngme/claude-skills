#!/usr/bin/env bash
# Rename mattpocock/skills' `code-review` to `spec-review`.
#
# Claude Code ships its own built-in /code-review (the one with `ultra`,
# `--comment` and `--fix`). Installing a user skill under the same name risks
# shadowing it. Renaming keeps both: /code-review stays the built-in,
# /spec-review is the two-axis Standards + Spec review.
#
# Idempotent — safe to re-run. `npx skills update` restores the upstream name,
# so run this again afterwards.

set -euo pipefail

STORE="${SKILLS_STORE:-$HOME/.agents/skills}"

if [ ! -d "$STORE/code-review" ]; then
  echo "rename-code-review: nothing to do (no $STORE/code-review)"
  exit 0
fi

if [ -e "$STORE/spec-review" ]; then
  echo "rename-code-review: $STORE/spec-review already exists — resolve by hand" >&2
  exit 1
fi

mv "$STORE/code-review" "$STORE/spec-review"

# Frontmatter name must match the directory, or the skill won't resolve.
sed -i '' 's/^name: code-review$/name: spec-review/' "$STORE/spec-review/SKILL.md"

# Repoint the per-agent symlinks that pointed at the old directory.
for agent_dir in "$HOME/.claude/skills" "$HOME/.augment/skills"; do
  [ -d "$agent_dir" ] || continue
  rm -f "$agent_dir/code-review"
  ln -sfn "$STORE/spec-review" "$agent_dir/spec-review"
done

# Callers reference the skill by name; upstream points them at /code-review,
# which would now resolve to the built-in and skip the Spec axis.
sed -i '' 's|/code-review|/spec-review|g' "$STORE/implement/SKILL.md"
sed -i '' 's|`code-review` skill|`spec-review` skill|g' "$STORE/tdd/SKILL.md"

echo "rename-code-review: done — code-review is now spec-review"
