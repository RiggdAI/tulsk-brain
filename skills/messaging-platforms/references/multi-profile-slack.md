# Multi-Profile Slack Gateway Setup

Each Hermes profile can have its own Slack bot with unique identity and tokens.

## ⚠️ CRITICAL: One Slack App Token Per Profile

**Each profile MUST use a different Slack App with unique tokens.** Sharing tokens causes fatal conflicts.

### What Happens If You Share Tokens

```
Profile A starts gateway with xapp-1-ABC...  → ✅ Works
Profile B starts gateway with xapp-1-ABC...  → ❌ Fails

Error: "Slack app token already in use (PID XXXX)"
```

Slack's Socket Mode only allows **one active connection per app-level token**. When a second profile tries to connect with the same token:
1. Slack rejects the connection
2. Both gateways may fail or become unstable
3. The error persists even after killing processes

### The Fix

Create one Slack App per profile at https://api.slack.com/apps:

| Profile | Slack App Name | Bot Username | Tokens |
|---------|----------------|--------------|--------|
| ai-gary-tan | "AI Gary Tan" | @gary_bot | xapp-1-ABC... |
| chief-technology-officer-2 | "CTO Agent" | @cto_bot | xapp-1-XYZ... |
| instagram-agent | "Instagram Agent" | @instagram_bot | xapp-1-123... |

Each app generates its own `xapp-` (app token) and `xoxb-` (bot token).

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Slack Workspace                           │
│                                                              │
│  @gary_bot        @cto_bot        @instagram_bot            │
│      │                │                 │                   │
└──────┼────────────────┼─────────────────┼───────────────────┘
       │                │                 │
       ▼                ▼                 ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ ai-gary-tan  │ │ chief-tech-  │ │ instagram-   │
│   profile    │ │ officer-2    │ │   agent      │
│              │ │              │ │              │
│ .env:        │ │ .env:        │ │ .env:        │
│  xapp-xxx    │ │  xapp-xxx    │ │  xapp-xxx    │
│  xoxb-xxx    │ │  xoxb-xxx    │ │  xoxb-xxx    │
│              │ │              │ │              │
│ gateway PID  │ │ gateway PID  │ │ gateway PID  │
│   12345      │ │   12346      │ │   12347      │
└──────────────┘ └──────────────┘ └──────────────┘
```

## Setup Process

### 1. Create Slack App per Profile

Each profile needs its own Slack App at https://api.slack.com/apps:

| Profile | App Name | Bot Display Name |
|---------|----------|------------------|
| ai-gary-tan | "AI Gary Tan" | @gary_bot |
| chief-technology-officer-2 | "CTO Agent" | @cto_bot |
| instagram-agent | "Instagram Agent" | @instagram_bot |

### 2. Generate Manifest per Profile

```bash
# For each profile
cd /opt/data/profiles/{profile-name}
hermes slack manifest --write
```

The manifest is generated in the profile directory.

### 3. Configure Tokens per Profile

Each profile's `.env`:

```bash
# /opt/data/profiles/ai-gary-tan/.env
SLACK_APP_TOKEN=xapp-1-...
SLACK_BOT_TOKEN=xoxb-...

# /opt/data/profiles/chief-technology-officer-2/.env
SLACK_APP_TOKEN=xapp-1-...  # Different from above
SLACK_BOT_TOKEN=xoxb-...    # Different from above

# /opt/data/profiles/instagram-agent/.env
SLACK_APP_TOKEN=xapp-1-...  # Different from above
SLACK_BOT_TOKEN=xoxb-...    # Different from above
```

### 4. Start Gateway per Profile

```bash
# Terminal 1 - AI Gary Tan
cd /opt/data/profiles/ai-gary-tan
hermes gateway

# Terminal 2 - CTO Agent
cd /opt/data/profiles/chief-technology-officer-2
hermes gateway

# Terminal 3 - Instagram Agent
cd /opt/data/profiles/instagram-agent
hermes gateway
```

Or use background processes:

```bash
cd /opt/data/profiles/ai-gary-tan && hermes gateway &
cd /opt/data/profiles/chief-technology-officer-2 && hermes gateway &
cd /opt/data/profiles/instagram-agent && hermes gateway &
```

## Verification

Check each gateway log:

```bash
# AI Gary Tan
tail -20 /opt/data/profiles/ai-gary-tan/logs/gateway.log

# CTO Agent
tail -20 /opt/data/profiles/chief-technology-officer-2/logs/gateway.log

# Instagram Agent
tail -20 /opt/data/profiles/instagram-agent/logs/gateway.log
```

Each should show:

```
[Slack] Authenticated as @{bot-name} in workspace {workspace}
✓ slack connected
```

## Process Management

### List All Gateway Status

```bash
hermes gateway list
```

Output shows all profiles and their gateway status:

```
Gateways:
  ✗ default                  — not running
  ✗ ai-gary-tan              — not running
  ✓ chief-technology-officer-2 (current) — PID 14275
  ✗ competitive-intel-agent  — not running
  ✓ instagram-agent          — PID 14232
  ✗ research-agent           — not running
```

### Run Gateway for Specific Profile

```bash
# Method 1: Using HERMES_PROFILE environment variable
HERMES_PROFILE=instagram-agent hermes gateway run --replace

# Method 2: Change to profile directory
cd /opt/data/profiles/instagram-agent
hermes gateway
```

### Kill Specific Gateway

```bash
kill {PID}

# Or stop all gateways
hermes gateway stop
```

## Common Issues

### Gateway uses wrong profile tokens

**Cause**: Gateway reads from current directory's profile.

**Fix**: Always `cd` to profile directory before starting gateway.

### Bot name shows wrong identity

**Cause**: Manifest `display_information.name` doesn't match intended identity.

**Fix**: 
1. Update manifest before creating app
2. Or update in Slack App settings after creation

### Only one gateway works

**Cause**: All profiles using same tokens.

**Fix**: Each profile needs unique Slack App with unique tokens.

### Old tokens still active after creating new app

**Cause**: Previous Slack App tokens still in profile's `.env` and `config.yaml`.

**Fix**: Clear old tokens before adding new ones:

```bash
# Remove old Slack tokens from .env
sed -i '/SLACK_/d' /opt/data/profiles/{profile}/.env

# Remove SLACK_ALLOWED_USERS from config.yaml
# (manually edit or use patch tool)

# Remove old manifest
rm /opt/data/profiles/{profile}/slack-manifest.json
```

Then add the new tokens and regenerate manifest.
