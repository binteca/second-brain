# second-brain

A second brain for Claude Code, Codex and Gemini CLI: flat Markdown files in a few folders, indexed by a `CLAUDE.md` map. No app, no database.

Open source from [Binteca Labs](https://binteca.com/labs). We run it in the lab to give Claude Code a memory that carries our decisions, lessons and project status from one session to the next and from one workstation to another. The write-up: [A second brain for Claude Code, now open source](https://binteca.com/blog/second-brain-for-claude-code).

## Credit

Seeded from "Claude Second Brain & Folder Workflow" by [@Bober_smart](https://x.com/Bober_smart/status/2078784709253841039). The idea of a folder of Markdown files with a `CLAUDE.md` map comes from there; this repository is the version we adapted for daily use in the lab.

## Layout

```
CLAUDE.md      the map: navigation, reading and writing protocol
notes/         facts and topics, one file per topic
people/        one card per person or company
projects/      status, where it paused, next steps
MEMORY.md      core facts about you
LEARNINGS.md   lessons, newest first
decisions.md   decision log: what and why
setup.sh       wires the brain into Claude Code, Codex and Gemini CLI
```

## Use it

Your copy will hold personal details, so make it private. From your home folder:

```bash
gh repo create second-brain --private --template binteca/second-brain --clone
```

Then wire it into your agents:

```bash
~/second-brain/setup.sh
```

`setup.sh` adds a two-line pointer to each agent's user-level instructions, so every session knows where the brain is, and gives it access to the folder:

| Agent | Pointer | Access |
| --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` | `permissions.additionalDirectories` in `~/.claude/settings.json`: read and edit without prompts |
| Codex (if `~/.codex` exists) | `~/.codex/AGENTS.md` | a `second-brain` permission profile in `~/.codex/config.toml`: the built-in `:workspace` plus write access to the brain, made the default. `.git` stays read-only, so commit and push still ask. Needs a Codex release with permission profiles |
| Gemini CLI (if `~/.gemini` exists) | `~/.gemini/GEMINI.md` | `context.includeDirectories` in `~/.gemini/settings.json` |

If your Codex config already sets its own sandbox (`sandbox_mode`, `default_permissions` or a `[permissions]` table), or your Gemini settings are not plain JSON, `setup.sh` leaves that file alone and tells you what to add. Safe to re-run. Needs `python3`.

On another workstation, clone your private copy and run `setup.sh` there. The map tells the agent to pull before reading and to commit and push after writing, so the copies stay in step.

## Design choices

- `MEMORY.md` is not `@`-imported into `CLAUDE.md`, so it adds nothing to sessions that don't need it.
- Claude answers only from the files, cites the file it used, and says "not found" instead of guessing.
- One topic per file, lowercase-hyphen names, update in place rather than duplicate.
- Decisions keep their reasons: every entry in `decisions.md` has a `What:` and a `Why:`, and a reversed decision stays in the log.
- This repository is the framework only. Content lives in each person's private copy and never comes back here.

## Licence

MIT. See [LICENSE](LICENSE).
