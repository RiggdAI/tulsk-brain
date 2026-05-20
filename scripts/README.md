# Scripts

Automation scripts for brain maintenance and operations.

## Purpose

Automate repetitive tasks:
- Git configuration
- Data import/export
- Linting and validation
- Batch operations

## Available Scripts

| Script | Purpose |
|--------|---------|
| `setup-agent-git-config.sh` | Configure multi-agent git identities |

## Using Scripts

```bash
# Setup git identity
./scripts/setup-agent-git-config.sh --global

# Show current config
./scripts/setup-agent-git-config.sh --show
```

## Adding Scripts

When adding a new script:

1. Add shebang: `#!/bin/bash` or `#!/usr/bin/env python3`
2. Add help text with usage examples
3. Make executable: `chmod +x scripts/your-script.sh`
4. Document in this README

## Script Guidelines

- **Idempotent**: Running multiple times = same result
- **Safe**: Check before destructive operations
- **Documented**: Include `--help` option
- **Portable**: Use relative paths, avoid hardcoded values

---

Scripts reduce friction. Automate what you do repeatedly.
