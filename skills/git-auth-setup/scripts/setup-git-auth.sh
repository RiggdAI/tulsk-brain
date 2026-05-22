#!/bin/bash
# Setup Git authentication for GitHub and/or GitLab
# Usage: ./setup-git-auth.sh --github-token xxx --gitlab-token xxx --email user@example.com --name "User Name"

set -e

# Default values
HERMES_PROFILE_DIR="${HERMES_PROFILE_DIR:-$HOME/.hermes}"
ENV_FILE="$HOME/.env"

GITHUB_TOKEN=""
GITLAB_TOKEN=""
GIT_EMAIL=""
GIT_NAME=""
GITHUB_USER=""
GITLAB_USER=""
GENERATE_SSH="${GENERATE_SSH:-true}"
SSH_KEY_EMAIL=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --github-token)
            GITHUB_TOKEN="$2"
            shift 2
            ;;
        --gitlab-token)
            GITLAB_TOKEN="$2"
            shift 2
            ;;
        --github-user)
            GITHUB_USER="$2"
            shift 2
            ;;
        --gitlab-user)
            GITLAB_USER="$2"
            shift 2
            ;;
        --email)
            GIT_EMAIL="$2"
            shift 2
            ;;
        --name)
            GIT_NAME="$2"
            shift 2
            ;;
        --ssh-key-email)
            SSH_KEY_EMAIL="$2"
            shift 2
            ;;
        --no-ssh)
            GENERATE_SSH="false"
            shift
            ;;
        --env-file)
            ENV_FILE="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Setup Git authentication for GitHub and/or GitLab."
            echo ""
            echo "Options:"
            echo "  --github-token TOKEN   GitHub personal access token"
            echo "  --gitlab-token TOKEN   GitLab personal access token"
            echo "  --github-user USER     GitHub username (for git identity)"
            echo "  --gitlab-user USER     GitLab username (for git identity)"
            echo "  --email EMAIL          Git commit email"
            echo "  --name NAME            Git commit name"
            echo "  --ssh-key-email EMAIL  Email for SSH key (default: git email)"
            echo "  --no-ssh               Skip SSH key generation/upload"
            echo "  --env-file PATH        Path to .env file (default: ~/.env)"
            echo ""
            echo "Environment variables (alternative to flags):"
            echo "  GITHUB_TOKEN, GITLAB_TOKEN"
            echo "  GIT_EMAIL, GIT_NAME"
            echo "  GITHUB_USER, GITLAB_USER"
            echo ""
            echo "Examples:"
            echo "  # Setup GitHub only"
            echo "  $0 --github-token ghp_xxx --github-user myuser --email me@example.com --name 'My Name'"
            echo ""
            echo "  # Setup both GitHub and GitLab"
            echo "  $0 --github-token ghp_xxx --gitlab-token glpat-xxx \\"
            echo "     --github-user ghuser --gitlab-user gluser \\"
            echo "     --email me@example.com --name 'My Name'"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Use environment variables as fallback
GITHUB_TOKEN="${GITHUB_TOKEN:-$GITHUB_TOKEN}"
GITLAB_TOKEN="${GITLAB_TOKEN:-$GITLAB_TOKEN}"
GIT_EMAIL="${GIT_EMAIL:-$GIT_EMAIL}"
GIT_NAME="${GIT_NAME:-$GIT_NAME}"
GITHUB_USER="${GITHUB_USER:-$GITHUB_USER}"
GITLAB_USER="${GITLAB_USER:-$GITLAB_USER}"

# Validate at least one token provided
if [[ -z "$GITHUB_TOKEN" && -z "$GITLAB_TOKEN" ]]; then
    echo "Error: At least one of --github-token or --gitlab-token is required"
    exit 1
fi

# Validate git identity if any token provided
if [[ -z "$GIT_EMAIL" || -z "$GIT_NAME" ]]; then
    echo "Error: --email and --name are required for git identity"
    exit 1
fi

SSH_KEY_EMAIL="${SSH_KEY_EMAIL:-$GIT_EMAIL}"

echo "=== Git Authentication Setup ==="
echo ""

# ============================================
# Install GitHub CLI if needed
# ============================================
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "[GitHub] Checking gh CLI..."
    if ! command -v gh &> /dev/null; then
        echo "[GitHub] Installing gh CLI..."
        cd /tmp
        GH_VERSION="2.42.1"
        curl -sSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" -o gh.tar.gz
        tar -xzf gh.tar.gz
        mkdir -p ~/.local/bin
        cp "gh_${GH_VERSION}_linux_amd64/bin/gh" ~/.local/bin/gh
        chmod +x ~/.local/bin/gh
        rm -rf "gh_${GH_VERSION}_linux_amd64" gh.tar.gz
        echo "[GitHub] gh CLI installed to ~/.local/bin/gh"
    else
        echo "[GitHub] gh CLI already installed: $(gh --version | head -1)"
    fi
fi

# ============================================
# Install GitLab CLI if needed
# ============================================
if [[ -n "$GITLAB_TOKEN" ]]; then
    echo "[GitLab] Checking glab CLI..."
    if ! command -v glab &> /dev/null; then
        echo "[GitLab] Installing glab CLI..."
        cd /tmp
        GLAB_VERSION="1.37.0"
        curl -sSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_amd64.tar.gz" -o glab.tar.gz
        tar -xzf glab.tar.gz
        mkdir -p ~/.local/bin
        cp bin/glab ~/.local/bin/glab
        chmod +x ~/.local/bin/glab
        rm -rf bin LICENSE glab.tar.gz
        echo "[GitLab] glab CLI installed to ~/.local/bin/glab"
    else
        echo "[GitLab] glab CLI already installed: $(glab version 2>&1 | head -1)"
    fi
fi

# ============================================
# Ensure PATH includes ~/.local/bin
# ============================================
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "[Setup] Adding ~/.local/bin to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
fi

# ============================================
# Configure git identity globally
# ============================================
echo ""
echo "[Git] Setting global identity..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "[Git] user.name = $GIT_NAME"
echo "[Git] user.email = $GIT_EMAIL"

# ============================================
# Store tokens in .env file
# ============================================
echo ""
echo "[Setup] Storing tokens in $ENV_FILE..."
touch "$ENV_FILE"

# Remove existing entries
sed -i '/^GITHUB_TOKEN=/d' "$ENV_FILE" 2>/dev/null || true
sed -i '/^GITLAB_TOKEN=/d' "$ENV_FILE" 2>/dev/null || true
sed -i '/^GITHUB_USER=/d' "$ENV_FILE" 2>/dev/null || true
sed -i '/^GITLAB_USER=/d' "$ENV_FILE" 2>/dev/null || true

# Append new entries
{
    echo ""
    echo "# Git Authentication (added by setup-git-auth.sh)"
    if [[ -n "$GITHUB_TOKEN" ]]; then
        echo "GITHUB_TOKEN=$GITHUB_TOKEN"
        [[ -n "$GITHUB_USER" ]] && echo "GITHUB_USER=$GITHUB_USER"
    fi
    if [[ -n "$GITLAB_TOKEN" ]]; then
        echo "GITLAB_TOKEN=$GITLAB_TOKEN"
        [[ -n "$GITLAB_USER" ]] && echo "GITLAB_USER=$GITLAB_USER"
    fi
} >> "$ENV_FILE"
echo "[Setup] Tokens stored in $ENV_FILE"

# ============================================
# Generate SSH key if needed
# ============================================
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

if [[ "$GENERATE_SSH" == "true" ]]; then
    echo ""
    echo "[SSH] Checking SSH key..."
    if [[ ! -f "$SSH_KEY_PATH" ]]; then
        echo "[SSH] Generating new ed25519 SSH key..."
        mkdir -p ~/.ssh
        ssh-keygen -t ed25519 -C "$SSH_KEY_EMAIL" -f "$SSH_KEY_PATH" -N ""
        echo "[SSH] Key generated: $SSH_KEY_PATH"
    else
        echo "[SSH] SSH key already exists: $SSH_KEY_PATH"
    fi
fi

# ============================================
# Upload SSH key to GitHub via API
# ============================================
if [[ -n "$GITHUB_TOKEN" && -f "$SSH_KEY_PATH.pub" && "$GENERATE_SSH" == "true" ]]; then
    echo ""
    echo "[GitHub] Uploading SSH key..."
    SSH_PUBLIC_KEY=$(cat "$SSH_KEY_PATH.pub")
    KEY_TITLE="hermes-agent-$(hostname)-$(date +%Y%m%d)"
    
    # Use Python for API call (avoids terminal blocking issues)
    python3 << PYTHON_EOF
import urllib.request
import json
import os

token = "$GITHUB_TOKEN"
ssh_key = "$SSH_PUBLIC_KEY"
title = "$KEY_TITLE"

url = "https://api.github.com/user/keys"
data = json.dumps({"title": title, "key": ssh_key}).encode('utf-8')

req = urllib.request.Request(url, data=data, method='POST')
req.add_header('Authorization', f'token {token}')
req.add_header('Accept', 'application/vnd.github.v3+json')
req.add_header('Content-Type', 'application/json')

try:
    response = urllib.request.urlopen(req)
    print("[GitHub] SSH key uploaded successfully")
except urllib.error.HTTPError as e:
    if e.code == 422:
        print("[GitHub] SSH key already exists on account")
    else:
        print(f"[GitHub] Warning: Could not upload SSH key: {e.code}")
except Exception as e:
    print(f"[GitHub] Warning: Could not upload SSH key: {e}")
PYTHON_EOF
fi

# ============================================
# Upload SSH key to GitLab via API
# ============================================
if [[ -n "$GITLAB_TOKEN" && -f "$SSH_KEY_PATH.pub" && "$GENERATE_SSH" == "true" ]]; then
    echo ""
    echo "[GitLab] Uploading SSH key..."
    SSH_PUBLIC_KEY=$(cat "$SSH_KEY_PATH.pub")
    KEY_TITLE="hermes-agent-$(hostname)-$(date +%Y%m%d)"
    
    # Use Python for API call
    python3 << PYTHON_EOF
import urllib.request
import json

token = "$GITLAB_TOKEN"
ssh_key = "$SSH_PUBLIC_KEY"
title = "$KEY_TITLE"

url = "https://gitlab.com/api/v4/user/keys"
data = json.dumps({"title": title, "key": ssh_key}).encode('utf-8')

req = urllib.request.Request(url, data=data, method='POST')
req.add_header('PRIVATE-TOKEN', token)
req.add_header('Content-Type', 'application/json')

try:
    response = urllib.request.urlopen(req)
    print("[GitLab] SSH key uploaded successfully")
except urllib.error.HTTPError as e:
    if e.code == 400 or e.code == 422:
        print("[GitLab] SSH key already exists on account")
    else:
        print(f"[GitLab] Warning: Could not upload SSH key: {e.code}")
except Exception as e:
    print(f"[GitLab] Warning: Could not upload SSH key: {e}")
PYTHON_EOF
fi

# ============================================
# Verify GitHub authentication
# ============================================
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo ""
    echo "[GitHub] Verifying authentication..."
    python3 << PYTHON_EOF
import urllib.request
import json

token = "$GITHUB_TOKEN"
url = "https://api.github.com/user"

req = urllib.request.Request(url)
req.add_header('Authorization', f'token {token}')
req.add_header('Accept', 'application/vnd.github.v3+json')

try:
    response = urllib.request.urlopen(req)
    user = json.loads(response.read().decode())
    print(f"[GitHub] Authenticated as: {user.get('login', 'unknown')}")
    print(f"[GitHub] URL: {user.get('html_url', 'unknown')}")
except Exception as e:
    print(f"[GitHub] Warning: Could not verify token: {e}")
PYTHON_EOF
fi

# ============================================
# Verify GitLab authentication
# ============================================
if [[ -n "$GITLAB_TOKEN" ]]; then
    echo ""
    echo "[GitLab] Verifying authentication..."
    python3 << PYTHON_EOF
import urllib.request
import json

token = "$GITLAB_TOKEN"
url = "https://gitlab.com/api/v4/user"

req = urllib.request.Request(url)
req.add_header('PRIVATE-TOKEN', token)

try:
    response = urllib.request.urlopen(req)
    user = json.loads(response.read().decode())
    print(f"[GitLab] Authenticated as: {user.get('username', 'unknown')}")
    print(f"[GitLab] URL: {user.get('web_url', 'unknown')}")
except Exception as e:
    print(f"[GitLab] Warning: Could not verify token: {e}")
PYTHON_EOF
fi

# ============================================
# Summary
# ============================================
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Git Identity:"
echo "  Name:  $GIT_NAME"
echo "  Email: $GIT_EMAIL"
echo ""
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "GitHub:"
    echo "  Token stored in: $ENV_FILE"
    [[ -n "$GITHUB_USER" ]] && echo "  User: $GITHUB_USER"
    echo "  CLI:  ~/.local/bin/gh"
    [[ -f "$SSH_KEY_PATH" ]] && echo "  SSH:  $SSH_KEY_PATH"
fi
if [[ -n "$GITLAB_TOKEN" ]]; then
    echo "GitLab:"
    echo "  Token stored in: $ENV_FILE"
    [[ -n "$GITLAB_USER" ]] && echo "  User: $GITLAB_USER"
    echo "  CLI:  ~/.local/bin/glab"
    [[ -f "$SSH_KEY_PATH" ]] && echo "  SSH:  $SSH_KEY_PATH"
fi
echo ""
echo "Next steps:"
echo "  source $ENV_FILE  # Load tokens into environment"
echo "  gh auth status    # Verify GitHub CLI"
echo "  glab auth status  # Verify GitLab CLI"
[[ -f "$SSH_KEY_PATH" ]] && echo "  ssh -T git@github.com  # Test GitHub SSH"
[[ -f "$SSH_KEY_PATH" ]] && echo "  ssh -T git@gitlab.com  # Test GitLab SSH"
