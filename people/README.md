# People Directory

One page per person. The most important pages in your brain.

## What goes here

- Specific named individuals you interact with or track
- People you meet, email, or follow
- People mentioned in conversations or documents

## What does NOT go here

- Fictional characters → `concepts/` (as cultural references)
- Generic personas → `concepts/` (as frameworks)
- Organizations → `companies/`

## Naming convention

- `first-last.md` — e.g., `jane-doe.md`
- Disambiguate collisions: `david-liu-acme.md`, `david-liu-techcorp.md`

## Page structure

See `templates/person.md` for the full template.

Key sections:
- **State:** Current role, company, relationship
- **What They Believe:** Worldview with sources
- **Assessment:** Strengths, gaps, confidence
- **Network:** Connections to other people
- **Open Threads:** Active follow-ups
- **Timeline:** Append-only evidence log

## Enrichment

Every person page should be enriched based on tier:
- **Tier 1:** Key relationships → full enrichment
- **Tier 2:** Moderate relevance → web + social
- **Tier 3:** Minor mentions → source extraction only

## .raw/ sidecar

Store raw API responses, LinkedIn data, enrichment results in `.raw/`:
```
people/
├── jane-doe.md
└── .raw/
    └── jane-doe.json
```
