---
name: brag-doc
description: Generate a weekly brag doc from GitHub activity and calendar events. Best run on Monday mornings. Supports "last week" override.
---

# Weekly Brag Doc Generator

Pull GitHub activity from the Swoogo org, optionally pull Google Calendar events, ask Milo follow-up questions, and write a structured brag doc to his Obsidian vault.

## Steps

### 1. Parse arguments and calculate date range

Default to **last week** (previous Monday–Friday). If the argument contains "this week", use the current week instead.

```bash
# Last week (default)
MONDAY=$(python3 -c "from datetime import date, timedelta; d=date.today(); print(d - timedelta(days=d.weekday()+7))")
FRIDAY=$(python3 -c "from datetime import date, timedelta; d=date.today(); print(d - timedelta(days=d.weekday()+7) + timedelta(days=4))")

# This week (only if explicitly requested)
MONDAY=$(python3 -c "from datetime import date, timedelta; d=date.today(); print(d - timedelta(days=d.weekday()))")
FRIDAY=$(python3 -c "from datetime import date, timedelta; d=date.today(); print(d - timedelta(days=d.weekday()) + timedelta(days=4))")
```

Use `FRIDAY` as the filename date and `MONDAY` as the `--` date filter lower bound.

Format display dates like "Feb 24" for the header (e.g. "Feb 24 – Feb 28").

### 2. Gather GitHub data (run all in parallel)

Run these five queries in parallel using separate Bash tool calls:

**Merged PRs (Swoogo org):**
```bash
gh search prs --author=milogert --merged --limit=50 -- org:swoogo "merged:>=$MONDAY"
```

**Drive-integrations PRs (separate query, different repo search):**
```bash
gh pr list --author milogert --repo swoogo/drive-integrations --state merged --search "merged:>=$MONDAY" --limit=50
```

**Code reviews:**
```bash
gh search prs --reviewed-by=milogert --merged --limit=50 -- org:swoogo "merged:>=$MONDAY"
```

**Issues created:**
```bash
gh search issues --author=milogert --limit=50 -- org:swoogo "created:>=$MONDAY"
```

**Open source (non-Swoogo):**
```bash
gh search prs --author=milogert --merged --limit=50 -- -org:swoogo "merged:>=$MONDAY"
```

After gathering:
- Filter out any PR whose title contains "New Crowdin updates" (automated translation PRs)
- De-duplicate PRs that appear in multiple queries (by URL or number)

### 3. Gather calendar events

Fetch Google Calendar events in parallel with the GitHub queries above. Use `gcal_list_events` with `timeMin` set to `$MONDAY T00:00:00` and `timeMax` set to `$FRIDAY T23:59:59` for Milo's primary calendar. Summarize meetings by name and attendee count.

If Google Calendar MCP tools are not available, skip and tell Milo calendar integration is unavailable.

### 4. Present summary and ask follow-up questions

Show Milo the raw data organized by category (PRs shipped, reviews, issues, calendar events if available).

Then ask these questions **one at a time** using AskUserQuestion, with a free-text "Skip" option so Milo can skip any question:

1. "What were your biggest wins this week?"
2. "Any technical decisions or tradeoffs worth noting?"
3. "Anything not captured here? Pairing, mentoring, debugging, design work?"
4. "Any measurable outcomes? Numbers, improvements, coverage?"
5. "Who benefited? Your team, other teams, customers?"
6. "What do you want to focus on or improve next week?"

### 5. Assemble the brag doc

Use this template. **Omit any section that would be empty** — no placeholder stubs. Highlights and What I Shipped are always present.

```markdown
---
date: $FRIDAY
week: "$MON_DISPLAY - $FRI_DISPLAY"
tags:
  - brag-doc
---

# Week of $MON_DISPLAY – $FRI_DISPLAY

## Highlights
- The 1-3 biggest wins, written with context and impact (not just titles)

## What I Shipped
- PRs grouped by feature/area, with links
- e.g. "Integrations: revamped credential flow (#4737), synced workflow data (#4777)"

## Reviews & Collaboration
- Notable code reviews, pairing sessions, mentoring
- Design discussions, architecture decisions

## Decisions
- Technical tradeoffs made and why

## Impact
- Who benefited and how
- Any metrics: endpoints covered, bugs fixed, time saved, etc.

## Open Threads
- Issues opened, spikes started, things still in progress

## Next Week
- What to focus on, improve, or follow up on
```

Write highlights and shipped items with context — not just PR titles. Group related PRs together by feature or area.

### 6. Write the file

```bash
YEAR=$(echo $FRIDAY | cut -d- -f1)
mkdir -p "/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR"
```

Write the assembled doc to: `/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR/$FRIDAY.md`

If the file already exists, overwrite it (Milo may be iterating on the same week's doc).

### 7. Offer clipboard copy

After writing, ask Milo if he wants the doc copied to clipboard. If yes:

```bash
cat "/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR/$FRIDAY.md" | pbcopy
```

### 8. Alert about quarterly brag

After writing, if it's been a full quarter for the year offer to run `/quarterly-brag`.

## Edge Cases

- **Not Monday:** Still works — defaults to last week's Monday–Friday range
- **Run twice in same week:** Overwrites the same file, but ask for merge if relevant
- **No GitHub activity:** Still ask questions — could be a meetings/planning/mentoring week
- **gh not authenticated:** The queries will fail — tell Milo to run `gh auth login` and stop
