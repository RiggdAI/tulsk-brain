#!/bin/bash
# =============================================================================
# Setup Multi-Agent Git Configuration
# =============================================================================
# This script reads agents.yaml and sets up git config for multi-agent commits.
#
# Usage:
#   ./setup-agent-git-config.sh [options]
#
# Options:
#   --global    Set git config globally (affects all repos)
#   --local     Set git config for current repo only (default)
#   --show      Show current agent config without making changes
#   --help      Show this help message
#
# For verification after pushing to GitHub:
#   Author: {name} <{email}>
#   URL: https://github.com/{org}/{repo}/commit/{sha}
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_YAML="${SCRIPT_DIR}/../agents.yaml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse arguments
SCOPE="--local"
ACTION="setup"

while [[ $# -gt 0 ]]; do
    case $1 in
        --global) SCOPE="--global"; shift ;;
        --local) SCOPE="--local"; shift ;;
        --show) ACTION="show"; shift ;;
        --help|-h) head -30 "$0" | tail -25; exit 0 ;;
        *) echo -e "${RED}Unknown option: $1${NC}"; exit 1 ;;
    esac
done

# Check if agents.yaml exists
if [[ ! -f "$AGENTS_YAML" ]]; then
    echo -e "${RED}Error: agents.yaml not found at $AGENTS_YAML${NC}"
    echo "Please create agents.yaml with your agent configuration."
    exit 1
fi

# Show current config
if [[ "$ACTION" == "show" ]]; then
    echo -e "${YELLOW}Current agent git config:${NC}"
    git config $SCOPE --list 2>/dev/null | grep "^agents\." || echo "No agent config found"
    exit 0
fi

# Parse YAML and set git config (simple grep-based parser)
echo -e "${GREEN}Setting up multi-agent git config...${NC}"
echo ""

current_agent=""
while IFS= read -r line; do
    # Match agent ID (e.g., "  ai-gary-tan:")
    if [[ "$line" =~ ^[[:space:]]+([a-z0-9-]+):[[:space:]]*$ ]]; then
        current_agent="${BASH_REMATCH[1]}"
    fi
    
    # Match name
    if [[ -n "$current_agent" && "$line" =~ ^[[:space:]]+name:[[:space:]]+\"?(.+)\"?[[:space:]]*$ ]]; then
        name="${BASH_REMATCH[1]}"
        name="${name%\"}"
        name="${name#\"}"
        git config $SCOPE "agents.$current_agent.name" "$name"
        echo -e "  ${GREEN}✓${NC} $current_agent.name = $name"
    fi
    
    # Match email
    if [[ -n "$current_agent" && "$line" =~ ^[[:space:]]+email:[[:space:]]+\"?(.+)\"?[[:space:]]*$ ]]; then
        email="${BASH_REMATCH[1]}"
        email="${email%\"}"
        email="${email#\"}"
        git config $SCOPE "agents.$current_agent.email" "$email"
        echo -e "  ${GREEN}✓${NC} $current_agent.email = $email"
    fi
done < "$AGENTS_YAML"

echo ""
echo -e "${GREEN}✅ Multi-agent git config set up!${NC}"
echo ""
echo "Usage:"
echo "  git config user.name \"Agent Name\""
echo "  git config user.email \"agent@example.com\""
echo ""
echo "For GitHub verification after push:"
echo "  Author: {name} <{email}>"
echo "  URL: https://github.com/{org}/{repo}/commit/{sha}"
