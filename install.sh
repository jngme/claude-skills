#!/usr/bin/env bash
# Restore this machine's Claude Code skill setup.
#
#   ./install.sh            symlink the skills in this repo, then restore third-party ones
#   ./install.sh --mine     only the skills in this repo
#   ./install.sh --vendor   only the third-party ones
#
# Skills in this repo are symlinked, not copied, so edits land in git.
# Third-party skills are never vendored here — vendor/skill-lock.json records
# where they came from and this script reinstalls them from source.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SKILLS="$HOME/.claude/skills"
MINE=(prd-format writing-that-works explain-diff-html learning-session learning-commit)

do_mine=true
do_vendor=true
case "${1:-}" in
  --mine)   do_vendor=false ;;
  --vendor) do_mine=false ;;
  "")       ;;
  *) echo "usage: install.sh [--mine|--vendor]" >&2; exit 2 ;;
esac

if $do_mine; then
  mkdir -p "$CLAUDE_SKILLS"
  for skill in "${MINE[@]}"; do
    target="$CLAUDE_SKILLS/$skill"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skip $skill — a real directory is already there, not replacing it"
      continue
    fi
    ln -sfn "$REPO/$skill" "$target"
    echo "link $skill"
  done
fi

if $do_vendor; then
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found — install Node, then re-run with --vendor" >&2
    exit 1
  fi

  # Group the lockfile by source repo and reinstall each group in one call.
  # `skills add` needs one -s per skill; a comma-separated list matches nothing.
  commands="$(python3 - "$REPO/vendor/skill-lock.json" <<'PY'
import collections, json, shlex, sys
skills = json.load(open(sys.argv[1]))["skills"]
by_source = collections.defaultdict(list)
for name, meta in skills.items():
    by_source[meta["source"]].append(name)
for source, names in sorted(by_source.items()):
    args = ["npx", "-y", "skills@latest", "add", source, "-g", "-y"]
    for n in sorted(names):
        args += ["-s", n]
    print(shlex.join(args))
PY
)"

  while IFS= read -r cmd; do
    [ -n "$cmd" ] || continue
    echo "+ $cmd"
    eval "$cmd"
  done <<<"$commands"

  for patch in "$REPO"/vendor/patches/*.sh; do
    [ -e "$patch" ] || continue
    echo "+ $(basename "$patch")"
    bash "$patch"
  done
fi

cat <<'EOF'

Not covered by this script:
  interface-craft   installed outside the skills.sh lockfile — reinstall by hand
  human-review      lives only on this machine, not in this repo
  knowledge base    the learning skills read ~/knowledge base/ — restore separately
EOF
