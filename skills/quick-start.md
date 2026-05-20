# Quick Start Skill

> 新用戶快速開始使用 Tulsk Brain

## Purpose

幫助新用戶在 5 分鐘內設定好 Tulsk Brain。

---

## Quick Start Steps

### 1. Clone the Brain

```bash
# Clone to home directory
git clone https://github.com/RiggdAI/tulsk-brain.git ~/brain

# Remove template git history and start fresh
cd ~/brain
rm -rf .git
git init
git add -A
git commit -m "Initial brain"
```

### 2. Configure Your Identity

```bash
# Edit agents.yaml with your details
nano agents.yaml

# Or use sed to replace placeholders
sed -i 's/Your Name/Your Actual Name/g' agents.yaml
sed -i 's/your-email@example.com/your-actual@email.com/g' agents.yaml
sed -i 's/your-github-username/your-github-username/g' agents.yaml
```

### 3. Setup Git Identity

```bash
# Run the setup script
./scripts/setup-agent-git-config.sh --global
```

### 4. Create Your First Pages

```bash
# Create a person page
cp templates/person.md people/john-doe.md
# Edit with your information

# Create a company page
cp templates/company.md companies/example-corp.md
# Edit with your information
```

### 5. Connect to Hermes

Add to your `SOUL.md` or `AGENTS.md`:

```markdown
Read ~/brain/RESOLVER.md before creating any brain page.
```

---

## First Week Tasks

| Day | Task |
|-----|------|
| 1 | Clone, configure, create first person page |
| 2 | Add 3-5 key people you work with |
| 3 | Add 2-3 companies you're tracking |
| 4 | Create your first meeting page |
| 5 | Add 1-2 projects you're working on |
| 6 | Run brain-maintenance lint |
| 7 | Review and refine structure |

---

## Common First Tasks

### Adding a Person

1. Check if they already exist: `grep -r "Name" ~/brain/people/`
2. Copy template: `cp templates/person.md people/slug-name.md`
3. Fill in sections
4. Commit: `git add . && git commit -m "people: add slug-name"`

### Adding a Meeting

1. Create file: `meetings/2026-05-20-meeting-topic.md`
2. Use template from `templates/meeting.md`
3. Extract attendees → link to their person pages
4. Extract action items
5. Commit

### Weekly Review

Run the brain-maintenance skill to lint your brain.

---

## Created

2026-05-20
