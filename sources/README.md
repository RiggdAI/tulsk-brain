# Sources

Raw data imports and snapshots. Unprocessed inputs.

## Purpose

Store original data before processing:
- Email exports
- API responses
- Database dumps
- Document imports

## What Goes Here

| Type | Examples |
|------|----------|
| Email exports | Mbox files, email threads |
| API data | JSON responses, CSV exports |
| Documents | PDFs, transcripts |
| Backups | Snapshots, archives |

## Sources vs .raw/

| Location | Purpose |
|----------|---------|
| `sources/` | Bulk imports, unprocessed data |
| `.raw/` sidecars | Per-entity raw data alongside pages |

## Processing Flow

```
sources/          →   brain pages
(raw data)            (compiled truth)
    ↓
  Process
    ↓
people/.raw/
companies/.raw/
```

## Naming Convention

```
sources/
├── 2026-05-20-linkedin-export/
│   ├── connections.csv
│   └── messages.json
├── 2026-05-15-email-export/
│   └── inbox.mbox
└── 2026-05-10-calendar-export/
    └── events.ics
```

## Processing Scripts

After importing to `sources/`:
1. Write a script to parse the data
2. Create/update brain pages
3. Store processed result in `.raw/` sidecars

---

Sources are raw material. Process them into knowledge.
