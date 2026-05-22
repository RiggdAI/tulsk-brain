#!/bin/bash
# Setup Slack gateway for Hermes agent
# Usage: ./setup-slack.sh --bot-token xoxb-xxx --app-token xapp-xxx --allowed-users U01ABC,U02DEF

set -e

# Default profile directory
HERMES_PROFILE_DIR="${HERMES_PROFILE_DIR:-$HOME/.hermes}"
ENV_FILE="$HERMES_PROFILE_DIR/.env"
CONFIG_FILE="$HERMES_PROFILE_DIR/config.yaml"
MANIFEST_FILE="$HERMES_PROFILE_DIR/slack-manifest.json"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --bot-token)
            SLACK_BOT_TOKEN="$2"
            shift 2
            ;;
        --app-token)
            SLACK_APP_TOKEN="$2"
            shift 2
            ;;
        --allowed-users)
            SLACK_ALLOWED_USERS="$2"
            shift 2
            ;;
        --home-channel)
            SLACK_HOME_CHANNEL="$2"
            shift 2
            ;;
        --profile-dir)
            HERMES_PROFILE_DIR="$2"
            ENV_FILE="$HERMES_PROFILE_DIR/.env"
            CONFIG_FILE="$HERMES_PROFILE_DIR/config.yaml"
            MANIFEST_FILE="$HERMES_PROFILE_DIR/slack-manifest.json"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --bot-token TOKEN      Slack bot token (xoxb-...)"
            echo "  --app-token TOKEN      Slack app token (xapp-...)"
            echo "  --allowed-users IDS    Comma-separated user IDs (U01ABC,U02DEF)"
            echo "  --home-channel ID      Default channel ID (optional)"
            echo "  --profile-dir DIR      Hermes profile directory (default: ~/.hermes)"
            echo ""
            echo "Environment variables (alternative to flags):"
            echo "  SLACK_BOT_TOKEN"
            echo "  SLACK_APP_TOKEN"
            echo "  SLACK_ALLOWED_USERS"
            echo "  SLACK_HOME_CHANNEL"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required inputs
if [[ -z "$SLACK_BOT_TOKEN" ]]; then
    echo "Error: SLACK_BOT_TOKEN is required"
    echo "Set via --bot-token or environment variable"
    exit 1
fi

if [[ -z "$SLACK_APP_TOKEN" ]]; then
    echo "Error: SLACK_APP_TOKEN is required"
    echo "Set via --app-token or environment variable"
    exit 1
fi

if [[ -z "$SLACK_ALLOWED_USERS" ]]; then
    echo "Error: SLACK_ALLOWED_USERS is required"
    echo "Set via --allowed-users or environment variable"
    exit 1
fi

# Validate token formats
if [[ ! "$SLACK_BOT_TOKEN" =~ ^xoxb- ]]; then
    echo "Error: Bot token should start with 'xoxb-'"
    exit 1
fi

if [[ ! "$SLACK_APP_TOKEN" =~ ^xapp- ]]; then
    echo "Error: App token should start with 'xapp-'"
    exit 1
fi

# Check hermes is installed
if ! command -v hermes &> /dev/null; then
    echo "Error: hermes command not found"
    echo "Install with: uv tool install hermes-agent --python 3.11"
    exit 1
fi

# Create profile directory if needed
mkdir -p "$HERMES_PROFILE_DIR"

# Generate slack-manifest.json
echo "Generating slack-manifest.json..."
cat > "$MANIFEST_FILE" << 'EOF'
{
  "display_information": {
    "name": "Hermes Agent",
    "description": "AI Assistant powered by Hermes",
    "background_color": "#2c3e50"
  },
  "features": {
    "app_home": {
      "home_tab_enabled": false,
      "messages_tab_enabled": true,
      "messages_tab_read_only": false
    },
    "bot_user": {
      "display_name": "Hermes Agent",
      "always_online": true
    },
    "slash_commands": [
      { "command": "/btw", "description": "Continue conversation", "should_escape": false },
      { "command": "/stop", "description": "Cancel current task", "should_escape": false },
      { "command": "/new", "description": "Start fresh session", "should_escape": false },
      { "command": "/model", "description": "Switch model", "should_escape": false },
      { "command": "/help", "description": "Show commands", "should_escape": false }
    ]
  },
  "oauth_config": {
    "scopes": {
      "bot": [
        "chat:write",
        "app_mentions:read",
        "channels:history",
        "groups:history",
        "im:history",
        "im:read",
        "files:read",
        "files:write"
      ]
    }
  },
  "settings": {
    "event_subscriptions": {
      "request_url": "",
      "bot_events": [
        "message.im",
        "message.channels",
        "message.groups",
        "app_mention"
      ]
    },
    "org_deploy_enabled": false,
    "socket_mode_enabled": true,
    "token_rotation_enabled": false
  }
}
EOF
echo "  Created: $MANIFEST_FILE"

# Update .env file
echo "Updating .env file..."
if [[ -f "$ENV_FILE" ]]; then
    # Remove existing Slack vars
    sed -i '/^SLACK_/d' "$ENV_FILE"
fi

{
    echo ""
    echo "# Slack Gateway Configuration"
    echo "SLACK_BOT_TOKEN=$SLACK_BOT_TOKEN"
    echo "SLACK_APP_TOKEN=$SLACK_APP_TOKEN"
    echo "SLACK_ALLOWED_USERS=$SLACK_ALLOWED_USERS"
    if [[ -n "$SLACK_HOME_CHANNEL" ]]; then
        echo "SLACK_HOME_CHANNEL=$SLACK_HOME_CHANNEL"
    fi
} >> "$ENV_FILE"
echo "  Updated: $ENV_FILE"

# Ensure config.yaml has slack section (minimal, just enough to work)
echo "Checking config.yaml..."
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "slack: {}" > "$CONFIG_FILE"
    echo "  Created: $CONFIG_FILE"
fi

echo ""
echo "✓ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Go to https://api.slack.com/apps"
echo "2. Create New App → From an app manifest"
echo "3. Paste the contents of: $MANIFEST_FILE"
echo "4. Go to 'Install App' and install to workspace"
echo "5. Run: hermes gateway"
echo ""
echo "To find user IDs: Click user's name → View full profile → More → Copy member ID"
