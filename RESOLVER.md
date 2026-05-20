# RESOLVER — The Filing Decision Tree

**Read this BEFORE creating any brain page.** Every piece of knowledge has exactly one home.

---

## Decision Tree

**Start here: what is the primary subject?**

1. **A specific named person** → `people/`
2. **A specific organization** (company, fund, nonprofit) → `companies/`
3. **A financial transaction** with terms and a decision → `deals/`
4. **A record of a specific meeting/call** → `meetings/`
5. **Something being actively built** (repo, spec, team) → `projects/`
6. **A raw possibility** nobody is building yet → `ideas/`
7. **A reusable mental model or framework** → `concepts/`
8. **Prose that could be published** → `writing/`
9. **Your organization's strategy and operations** → `org/`
10. **Public narrative or content operations** → `media/`
11. **A major life program** (enduring commitment) → `programs/`
12. **Private notes and reflections** → `personal/`
13. **Raw data imports or snapshots** → `sources/`
14. **Reusable LLM prompts** → `prompts/`
15. **Unsorted / quick capture** → `inbox/`
16. **Dead / no longer relevant** → `archive/`

---

## Disambiguation Rules

When two directories seem to fit, apply these tiebreakers:

| Confusion | Rule |
|-----------|------|
| Person vs. Company | Page about *them as a human* → people/. About *the organization* → companies/. Link both. |
| Concept vs. Idea | Could you *teach* it? → concept. Could you *build* it? → idea. |
| Concept vs. Personal | Would you share in a professional talk? → concept. Private reflection? → personal. |
| Idea vs. Project | Is anyone working on it? Yes → project. No → idea. |
| Writing vs. Concepts | Concepts are distilled (200 words). Writing is developed prose. |
| Writing vs. Media | Writing is the *artifact*. Media is *distribution infrastructure*. |
| Org vs. Programs | org/ is knowledge *about* the organization. programs/ is your role within it. |
| Sources vs. .raw/ | Per-entity data → .raw/ sidecar. Bulk imports → sources/. |

---

## MECE Check

Every piece of knowledge passes through this tree and lands in **exactly one directory**. 

If something genuinely doesn't fit any category:
1. File in `inbox/`
2. Flag it for schema evolution

---

## Page Naming Convention

| Type | Pattern | Example |
|------|---------|---------|
| Person | `first-last.md` | `john-smith.md` |
| Company | `company-name.md` | `acme-corp.md` |
| Meeting | `YYYY-MM-DD-topic.md` | `2026-05-20-product-review.md` |
| Project | `project-name.md` | `mobile-app-v2.md` |
| Idea | `idea-name.md` | `ai-code-review-bot.md` |
| Concept | `concept-name.md` | `first-principles-thinking.md` |

**Collisions?** Disambiguate: `david-liu-acme.md`, `david-liu-techcorp.md`

---

## Before Creating

1. **Search first** — Does a page already exist?
   ```bash
   grep -rl "Entity Name" ~/brain/ --include="*.md"
   ```

2. **Check aliases** — Search `.raw/` sidecars for matching emails/handles

3. **If found** → UPDATE existing page (add alias if name variant is new)

4. **If not found** → CREATE new page using templates in `templates/`

---

## The Enrichment Protocol

After creating or updating any person/company page:

1. **Tier 1 (Key relationships):** Full enrichment — network search, APIs, semantic search
2. **Tier 2 (Moderate relevance):** Web search + social + brain cross-reference
3. **Tier 3 (Minor mentions):** Extract signal from source only

Tier escalates based on: meeting attendance, email exchanges, relationship signals.

---

*This resolver is your contract. When in doubt, read this first.*
