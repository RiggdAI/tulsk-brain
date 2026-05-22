# Slack Troubleshooting Guide

Detailed error codes and fixes for Hermes Slack gateway.

## Common Errors

### "not_authed" or "invalid_auth"

**Cause:** Token is invalid or expired.

**Fix:**
1. Go to https://api.slack.com/apps
2. Navigate to your app → OAuth & Permissions
3. Regenerate Bot Token
4. Update `~/.hermes/.env` with new token
5. Restart gateway

---

### "missing_scope"

**Cause:** Bot tries to perform an action it doesn't have permission for.

**Fix:**
1. Add the required scope in OAuth & Permissions
2. **Reinstall the app** (critical - changes don't take effect until reinstall)
3. Restart gateway

| Action | Required Scope |
|--------|----------------|
| Send messages | `chat:write` |
| Read channel messages | `channels:history` |
| Read private channel messages | `groups:history` |
| Read DMs | `im:history` |
| Read attachments | `files:read` |
| Upload files | `files:write` |

---

### "Sending messages to this app has been turned off"

**Cause:** Messages Tab not enabled in App Home.

**Fix:**
1. Go to Features → App Home
2. Scroll to Show Tabs
3. Toggle Messages Tab to ON
4. Check "Allow users to send Slash commands and messages from the messages tab"

---

### Bot works in DMs but not in channels

**Cause:** Missing event subscriptions or scopes for channels.

**Fix:**
1. Add `message.channels` to event subscriptions (for public channels)
2. Add `message.groups` to event subscriptions (for private channels)
3. Add `channels:history` scope (public)
4. Add `groups:history` scope (private)
5. Reinstall the app
6. Invite bot to channel: `/invite @HermesAgent`

---

### Bot doesn't respond to @mentions

**Checklist:**
- [ ] `app_mention` event subscribed
- [ ] Bot invited to channel
- [ ] `channels:history` scope added
- [ ] App reinstalled after changes

---

### Slash commands show "not supported in threads"

**Cause:** Slack platform limitation - native slash commands don't work in thread replies.

**Workaround:** Use `!` prefix instead:
```
!queue          # Instead of /queue
!model gpt-4o   # Instead of /model gpt-4o
```

---

### Socket disconnects frequently

**Causes:**
- Network instability
- Firewall blocking WebSocket connections
- Slack API rate limits

**Fix:**
- Check network connectivity
- Verify firewall allows outbound WebSocket connections
- Bolt SDK auto-reconnects; monitor logs for patterns

---

## Quick Diagnostic Commands

```bash
# Test Slack API connection
curl -H "Authorization: Bearer $SLACK_BOT_TOKEN" https://slack.com/api/auth.test

# List channels bot is in
curl -H "Authorization: Bearer $SLACK_BOT_TOKEN" https://slack.com/api/conversations.list

# Get bot info
curl -H "Authorization: Bearer $SLACK_BOT_TOKEN" https://slack.com/api/bots.info
```

---

## Reinstall Checklist

After ANY change to scopes or events:

1. [ ] Go to OAuth & Permissions
2. [ ] Click "Install App" or "Reinstall App"
3. [ ] Review permissions
4. [ ] Click Allow
5. [ ] Verify new token in `.env`
6. [ ] Restart gateway

---

## Finding IDs

### User Member ID
1. Click user's name/avatar
2. View full profile
3. Click ⋮ (more)
4. Copy member ID
5. Format: `U01ABC2DEF3`

### Channel ID
1. Right-click channel name
2. View channel details
3. Scroll to bottom
4. Format: `C0123456789` (public), `G0123456789` (private), `D0123456789` (DM)

---

## Hermes-Specific Issues

### "Unauthorized user" when DMing bot

**Cause:** User ID not in `SLACK_ALLOWED_USERS`.

**Fix:**
```bash
# Add your Member ID
SLACK_ALLOWED_USERS=U01ABC2DEF3
```

### Bot responds but won't read my uploaded image

**Cause:** Missing `files:read` scope.

**Fix:**
1. Add `files:read` scope
2. Reinstall app
3. Restart gateway

### Cron/scheduled messages not delivering

**Cause:** `SLACK_HOME_CHANNEL` not set or bot not invited.

**Fix:**
```bash
SLACK_HOME_CHANNEL=C01234567890
```
Then invite bot to that channel.
