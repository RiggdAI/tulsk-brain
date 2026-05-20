# Agent Git Identity Skill

> 讓 Hermes agent 知道自己的 author 身份，並在 commit 時正確使用

## Purpose

當 agent 需要對 git repo 進行 commit 時，確保：
1. 使用正確的 author 身份
2. Push 後提供驗收資訊給用戶

---

## Triggers

- 任何需要 git commit 的操作
- Push 到 GitHub 後
- 用戶問「你是誰」、「你的 author 是什麼」

---

## Configuration File

位置：`agents.yaml`（在 brain 根目錄或 `~/.hermes/`）

格式：
```yaml
agents:
  {agent-id}:
    name: "Agent Name"
    email: "agent@example.com"
    github_user: "GitHubUsername"
    description: "Agent description"

default: {agent-id}
```

---

## Workflow

### Step 1: 確認自己的 Agent ID

檢查環境變數或 profile 目錄名稱：
```bash
echo $HERMES_PROFILE_NAME
# 或
basename ~/profiles/*
```

### Step 2: 讀取 Author 資訊

從 `agents.yaml` 讀取：
```bash
# 如果有 yq
yq eval ".agents.$AGENT_ID.name" agents.yaml
yq eval ".agents.$AGENT_ID.email" agents.yaml

# 或用 python
python3 -c "import yaml; d=yaml.safe_load(open('agents.yaml')); print(d['agents']['$AGENT_ID']['name'])"
```

### Step 3: 設定 Git Config

```bash
# 設定當前 repo 的 git config
git config user.name "{name}"
git config user.email "{email}"
```

或使用 multi-agent config：
```bash
git config agents.{agent-id}.name "{name}"
git config agents.{agent-id}.email "{email}"

# Commit 時指定 author
git commit --author="{name} <{email}>" -m "message"
```

### Step 4: Push 後提供驗收資訊

**一定要做這件事！**

Push 成功後，取得 commit SHA 和 URL：

```bash
SHA=$(git rev-parse HEAD)
REPO_URL=$(git config --get remote.origin.url | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
echo "Author: {name} <{email}>"
echo "URL: $REPO_URL/commit/$SHA"
```

---

## Verification Format

每次 push 到 GitHub 後，提供以下格式給用戶驗收：

```
## 📋 GitHub Push 驗收資訊

| 項目 | 內容 |
|------|------|
| **Author** | {name} <{email}> |
| **Commit** | {short-sha} |
| **Message** | {commit-message} |
| **URL** | https://github.com/{org}/{repo}/commit/{sha} |
```

---

## Setup Script

在 brain 目錄執行：

```bash
./scripts/setup-agent-git-config.sh --local
```

選項：
- `--local` - 只對當前 repo 有效（預設）
- `--global` - 對所有 repo 有效
- `--show` - 顯示當前設定

---

## Pitfalls

1. **忘記設定 git config**
   - 結果：使用系統預設身份
   - 解法：每次 commit 前檢查 `git config user.name`

2. **Push 後沒有提供驗收資訊**
   - 結果：用戶無法驗證
   - 解法：這是必備步驟，不能省略

3. **使用錯誤的 agent ID**
   - 結果：身份混淆
   - 解法：檢查 `$HERMES_PROFILE_NAME` 或 profile 目錄名稱

---

## Created

2026-05-20
