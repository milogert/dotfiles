---
name: yearly-brag
description: Synthesize a year of brag docs into an annual reflection. Best run in late December. Usage: /yearly-brag 2026 (defaults to current year).
---

# Yearly Brag Doc Generator

Read quarterly summaries (preferred) and weekly brag docs for a given year, have a real conversation with Milo about his growth, and produce an annual reflection doc. This is not a status report — it's a career artifact meant to capture the arc of the year: what changed, what mattered, and where Milo is heading as an engineer.

## Tone

The weekly and quarterly docs are operational — what shipped, what got reviewed, what's next. The yearly doc zooms out. It should read like something Milo wrote for himself at the end of the year, sitting back and thinking honestly about the year. Direct, reflective, no corporate filler. The kind of thing that's useful to re-read a year later.

Avoid:
- Listing every PR or project — that's what the quarterly docs are for
- Generic filler like "continued to grow as an engineer"
- Performative language written to impress a manager
- Bullet-point dumps without narrative thread

Aim for:
- Honest assessment of what went well and what didn't
- Specific examples that illustrate growth, not just claims
- The "so what" — why the year's work mattered to Milo's trajectory
- Candid reflection on skills, gaps, and evolving interests

## Steps

### 1. Parse arguments

Extract year from the arguments. Default to the current year if omitted or if this is run in the first weeks of January use the previous year.

- `YEAR` — e.g. 2026

### 2. Read existing docs

Read in this priority order — quarterly docs are already synthesized and give better signal:

**First, look for quarterly summaries:**

Glob for `/Users/milo/Obsidian/Personal/Career/Brag Docs/YEAR/Q*-YEAR.md` (e.g. `Q1-2026.md`, `Q2-2026.md`). Read all that exist.

**Then, read weekly docs for quarters without a quarterly summary:**

If any quarter is missing a quarterly doc, glob for `/Users/milo/Obsidian/Personal/Career/Brag Docs/YEAR/*.md`, filter to files whose date falls within the uncovered quarter(s), and read those. Exclude the quarterly and yearly summary files themselves.

This avoids reading 50+ weekly files when quarterly summaries already exist, while still capturing quarters that weren't summarized.

If **no docs at all** are found for the year, tell Milo and continue to step 3.

### 3. Have a conversation with Milo

This is the most important step. The yearly doc is only as good as the reflection that goes into it. Ask these questions **one at a time** using AskUserQuestion, each with a free-text "Skip" option.

The questions should feel like a thoughtful end-of-year conversation, not a form to fill out:

1. "Looking back at the year — what are you most proud of? Not just what shipped, but what felt meaningful."
2. "What was the hardest thing you dealt with this year? A technical problem, a team dynamic, a decision you weren't sure about."
3. "How did your role or responsibilities change over the year? Any shifts in scope, ownership, or how people rely on you?"
4. "What skills got sharper this year? Anything you can do now that you couldn't (or wouldn't) a year ago?"
5. "What didn't go the way you wanted? Things you'd do differently, or areas where you felt stuck."
6. "Where do you want to be as an engineer a year from now? Not job title — what do you want to be capable of, known for, or working on?"

### 4. Synthesize the yearly doc

Using the docs and Milo's answers, write the annual reflection. **Omit any section that would be empty.** The sections below are a guide, not a rigid template — adapt headings to fit what actually happened.

Template:

```markdown
---
date: YEAR-12-31
year: "YEAR"
tags:
  - brag-doc
  - yearly
---

# YEAR

## The Year in a Paragraph
- A short narrative (3-5 sentences) capturing the arc of the year: where Milo started, what defined the year, where he ended up. This is the section someone (including future Milo) reads to quickly remember what this year was about.

## What Mattered Most
- The 3-5 things that defined the year, written with enough context to still make sense in 2 years. Not a highlight reel — the things that actually moved the needle on Milo's career, skills, or trajectory.

## The Work
- A concise narrative of the year's major projects and areas of ownership, organized by theme or arc (not by quarter). Each theme covers what was built, why it mattered, and how it evolved over the year.
- Link to quarterly docs for detail: [Q1](./Q1-YEAR.md), [Q2](./Q2-YEAR.md), etc.

## Growth
- Specific ways Milo grew as an engineer. Technical skills, judgment, communication, leadership, craft — whatever actually shifted. Back claims with examples from the year.

## Hard Stuff
- The difficult problems, failures, or frustrations. What happened, what Milo learned, what (if anything) changed as a result. This section is for Milo, not for a review — honesty matters more than spin.

## Decisions That Shaped the Year
- The most consequential technical or career decisions, with context on what was at stake and how they played out.

## Impact
- Who benefited from Milo's work and how. Team, org, customers, community. Specific where possible.

## Next Year
- Where Milo wants to go. Not vague aspirations — concrete areas of focus, skills to develop, problems to tackle, or changes to make. The kind of thing he can check against in 12 months.
```

Writing guidelines:
- Write in a direct, first-person-adjacent tone — as if Milo is narrating his own year
- Use specific examples, not generalizations. "Owned the integrations platform from design through production" beats "took on more ownership"
- Connect the dots across quarters — surface the arcs, not just the events
- "The Work" should be narrative, not a bullet dump. Group by theme/arc across the year, not chronologically by quarter
- "Growth" should be honest. It's fine to say "got better at X but still struggling with Y"
- "Next Year" should be forward-looking and specific enough to be actionable

### 5. Write the file

```bash
mkdir -p "/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR"
```

Write the assembled doc to: `/Users/milo/Obsidian/Personal/Career/Brag Docs/YEAR/YEAR.md`

Example: `/Users/milo/Obsidian/Personal/Career/Brag Docs/2026/2026.md`

If the file already exists, overwrite it.

### 6. Offer clipboard copy

After writing, ask Milo if he wants the doc copied to clipboard. If yes:

```bash
cat "/Users/milo/Obsidian/Personal/Career/Brag Docs/$YEAR/$YEAR.md" | pbcopy
```

## Edge Cases

- **No quarterly docs exist:** Fall back to reading all weekly docs for the year
- **No docs at all:** Tell Milo, still ask the conversation questions — the reflection can stand on its own
- **Partial year (e.g. started mid-year, or running before December):** Works fine — summarizes what exists, frame the doc accordingly
- **Run twice:** Overwrites the same file
- **Previous year's yearly doc exists:** Don't read it as input — this is a fresh reflection. But if Milo mentions wanting continuity, he can reference it himself
- **Enormous amount of source material:** Prefer quarterly summaries over weekly docs to keep context manageable. The yearly doc should be a synthesis, not a concatenation
