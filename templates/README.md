# Templates

Page templates for creating new brain pages.

## Purpose

Provide starting structure for different page types:
- Copy → Fill in → Done

## Available Templates

| Template | Use When |
|----------|----------|
| `person.md` | Creating a person page |
| `company.md` | Creating a company page |
| `meeting.md` | Creating a meeting record |
| `project.md` | Creating a project page |
| `concept.md` | Creating a concept page |
| `deal.md` | Creating a deal page |

## How to Use

```bash
# Copy template to target directory
cp templates/person.md people/jane-doe.md

# Edit with actual content
nano people/jane-doe.md
```

## Template Structure

All templates follow the two-layer structure:

**Above `---`**: Compiled truth (current state)
**Below `---`**: Timeline (append-only evidence)

## Customizing Templates

Templates are starting points, not rigid rules:
- Add sections as needed
- Remove irrelevant sections
- Adapt to your specific use case

## Creating New Templates

To create a new template:

1. Identify a recurring page type
2. Extract common structure
3. Create `templates/your-template.md`
4. Document in this README

---

Templates reduce friction. Copy, fill, commit.
