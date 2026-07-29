---
name: quarterly-brag
description: Synthesize weekly brag docs into a quarterly summary. Usage: /quarterly-brag Q1 2026 (defaults to current quarter if no args).
---

# Quarterly Brag Doc Generator

Read all weekly brag docs for a given quarter, ask Milo a couple of context questions, and synthesize a quarterly summary doc.

## Steps

### 1. Parse arguments and calculate quarter boundaries

Extract quarter (Q1-Q4) and year from the arguments. If omitted, default to the current quarter and year based on today's date.

Quarter boundaries:
- Q1: Jan 1 – Mar 31
- Q2: Apr 1 – Jun 30
- Q3: Jul 1 – Sep 30
- Q4: Oct 1 – Dec 31

```bash
python3 -c "
from datetime import date
today = date.today()
month = today.month
if month <= 3:
    q = 1
elif month <= 6:
    q = 2
elif month <= 9:
    q = 3
else:
    q = 4
print(f'Q{q} {today.year}')
"
```

Use the arguments (or defaults) to determine:
- `QUARTER` — e.g. Q1
- `YEAR` — e.g. 2026
- `START_DATE` — first day of quarter (YYYY-MM-DD)
- `END_DATE` — last day of quarter (YYYY-MM-DD)

### 2. Read weekly brag docs

Glob for `/Users/milo/Obsidian/Personal/Career/Brag Docs/YYYY/*.md` and filter to files whose date (from filename) falls within the quarter's START_DATE to END_DATE range. Exclude any file matching the pattern `Q#-YYYY.md` (previously generated quarterly docs).

Read all matching files. Weekly docs may have different formats:
- **Newer format** (Feb 2026+): structured with frontmatter (`date`, `week`, `tags: brag-doc`), sections like Highlights, What I Shipped, Reviews, Decisions, Impact, Open Threads, Next Week
- **Older format** (Jan 2026): informal daily-note style with Accomplishments, Stuff to Improve sections, or bullet-based Win/metric/who-benefited format

Handle both gracefully — extract useful content regardless of structure.

If **no weekly docs** are found for the quarter, tell Milo and continue to step 3 anyway (he can manually fill in context).

### 3. Ask context questions

Use AskUserQuestion to ask Milo these two questions (both with a free-text "Skip" option):

1. "What were the major themes or goals for this quarter?"
2. "Anything quarter-level worth highlighting that the weekly docs might not capture? Promotions, launches, org changes?"

### 4. Synthesize the quarterly doc

Using the weekly doc content and Milo's answers, assemble the quarterly summary. **Omit any section that would be empty** — no placeholder stubs.

Template:

```markdown
---
date: END_DATE
quarter: "Q# YYYY"
tags:
  - brag-doc
  - quarterly
---

# Q# YYYY

## Quarter Highlights
- 3-5 biggest wins across the quarter, with context and impact

## Themes
- Major threads of work, grouped (e.g. "Integrations platform", "Ops/monitoring", "DX improvements")
- Each theme summarizes what was done and why it mattered

## What I Shipped
- All PRs from weekly docs, grouped by theme/area
- Condensed — not every PR, but notable ones with links

## Reviews & Collaboration
- Patterns in code reviews, pairing, mentoring across the quarter

## Decisions
- Significant technical decisions and tradeoffs, with outcomes if known

## Impact
- Cumulative impact: who benefited, metrics, before/after

## Looking Ahead
- Open threads carrying into next quarter
- Goals or focus areas
```

Writing guidelines:
- Write highlights with context and impact, not just titles
- Group related work into themes — look for patterns across weeks
- Condense PRs: list notable ones with links, but don't duplicate the weekly docs verbatim
- Synthesize decisions and impact cumulatively — look for the bigger picture
- For "Looking Ahead", pull from the latest week's Open Threads and Next Week sections, plus any unresolved items from earlier weeks

### 5. Write the file

```bash
mkdir -p "/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR"
```

Write the assembled doc to: `/Users/milo/Obsidian/Personal/Career/Brag Docs/YYYY/Q#-YYYY.md`

Example: `/Users/milo/Obsidian/Personal/Career/Brag Docs/2026/Q1-2026.md`

If the file already exists, offer to merge it or overwrite it (Milo may be iterating).

### 6. Offer clipboard copy

After writing, ask Milo if he wants the doc copied to clipboard. If yes:

```bash
cat "/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR/Q#-$YEAR.md" | pbcopy
```

### 7. Alert about yearly brag

After writing, if it's the last few weeks of the year (any time after December 15th), offer to run `/yearly-brag`.

## Edge Cases

- **No weekly docs found:** Tell Milo, still ask questions — he can fill in manually
- **Partial quarter (mid-quarter run):** Works fine — summarizes what exists so far, note in the doc that the quarter is in progress if applicable
- **Mixed doc formats:** Older docs may be informal or structured differently — extract useful content from any format
- **Run twice:** Overwrites the same file
- **Quarterly doc already exists in glob results:** Exclude files matching `Q#-YYYY.md` pattern when reading weekly docs
