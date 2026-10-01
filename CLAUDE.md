# Second Brain: Index

Personal knowledge base. Use it to answer questions. Do not invent information.

## Navigation

- `notes/`       : Facts and topics. One topic = one file.
- `people/`      : People and companies. One card each.
- `projects/`    : Active projects: status, where it paused, next steps.
- `MEMORY.md`    : Long-term core context about me: who I am, work, preferences.
- `LEARNINGS.md` : Lessons and past mistakes.
- `decisions.md` : Log of key decisions: the what and the why.

## Reading protocol

- Answer ONLY from these files. Cite the file path for every fact used.
- If it is not here, say "not found". Do not guess or fill gaps from general knowledge.
- Use this map to pick the file first; search (grep) only when the map does not settle it.

## Writing protocol

- One file per topic. Name it for what it holds: `tax-policy.md`, not `note-12.md`.
- Lowercase with hyphens: `vps-setup.md`, `ivan-petrov.md`.
- Before creating a file, check whether one already covers the topic. Append to it; never create a duplicate.
- Facts that change (status, role, numbers) are updated in place, not appended as a contradiction.
- A new folder is added to Navigation above in the same change. A folder missing from this map is invisible.
- Dates are `YYYY-MM-DD`. `decisions.md` and `LEARNINGS.md` are newest first.

## Sync

This folder is a private git repo shared by my workstations.

- Before the first read in a session, run `git pull --rebase --quiet` in this folder.
- After writing, commit with a one-line message saying what changed, then push.

## File shapes

`people/<name>.md`

```
# Full Name
Who: role, company
Context: how we know each other
Details: anything worth remembering

## Log
- YYYY-MM-DD: what happened
```

`projects/<project>.md`

```
# Project Name
Status: active | paused | done
Where it paused: ...
Next steps:
- ...

## Log
- YYYY-MM-DD: what happened
```
