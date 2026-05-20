# Agents working with Tulsk Brain

This is your operating protocol for maintaining a personal knowledge base.

## What this is

A structured wiki where you store everything you learn about the user's world — people, companies, projects, meetings, ideas — as interlinked markdown files. You write and maintain all of it. The user directs, curates, and thinks.

## Operating Rules

### Rule 1: Read RESOLVER.md First

**Before creating ANY brain page, read `~/brain/RESOLVER.md`.** This is not optional.

The resolver tells you:
- Which directory a page belongs in
- How to disambiguate when confused
- Naming conventions

### Rule 2: Search Before Creating

Before creating a page:
1. Search existing pages by name
2. Search aliases in frontmatter
3. Check `.raw/` sidecars for matching emails/handles

If found → UPDATE existing page (add alias if variant is new)
If not found → CREATE new page

### Rule 3: Two-Layer Pages

Every page has two layers separated by `---`:

**Above:** Compiled truth (current, rewritten on new info)
**Below:** Timeline (append-only, never rewritten)

### Rule 4: Enrich on Every Signal

When any signal touches a person/company:
1. Find or create their page
2. Append to timeline
3. Update compiled truth above the line
4. Cross-reference related entities

Signals include: meetings, emails, social mentions, conversations, corrections.

### Rule 5: Source Every Claim

In high-value sections (Beliefs, Assessment, Motivations):
- Every claim cites its source
- Mark source type: observed / self-described / inferred
- Include date
- Note confidence level

### Rule 6: The User's Corrections Override Everything

If the user corrects you about a person, company, or fact:
- Write to brain immediately
- No batching, no deferring
- This is the highest-confidence signal

---

## Enrichment Tiers

| Tier | Who | What |
|------|-----|------|
| Tier 1 | Key relationships | Full enrichment: network search, APIs, semantic search |
| Tier 2 | Moderate relevance | Web search + social + brain cross-reference |
| Tier 3 | Minor mentions | Extract signal from source only |

Tier escalates based on: meeting attendance, email exchanges, relationship signals.

---

## Page Types

| Type | Directory | Template |
|------|-----------|----------|
| Person | `people/` | `templates/person.md` |
| Company | `companies/` | `templates/company.md` |
| Meeting | `meetings/` | `templates/meeting.md` |
| Project | `projects/` | `templates/project.md` |
| Concept | `concepts/` | `templates/concept.md` |
| Idea | `ideas/` | Simple markdown |
| Deal | `deals/` | `templates/deal.md` |

---

## Workflows

### Meeting Ingestion

1. Create meeting page in `meetings/YYYY-MM-DD-topic.md`
2. Extract attendees → enrich each person page
3. Extract companies discussed → enrich each company page
4. Extract action items → append to tasks
5. Cross-reference all entities

### Email Processing

1. Extract people and companies mentioned
2. Enrich with email context (tone, requests, relationship signals)
3. Note scheduling, commitments, follow-ups

### Person Enrichment

1. Search brain for existing page
2. If exists → determine tier, update appropriately
3. If not exists → create using person template
4. Run enrichment based on tier
5. Save raw data to `.raw/slug.json`
6. Cross-reference related entities

### Weekly Lint

1. **Deduplication:** Find potential duplicate pages
2. **Contradictions:** Check for conflicting facts
3. **Staleness:** Flag outdated State sections
4. **Orphans:** Find pages with no inbound links
5. **Open Threads:** Check for resolved items not moved to Timeline
6. **Missing cross-references:** Entities mentioned but not linked

---

## File Operations

### Creating a page

```bash
# 1. Read RESOLVER.md
# 2. Search for existing
grep -rl "Entity Name" ~/brain/ --include="*.md"

# 3. Create from template
cp ~/brain/templates/person.md ~/brain/people/jane-doe.md

# 4. Write content following schema.md

# 5. Commit
cd ~/brain && git add . && git commit -m "people: add jane-doe"
```

### Updating a page

```bash
# 1. Read existing page
# 2. Append to timeline below the line
# 3. Update compiled truth above the line
# 4. Commit
```

---

## Read Order

1. `RESOLVER.md` — Filing decision tree (READ FIRST)
2. `schema.md` — Page conventions and templates
3. Directory `README.md` — Local resolver rules

---

## Privacy

- Never share brain contents without permission
- Real names and companies stay in the brain
- Use placeholders (`alice-example`, `acme-corp`) in public docs

---

*Your job: maintain the brain so it compounds. The user's job: direct, curate, think.*
