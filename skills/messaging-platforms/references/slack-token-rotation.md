# Slack Token Rotation

When creating a new Slack app or rotating credentials, clear old tokens before configuring new ones.

## Files to Clear

### 1. Environment Variables (.env)

```bash
# Profile .env file
sed -i '/SLACK_/d' /opt/data/profiles/{profile}/.env
```

Or manually remove these lines:
- `SLACK_BOT_TOKEN=...`
- `SLACK_APP_TOKEN=...`

### 2. Config.yaml

Remove from config:
- `SLACK_ALLOWED_USERS: ...` (top-level key)
- `slack:` section (if present)

```bash
# Check for remaining Slack config
grep -i slack /opt/data/profiles/{profile}/config.yaml
```

### 3. Manifest File

```bash
rm -f /opt/data/profiles/{profile}/slack-manifest.json
```

### 4. Stop Running Gateway

```bash
# Find and kill gateway process
pkill -f "hermes gateway"
# Or use process management
```

## Verify Clean State

```bash
# No Slack tokens in .env
grep -i slack /opt/data/profiles/{profile}/.env || echo "✓ Clean"

# No Slack config in yaml
grep -i slack /opt/data/profiles/{profile}/config.yaml || echo "✓ Clean"
```

## Set New Tokens

```bash
hermes config set SLACK_BOT_TOKEN "xoxb-xxx"
hermes config set SLACK_APP_TOKEN "xapp-xxx"
hermes config set SLACK_ALLOWED_USERS "U01ABC2DEF3"
```

## Common Errors After Token Rotation

### `account_inactive` Error

```
WARNING gateway.channel_directory: failed to list Slack channels
The server responded with: {'ok': False, 'error': 'account_inactive'}
```

**Cause**: Old tokens are still cached in memory or the previous gateway process is using stale credentials.

**Fix**: 
1. Ensure gateway is stopped: `pkill -f "hermes gateway"`
2. Verify tokens are cleared: `grep -i slack {profile}/.env`
3. Add new tokens and restart gateway

### Bot Still Shows Old Name

After reinstalling app with new manifest, the bot display name may still show the old name in some contexts.

**Fix**: 
1. Update `display_information.name` in manifest
2. Reinstall app
3. Clear Slack cache (refresh browser, restart desktop app)
4. Wait a few minutes for propagation
