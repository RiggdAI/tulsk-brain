# Slack Gateway Setup Workflow

## Step-by-Step Process

### 1. Install Hermes CLI

```bash
# Using uv (recommended)
uv tool install hermes-agent --python 3.11

# Verify installation
hermes --version
```

### 2. Generate Slack Manifest

```bash
hermes slack manifest --write
```

Output location: `/opt/data/profiles/{profile}/slack-manifest.json`

### 3. Create Slack App

1. Go to https://api.slack.com/apps
2. **Create New App** → **From an app manifest**
3. Select workspace
4. **Paste** the generated JSON
5. **Review** → **Create**

### 4. Generate App-Level Token

1. Settings → Basic Information → App-Level Tokens
2. Generate with `connections:write` scope
3. Copy `xapp-...` token

### 5. Install to Workspace

1. Settings → Install App
2. Authorize permissions
3. Copy `xoxb-...` Bot Token

### 6. Configure Hermes

```bash
# Using hermes config set
hermes config set SLACK_BOT_TOKEN "xoxb-xxx"
hermes config set SLACK_APP_TOKEN "xapp-xxx"
hermes config set SLACK_ALLOWED_USERS "U01ABC2DEF3"

# Or manually in .env
# /opt/data/profiles/{profile}/.env
```

### 7. Start Gateway

```bash
# Foreground
hermes gateway

# Background
hermes gateway &
```

### 8. Verify Connection

Check the gateway log:

```bash
cat /opt/data/profiles/{profile}/logs/gateway.log
```

Expected output:
```
[Slack] Authenticated as @hermes in workspace {workspace} (team: T...)
[Slack] Socket Mode connected (1 workspace(s))
✓ slack connected
Gateway running with 1 platform(s)
```

### 9. Test

- **DM**: Direct message @Hermes in Slack
- **Channel**: `/invite @Hermes` then `@Hermes hello`
- **Slash commands**: `/help`, `/new`, `/model`

---

## Token Locations

| Token | Prefix | Config Location |
|-------|--------|-----------------|
| Bot Token | `xoxb-` | `.env` or `hermes config set` |
| App Token | `xapp-` | `.env` or `hermes config set` |
| Allowed Users | `U...` | `config.yaml` (not .env) |

---

## Common Issues

### Gateway won't start

```bash
# Check if tokens are set
cat /opt/data/profiles/{profile}/.env | grep SLACK

# Check config.yaml
cat /opt/data/profiles/{profile}/config.yaml | grep SLACK
```

### Bot not responding in channels

1. Check `message.channels` event is subscribed
2. Check `channels:history` scope is added
3. Bot must be invited: `/invite @Hermes`
4. User must be in `SLACK_ALLOWED_USERS`

### Log shows errors

```bash
# Check error log
tail -50 /opt/data/profiles/{profile}/logs/errors.log

# Check agent log
tail -50 /opt/data/profiles/{profile}/logs/agent.log
```

---

## Don't Do This

- ❌ Writing custom slack-bolt bot code
- ❌ Creating a separate bot repo
- ❌ Using RTM API (deprecated)
- ❌ Putting `SLACK_ALLOWED_USERS` in `.env` (belongs in `config.yaml`)

Hermes has built-in gateway support with 49 slash commands, thread awareness, and multi-workspace support.
