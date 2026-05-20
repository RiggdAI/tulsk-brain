# Tulsk Brain

> A personal knowledge base for your Hermes agent. Your AI builds and maintains it.

This is a template knowledge base for [Tulsk](https://tulsk.io) and [Hermes](https://hermes-agent.dev) users. Clone it to start your own brain, then let your agent build the rest.

## What this is

A structured wiki where your AI agent stores everything it learns about your world — people, companies, projects, meetings, ideas — as interlinked markdown files. The agent writes and maintains all of it. You direct, curate, and think.

**The key insight:** knowledge management has failed for 30 years because maintenance falls on humans. LLM agents change the equation — they don't get bored, don't forget to update cross-references, and can touch 50 files in one pass. Your brain stays alive because the cost of maintenance is near zero.

## Quick start

```bash
# Clone this template
git clone https://github.com/RiggdAI/tulsk-brain.git ~/brain

# Point your Hermes profile to this brain
# In your SOUL.md or AGENTS.md, add:
# "Read ~/brain/RESOLVER.md before creating any brain page."
```

Your agent will create directories as needed — no empty folders pushed to GitHub.

## How it works

1. **Every piece of knowledge has ONE home** — MECE directories with explicit resolver rules
2. **Two-layer pages** — Compiled truth (current state) above the line, timeline (evidence) below
3. **Enrichment on every signal** — meetings, emails, mentions trigger automatic page updates

## Directory structure

```
brain/
├── RESOLVER.md        — Master decision tree (READ FIRST)
├── schema.md          — Page conventions and templates
├── people/            — One page per person
├── companies/         — One page per organization
├── deals/             — Financial transactions with terms
├── meetings/          — Meeting records with analysis
├── projects/          — Active work with specs
├── ideas/             — Possibilities not yet built
├── concepts/          — Mental models and frameworks
├── writing/           — Essays and drafts
├── programs/          — Major life workstreams
├── org/               — Organization strategy and operations
├── media/             — Public narrative and content
├── personal/          — Private notes and reflections
├── sources/           — Raw data imports
├── prompts/           — Reusable LLM prompts
├── inbox/             — Unsorted quick captures
└── archive/           — Dead pages, historical record
```

## For AI Agents

Read `AGENTS.md` for the full operating protocol. Read `RESOLVER.md` before creating any page.

## Principles

| Principle | Description |
|-----------|-------------|
| MECE | Every piece of knowledge → exactly one directory |
| Two-layer | Compiled truth above, timeline below |
| Enrich on signal | Every meeting/email/mention triggers updates |
| Source everything | Claims cite their source and date |
| Cross-reference | Entities link to related entities |

## Why this works

Unlike RAG which re-derives knowledge on every query, the brain pre-computes synthesis and keeps it current:

- **Cross-references are pre-built** — Person A works at Company B is already linked
- **Contradictions are pre-flagged** — Conflicts resolved during ingest, not at query time
- **The compilation is persistent** — Each source makes the brain richer
- **The structure itself is a prompt** — Empty sections tell the agent what to look for

---

Built by [Riggd](https://riggd.ai) for Tulsk and Hermes users. Based on [gbrain](https://github.com/garrytan/gbrain) architecture.
