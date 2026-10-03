#!/bin/sh
# Wires this second brain into Claude Code, and into Codex and Gemini CLI where they are
# installed, on this machine. Safe to re-run. Needs python3.
set -eu

BRAIN="$(cd "$(dirname "$0")" && pwd)"
POINTER="## Second brain

My personal knowledge base is at $BRAIN (git repo, shared across my workstations).
For questions about me, my people, projects, decisions or lessons, or when I say \"remember ...\", read $BRAIN/CLAUDE.md first and follow its protocol."

# A short pointer in a tool's user-level instructions file, which every session reads.
add_pointer() {
  if ! grep -qsF "$BRAIN/CLAUDE.md" "$1"; then
    mkdir -p "$(dirname "$1")"
    { [ -s "$1" ] && printf '\n'; printf '%s\n' "$POINTER"; } >> "$1"
    echo "added pointer to $1"
  fi
}

# 1. Claude Code: the pointer, and read/edit access without permission prompts.
add_pointer "$HOME/.claude/CLAUDE.md"
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

# 2. Codex (~/.codex): the pointer in AGENTS.md, and a permission profile that is the
#    built-in :workspace plus write access to the brain (needs a Codex release with
#    permission profiles). The brain's .git stays read-only, so commit and push still ask.
if [ -d "$HOME/.codex" ]; then
  add_pointer "$HOME/.codex/AGENTS.md"
  python3 - "$BRAIN" <<'PY'
import os, re, sys
path = os.path.expanduser("~/.codex/config.toml")
brain = sys.argv[1]
text = open(path).read() if os.path.exists(path) else ""
if "[permissions.second-brain]" in text:
    sys.exit(0)
if re.search(r"(?m)^\s*(default_permissions|sandbox_mode)\s*=|^\s*\[(permissions|sandbox_workspace_write)\b", text):
    print(f"{path} already sets its own sandbox; give Codex write access to {brain} there yourself")
    sys.exit(0)
default = 'default_permissions = "second-brain"  # :workspace plus the second brain\n'
first_table = re.search(r"(?m)^\[", text)
cut = first_table.start() if first_table else len(text)
head, tail = text[:cut], text[cut:]
if head and not head.endswith("\n"):
    head += "\n"
profile = (
    "\n[permissions.second-brain]\n"
    'extends = ":workspace"\n\n'
    "[permissions.second-brain.filesystem]\n"
    f'"{brain}" = "write"\n'
)
new = head + default + ("\n" if tail else "") + tail
new = new.rstrip("\n") + "\n" + profile
try:
    import tomllib
    tomllib.loads(new)
except ImportError:
    pass
except Exception as error:
    print(f"left {path} unchanged: the edit would not parse ({error})")
    sys.exit(0)
with open(path, "w") as f:
    f.write(new)
print("added the second-brain permission profile to", path)
PY
fi

# 3. Gemini CLI (~/.gemini): the pointer in GEMINI.md, and the brain as an included
#    directory so every session can read and edit it.
if [ -d "$HOME/.gemini" ]; then
  add_pointer "$HOME/.gemini/GEMINI.md"
  python3 - "$BRAIN" <<'PY'
import json, os, sys
path = os.path.expanduser("~/.gemini/settings.json")
brain = sys.argv[1]
try:
    settings = json.load(open(path)) if os.path.exists(path) else {}
except ValueError:
    print(f"{path} is not plain JSON; add {brain} to context.includeDirectories there yourself")
    sys.exit(0)
dirs = settings.setdefault("context", {}).setdefault("includeDirectories", [])
if brain not in dirs:
    dirs.append(brain)
    with open(path, "w") as f:
        json.dump(settings, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print("added", brain, "to", path)
PY
fi
