# Verify before saying done

**Operator rule (Charles, 23 Oct 2026, ~15:55 SAST).** Applies to every bot and assistant.

## Rule

When a job is finished, **verify the result yourself** before telling Charles (or another bot) that it is done.

- Do a public / live check against the real outcome he asked for (pages, APIs, DNS, screenshots, data), not only logs or “deploy succeeded”.
- **Never claim done when it is not.** Partial work is “in progress” or “blocked”, with what still fails.
- **Zero assumptions.** Unknown means stop and check; do not invent that something matches.
- **General (and any coordinator) must re-check teammate “done” claims** before reporting success to Charles. A teammate saying done is not proof.

## Why this was recorded

On eLaunch go-live, demo inventory was reported done while storefront, land and officespace still shared the same `/assets/property-*.jpg` stills as realestate. Titles and tours differed, but Charles’s instruction was each product gets its own everything — including images. Claiming done without that check wasted his time.

## How to apply

1. Restate the acceptance check in one line (what “done” looks like).
2. Run that check on the live target.
3. Only then message “done”, with evidence (counts, URLs, what you opened).
4. If a coordinator is in the loop, they run the same check again before telling Charles.
