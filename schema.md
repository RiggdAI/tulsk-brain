# schema.md — Page Conventions and Templates

This defines the structure and conventions for all brain pages.

---

## Two-Layer Structure

Every brain page has two layers, separated by `---`:

**Above the line — Compiled Truth**
- Always current, always rewritten when new information arrives
- Starts with executive summary (one paragraph)
- Followed by structured State fields
- Open Threads (active items)
- See Also (cross-links)

**Below the line — Timeline**
- Append-only, never rewritten
- Reverse-chronological evidence log
- Each entry: date, source, what happened

---

## Page Templates

### Person Page

```markdown
# Person Name

> Executive summary: who they are, why they matter.

## State
- **Role:** Current title
- **Company:** Current org
- **Relationship:** To you (friend, colleague, investor, etc.)
- **Key context:** 2-4 bullets of what matters right now

## What They Believe
Worldview, positions, first principles.
- [Belief] — observed: [source, date]
- [Belief] — self-described: [source, date]

## What They're Building
Current projects, recent ships.

## What Motivates Them
Ambition drivers, career arc.

## Communication Style
How they prefer to communicate. How they handle disagreement.

## Assessment
- **Strengths:** What they're great at
- **Gaps:** Where they could grow
- **Net read:** One-line synthesis
- **Confidence:** high (5+ interactions) / medium (2-4) / low (1)
- **Last assessed:** YYYY-MM-DD

## Network
- **Close to:** People they're frequently seen with
- **Crew:** Which cluster they belong to

## Open Threads
- Active items, pending follow-ups

## Contact
- Email, phone, LinkedIn, X handle, location

---

## Timeline
- **YYYY-MM-DD** | Source — What happened.
```

### Company Page

```markdown
# Company Name

> What they do, stage, why they matter.

## State
- **What:** One-line description
- **Stage:** Seed / Series A / Growth
- **Headquarters:** Location
- **Founded:** Year
- **Key context:** 2-4 bullets of current state

## Business Model
How they make money. Unit economics if known.

## Team
- **CEO:** Name
- **Key hires:** Notable team members

## Funding
| Round | Amount | Date | Lead |
|-------|--------|------|------|
| Series A | $X | YYYY | Fund Name |

## Why They Win
Competitive advantage, moat.

## Risks
Key concerns, challenges.

## Relationship
Your connection to this company.

## Open Threads
- Active items

---

## Timeline
- **YYYY-MM-DD** | Source — What happened.
```

### Meeting Page

```markdown
# YYYY-MM-DD Meeting Title

> One-paragraph summary of what happened and why it matters.

## Attendees
- Person A (role)
- Person B (role)

## Key Decisions
- Decision 1
- Decision 2

## Action Items
- [ ] Item 1 — @owner
- [ ] Item 2 — @owner

## Open Questions
- Question 1
- Question 2

## Cross-References
- [[people/person-a]]
- [[companies/company-x]]

---

## Analysis
Your synthesis of what this meeting means.

---

## Timeline
- **YYYY-MM-DD** | Meeting — Full context.
```

### Project Page

```markdown
# Project Name

> What it is, current status, why it matters.

## State
- **Status:** Active / Paused / Complete
- **Owner:** Who's responsible
- **Started:** YYYY-MM-DD
- **Target:** Completion date

## Objectives
- Goal 1
- Goal 2

## Key Decisions
| Decision | Rationale | Date |
|----------|-----------|------|
| Decision 1 | Why | YYYY-MM-DD |

## Blockers
- Blocker 1 — status

## Next Steps
- [ ] Step 1
- [ ] Step 2

## Cross-References
- [[people/owner]]
- [[companies/stakeholder]]

---

## Timeline
- **YYYY-MM-DD** | Source — What happened.
```

### Concept Page

```markdown
# Concept Name

> One-paragraph definition of the concept.

## The Core Idea
What it is, in simple terms.

## Why It Matters
Why this concept is useful.

## How To Apply It
Practical applications.

## Related Concepts
- [[concepts/related-concept-1]]
- [[concepts/related-concept-2]]

## Sources
- [Source 1](url) — author, date

---

## Timeline
- **YYYY-MM-DD** | Source — When you learned this.
```

---

## Frontmatter Convention

Use YAML frontmatter for structured metadata:

```yaml
---
aliases: ["Jane Doe", "J. Doe", "jane@email.com"]
tags: [investor, ai, enterprise]
created: 2026-05-20
updated: 2026-05-20
---
```

---

## Cross-Reference Syntax

Use wikilinks to connect entities:

```markdown
Met with [[people/jane-doe]] from [[companies/acme-corp]].
Referenced [[concepts/first-principles-thinking]].
Working on [[projects/mobile-app-v2]].
```

---

## Epistemic Discipline

### Sourcing Claims

Every claim in high-value sections (Beliefs, Assessment, Motivations) must cite:

| Source Type | Format |
|-------------|--------|
| Observed | `[Claim] — observed: [meeting name, date]` |
| Self-described | `[Claim] — self-described: [interview, date]` |
| Inferred | `[Claim] — inferred: [pattern, confidence: high/med/low]` |

### Confidence Levels

| Interactions | Confidence |
|--------------|------------|
| 1 | low |
| 2-4 | medium |
| 5+ | high |

### Never

- Generalize from a single data point
- Write assessments without sources
- State opinions as facts
- Omit dates on claims

---

## .raw/ Sidecars

Store raw API responses, email text, meeting transcripts in `.raw/`:

```
people/
├── jane-doe.md
└── .raw/
    └── jane-doe.json    # LinkedIn API, enrichment data
```

Naming: `<slug>.json` or `<slug>-<source>.json`

---

*This schema evolves. When you find something that doesn't fit, flag it.*
