# Brain Maintenance Skill

> 定期維護 Tulsk Brain，確保知識庫健康

## Purpose

定期檢查 brain 的健康狀態，發現並修正問題。

---

## Triggers

- 每週維護
- 用戶要求「lint brain」、「check brain health」
- 發現資料不一致時

---

## Weekly Lint Checklist

### 1. Deduplication

檢查是否有重複的 pages：

```bash
# Find potential duplicate person pages
find ~/brain/people -name "*.md" -exec basename {} \; | sort | uniq -d

# Find potential duplicate company pages
find ~/brain/companies -name "*.md" -exec basename {} \; | sort | uniq -d
```

**處理方式：**
- 合併重複頁面
- 將舊頁面移到 `archive/`
- 更新所有 cross-references

---

### 2. Contradictions

檢查是否有衝突的資訊：

```bash
# Check for conflicting status
grep -r "Status:" ~/brain --include="*.md" | grep -v "archive"
```

**常見衝突：**
- 人物的 Role/Company 不一致
- 專案的 Status 不一致
- 會議的 attendees 與 people pages 不匹配

---

### 3. Staleness

檢查過期的內容：

```bash
# Find pages not updated in 90+ days
find ~/brain -name "*.md" -mtime +90 -not -path "*/archive/*"
```

**處理方式：**
- 確認是否仍相關
- 更新 State 區塊
- 移到 archive 如果不再相關

---

### 4. Orphans

檢查沒有被引用的 pages：

```bash
# Find pages with no inbound links
for page in $(find ~/brain -name "*.md" -not -path "*/.raw/*" -not -path "*/templates/*"); do
  slug=$(basename "$page" .md)
  count=$(grep -r "\[\[.*$slug.*\]\]" ~/brain --include="*.md" | wc -l)
  if [ $count -eq 0 ]; then
    echo "Orphan: $page"
  fi
done
```

**處理方式：**
- 檢查是否應該連結到其他 pages
- 如果是孤立且不重要，移到 archive

---

### 5. Open Threads

檢查未解決的 Open Threads：

```bash
# Find pages with open threads
grep -r "Open Threads" ~/brain --include="*.md" -A 5 | grep -v "archive"
```

**處理方式：**
- 追蹤每個 open thread
- 如果已解決，移到 Timeline

---

### 6. Missing Cross-References

檢查提到但未連結的 entities：

```bash
# Find mentions without wikilinks
grep -r "met with\|spoke to\|from\|at " ~/brain --include="*.md" | grep -v "\[\["
```

**處理方式：**
- 將名稱轉為 wikilinks
- 例如：`met with John` → `met with [[people/john-doe]]`

---

## Maintenance Report Template

每次維護後產生報告：

```markdown
# Brain Maintenance Report - YYYY-MM-DD

## Summary
- Pages checked: X
- Issues found: Y
- Issues fixed: Z

## Duplicates Found
- [List]

## Contradictions Found
- [List]

## Stale Pages
- [List]

## Orphans
- [List]

## Open Threads
- [List]

## Actions Taken
- [List of fixes]
```

---

## Pitfalls

1. **不要批量刪除** - 先確認每個 orphan 是否真的不需要
2. **不要忽略 Timeline** - 永遠保留歷史紀錄
3. **不要忘記 commit** - 每個修正都要 commit

---

## Created

2026-05-20
