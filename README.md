# second-brain-template

A second brain for Claude Code: flat Markdown files in a few folders, indexed by a `CLAUDE.md` map. No app, no database.

Based on "Claude Second Brain & Folder Workflow" by [@Bober_smart](https://x.com/Bober_smart/status/2078784709253841039).

## Layout

```
CLAUDE.md      the map: navigation, reading and writing protocol
notes/         facts and topics, one file per topic
people/        one card per person or company
projects/      status, where it paused, next steps
MEMORY.md      core facts about you
LEARNINGS.md   lessons, newest first
decisions.md   decision log: what and why
setup.sh       wires the brain into Claude Code on a machine
```

## Use it

Your copy will hold personal details, so make it private. From your home folder:

```bash
gh repo create second-brain --private --template chmjdev/second-brain-template --clone
```

Then wire it into Claude Code:

```bash
~/second-brain/setup.sh
```

`setup.sh` adds a two-line pointer to `~/.claude/CLAUDE.md`, so every Claude Code session knows where the brain is, and adds the folder to `permissions.additionalDirectories` in `~/.claude/settings.json`, so Claude can read and edit it without prompts. Safe to re-run. Needs `python3`.

On another workstation, clone your private copy and run `setup.sh` there. The map tells Claude to pull before reading and to commit and push after writing, so the copies stay in step.

## Design choices

- `MEMORY.md` is not `@`-imported into `CLAUDE.md`, so it adds nothing to sessions that don't need it.
- Claude answers only from the files, cites the file it used, and says "not found" instead of guessing.
- One topic per file, lowercase-hyphen names, update in place rather than duplicate.
