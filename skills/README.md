# Skills

Agent skills and workflows for maintaining your Tulsk Brain.

## Available Skills

| Skill | Purpose |
|-------|---------|
| [quick-start.md](quick-start.md) | Get started with Tulsk Brain in 5 minutes |
| [brain-maintenance.md](brain-maintenance.md) | Weekly lint and health check |
| [agent-git-identity.md](agent-git-identity.md) | Configure git commits with correct author |

## Using Skills

Hermes agents can load these skills with:

```bash
# View a skill
skill_view(name='quick-start')

# Or reference directly in SOUL.md
"Read ~/brain/skills/quick-start.md for setup instructions."
```

## Adding Skills

To add a new skill:

1. Create `skills/your-skill-name.md`
2. Include: Purpose, Triggers, Steps, Pitfalls
3. Follow the skill template from existing files

---

Skills are procedural knowledge — reusable workflows for common tasks.
