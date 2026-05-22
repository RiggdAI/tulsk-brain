---
name: messaging-platforms
description: Configure Hermes messaging gateway for Slack, Telegram, Discord, WhatsApp, Signal, Email, SMS
triggers:
  - setup slack
  - configure telegram
  - connect discord
  - hermes gateway
---

# Hermes Messaging Platforms

Configure Hermes as a bot on various messaging platforms using the built-in gateway. No custom bot code needed.

## Overview

Hermes has native support for multiple messaging platforms via `hermes gateway`:

| Platform | Mode | Auth Required |
|----------|------|---------------|
| Slack | Socket Mode | Bot Token + App Token |
| Telegram | Long Polling | Bot Token |
| Discord | Gateway | Bot Token |
| WhatsApp | Webhook | Token + Phone ID |
| Signal | signald | Phone Number |
| Email | IMAP/SMTP | Credentials |
| SMS (Twilio) | Webhook | Account SID + Token |

## Quick Start

```bash
# Install Hermes (if not already installed)
uv tool install hermes-agent --python 3.11

# Interactive setup (select platform when prompted)
hermes gateway setup

# Start gateway (foreground)
hermes gateway

# Check all profiles' gateway status
hermes gateway list

# Run gateway for specific profile
HERMES_PROFILE=profilename hermes gateway run --replace

# Install as user service
hermes gateway install
```

**Key insight**: Gateway is per-profile. Multiple profiles can run gateways simultaneously, each with different bot identities.

---

## Slack Setup

### Option A: From Manifest (Recommended)

```bash
hermes slack manifest --write
```

This generates `slack-manifest.json` in the current profile directory (e.g., `~/.hermes/` or `/opt/data/profiles/{profile}/`) with all scopes, events, and slash commands pre-configured.

1. Go to https://api.slack.com/apps
2. Create New App → From an app manifest
3. Paste the generated JSON
4. Skip to "Install App to Workspace"

### Option B: Manual Setup

**Required Scopes:**
- `chat:write` - Send messages
- `app_mentions:read` - Detect @mentions
- `channels:history` - Read public channel messages
- `groups:history` - Read private channel messages
- `im:history` - Read DMs
- `im:read` - View DM info
- `files:read` - Read attachments (images, voice)
- `files:write` - Upload files

**Required Events:**
- `message.im` - Receive DMs
- `message.channels` - Receive public channel messages
- `message.groups` - Receive private channel messages
- `app_mention` - Handle @mentions

**Socket Mode:**
- Enable in Settings → Socket Mode
- Generate App Token with `connections:write` scope

**Messages Tab:**
- Enable in Features → App Home → Show Tabs
- Check "Allow users to send Slash commands and messages"

### Environment Variables

```bash
# ~/.hermes/.env
SLACK_BOT_TOKEN=xoxb-xxx
SLACK_APP_TOKEN=xapp-xxx
SLACK_ALLOWED_USERS=U01ABC2DEF3,U02XYZ4GHI5
SLACK_HOME_CHANNEL=C01234567890
```

### Find User IDs

1. Click user's name in Slack
2. View full profile
3. Click more menu → Copy member ID

### Invite Bot to Channels

```
/invite @HermesAgent
```

---

## Telegram Setup

```bash
# Get token from @BotFather
# ~/.hermes/.env
TELEGRAM_BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
TELEGRAM_ALLOWED_USERS=123456789
```

---

## Discord Setup

```bash
# Create bot at discord.com/developers/applications
# ~/.hermes/.env
DISCORD_BOT_TOKEN=xxx
DISCORD_ALLOWED_USERS=123456789012345678
DISCORD_ALLOWED_GUILDS=123456789012345678
```

---

## Platform-Specific Prompts

Per-channel system prompts for different contexts:

```yaml
# ~/.hermes/config.yaml
slack:
  channel_prompts:
    "C01RESEARCH": |
      You are a research assistant. Focus on academic sources and citations.
    "C02ENGINEERING": |
      Code review mode. Be precise about edge cases.
```

---

## Channel Skill Bindings

Auto-load skills for specific channels:

```yaml
slack:
  channel_skill_bindings:
    - id: "C01RESEARCH"
      skills:
        - arxiv
        - writing
    - id: "D0ATH9TQ0G6"  # DM
      skills:
        - flashcards
```

---

## Slash Commands

Hermes registers all commands as native Slack slash commands:

| Command | Purpose |
|---------|---------|
| `/btw` | Continue conversation |
| `/stop` | Cancel current task |
| `/new` | Start fresh session |
| `/model` | Switch model |
| `/help` | Show commands |

**In threads:** Use `!` prefix since Slack blocks `/` commands in threads:
- `!queue` instead of `/queue`
- `!model gpt-4o` instead of `/model gpt-4o`

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Bot works in DMs but not channels | Add `message.channels` event + `channels:history` scope, reinstall app |
| Bot doesn't see attachments | Add `files:read` scope, reinstall |
| "Sending messages turned off" in DMs | Enable Messages Tab in App Home |
| Commands not working in threads | Use `!` prefix instead of `/` |

---

## Multi-Workspace

```bash
# Comma-separated tokens for multiple workspaces
SLACK_BOT_TOKEN=xoxb-token1,xoxb-token2
```

---

## Pitfalls

1. **Writing custom bot code** - Hermes has built-in gateway support. Don't write custom slack-bolt code unless you have a specific need not covered by the native gateway.
2. **Forgot to reinstall after scope change** - Slack caches the old config until reinstall
3. **Missing `files:read` scope** - Bot can chat but can't see images/voice
4. **Not inviting bot to channel** - Bot won't receive any channel messages
5. **Messages Tab disabled** - DMs completely blocked, even with correct scopes
6. **Old tokens in profile** - When creating a new Slack App for a profile, clear old tokens from `.env` and `config.yaml` first. Old tokens can cause conflicts or "account_inactive" errors.

---

## Related Skills

- `onboard` - Sync profiles from gbrain-data
- `agent-git-identity` - Git commit identity

## References

- [slack-manifest-reference.md](references/slack-manifest-reference.md) - Full manifest structure, token locations, deprecated hermes-slack-bot repo note
- [slack-token-rotation.md](references/slack-token-rotation.md) - Clear old tokens when creating new Slack app
