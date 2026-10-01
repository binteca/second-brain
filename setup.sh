#!/bin/sh
# Wires this second brain into Claude Code on this machine. Safe to re-run. Needs python3.
set -eu

BRAIN="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude"

# 1. Short pointer in the user-level CLAUDE.md, which every session reads.
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if ! grep -qsF "$BRAIN/CLAUDE.md" "$CLAUDE_MD"; then
  [ -s "$CLAUDE_MD" ] && printf '\n' >> "$CLAUDE_MD"
  cat >> "$CLAUDE_MD" <<EOF
## Second brain

My personal knowledge base is at $BRAIN (git repo, shared across my workstations).
For questions about me, my people, projects, decisions or lessons, or when I say "remember ...", read $BRAIN/CLAUDE.md first and follow its protocol.
EOF
  echo "added pointer to $CLAUDE_MD"
fi

# 2. Let every session read and edit the brain without permission prompts.
python3 - "$BRAIN" <<'PY'
import json, os, sys
path = os.path.expanduser("~/.claude/settings.json")
brain = sys.argv[1]
settings = json.load(open(path)) if os.path.exists(path) else {}
dirs = settings.setdefault("permissions", {}).setdefault("additionalDirectories", [])
if brain not in dirs:
    dirs.append(brain)
    with open(path, "w") as f:
        json.dump(settings, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print("added", brain, "to", path)
PY
