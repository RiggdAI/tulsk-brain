---
name: git-auth-setup
description: Setup Git authentication for GitHub and GitLab (CLI, tokens, SSH keys)
triggers:
  - setup github
  - setup gitlab
  - configure git auth
  - git authentication
---

# Git Authentication Setup

Automated setup for GitHub and GitLab authentication including CLI tools, tokens, and SSH keys.

## Quick Start

```bash
# Download and run
curl -O https://raw.githubusercontent.com/RiggdAI/tulsk-brain/main/skills/git-auth-setup/scripts/setup-git-auth.sh
chmod +x setup-git-auth.sh

# Setup GitHub only
./setup-git-auth.sh \
  --github-token ghp_xxx \
  --github-user myuser \
  --email me@example.com \
  --name "My Name"

# Setup both GitHub and GitLab
./setup-git-auth.sh \
  --github-token ghp_xxx \
  --gitlab-token glpat-xxx \
  --github-user ghuser \
  --gitlab-user gluser \
  --email me@example.com \
  --name "My Name"
```

## What the Script Does

1. **Installs CLI tools** (if not present)
   - GitHub CLI (`gh`) - for GitHub operations
   - GitLab CLI (`glab`) - for GitLab operations

2. **Configures git identity**
   - Sets global `user.name` and `user.email`

3. **Stores tokens**
   - Saves tokens to `~/.env` for cross-profile access

4. **Generates SSH key** (optional, default: yes)
   - Creates `~/.ssh/id_ed25519` if not exists
   - Uploads public key to GitHub/GitLab via API

5. **Verifies authentication**
   - Tests tokens against API
   - Reports authenticated user

## Options

| Flag | Description | Required |
|------|-------------|----------|
| `--github-token TOKEN` | GitHub personal access token | If using GitHub |
| `--gitlab-token TOKEN` | GitLab personal access token | If using GitLab |
| `--github-user USER` | GitHub username | Optional |
| `--gitlab-user USER` | GitLab username | Optional |
| `--email EMAIL` | Git commit email | Yes |
| `--name NAME` | Git commit name | Yes |
| `--ssh-key-email EMAIL` | Email for SSH key (default: git email) | No |
| `--no-ssh` | Skip SSH key generation/upload | No |

## Token Requirements

### GitHub Token Scopes
- `repo` - Full repository access
- `user` - Read user profile
- `admin:public_key` - Manage SSH keys (for upload)

### GitLab Token Scopes
- `api` - Full API access
- `read_user` - Read user profile
- `write_ssh_key` - Manage SSH keys (for upload)

## Environment Variables

After setup, tokens are available via:

```bash
source ~/.env

# Use in scripts
gh repo list  # Uses GITHUB_TOKEN
glab repo list  # Uses GITLAB_TOKEN
```

## SSH Authentication

Test SSH connections:

```bash
ssh -T git@github.com  # Should show "Hi user! You've successfully authenticated"
ssh -T git@gitlab.com  # Should show "Welcome to GitLab, @user!"
```

Clone via SSH:

```bash
git clone git@github.com:org/repo.git
git clone git@gitlab.com:org/repo.git
```

## Multi-Profile Usage

Each profile can have its own authentication:

```bash
# Profile 1
HERMES_PROFILE_DIR=~/.hermes-profile1 ./setup-git-auth.sh --github-token ghp_xxx ...

# Profile 2
HERMES_PROFILE_DIR=~/.hermes-profile2 ./setup-git-auth.sh --gitlab-token glpat-xxx ...
```

## Pitfalls

1. **Token already exists on account** - Script handles this gracefully (422 error)

2. **No sudo access** - Script downloads pre-built binaries to `~/.local/bin`

3. **SSH key upload fails** - Check token has `admin:public_key` (GitHub) or `write_ssh_key` (GitLab) scope

4. **gh/glab not found** - Add `~/.local/bin` to PATH: `source ~/.bashrc`

## Related Skills

- `agent-git-identity` - Git commit author configuration
- `github-setup` - GitHub-specific setup (LLM-guided version)
- `messaging-platforms` - Messaging platform authentication

## Scripts

- `scripts/setup-git-auth.sh` - Main setup script
