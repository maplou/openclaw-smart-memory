# 快速开始指南

## 5 分钟上手 Memory Index

### 第 1 步：安装（1 分钟）

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/memory-index.git
cd memory-index

# 运行安装脚本
./install.sh
```

### 第 2 步：开始记录（1 分钟）

创建你的第一个记忆文件：

```bash
# 创建今天的记忆文件
vim memory/$(date +%Y-%m-%d).md
```

内容示例：

```markdown
# 2026-03-04 - 开始使用 Memory Index

[tags: first, memory-index]

## 今天学会了
- 安装了 Memory Index 工具
- 创建了第一个记忆文件
- 设置了自动索引生成

## 感受
- 检索速度确实很快
- 标签系统很实用
```

### 第 3 步：生成索引（1 分钟）

```bash
# 手动生成一次索引
python3 scripts/generate-memory-index.py

# 查看生成的索引
cat memory/INDEX.md
```

### 第 4 步：设置自动更新（1 分钟）

```bash
# 编辑 crontab
crontab -e

# 添加每天凌晨 2 点运行
0 2 * * * python3 /path/to/scripts/generate-memory-index.py
```

### 第 5 步：日常使用（1 分钟）

**每天：**
1. 在 `memory/YYYY-MM-DD.md` 记录当天事件
2. 添加标签 `[tags: your, tags]`
3. 索引会自动在凌晨 2 点更新

**需要查找时：**
```bash
# 方式 1: 查看索引
cat memory/INDEX.md

# 方式 2: 搜索标签
grep "#lesson" memory/INDEX.md

# 方式 3: 语义搜索（如果有 memory_search 工具）
```

---

## 🎯 最佳实践

### ✅ 推荐做法

1. **每天记录** - 即使只有一件事
2. **使用标签** - 2-5 个标签最合适
3. **保持简洁** - 索引文件应<10KB
4. **定期回顾** - 每周花 5 分钟回顾

### ❌ 避免做法

1. **不要** 把所有内容写在一个文件里
2. **不要** 使用太多标签（>10 个）
3. **不要** 忘记添加日期到文件名
4. **不要** 忽略索引文件的大小

---

## 📊 预期效果

### 使用前
```
查找"小红书封号教训"
→ 打开所有记忆文件
→ 逐个搜索关键词
→ 耗时：5-10 分钟
```

### 使用后
```
查找"小红书封号教训"
→ grep "#xhs" memory/INDEX.md
→ 直接定位到文件
→ 耗时：<10 秒
```

---

## 🆘 常见问题

### Q: 索引文件太大怎么办？
A: 归档 3 个月前的记忆到 `archive/` 目录

### Q: 标签没被识别？
A: 检查格式，确保是 `[tags: tag1, tag2]` 或 `#tag1 #tag2`

### Q: Cron 任务不运行？
A: 检查 cron 服务状态：`systemctl status cron`

---

## 📖 下一步

- 查看 [README.md](../README.md) 了解完整功能
- 查看 [examples/](../examples/) 查看更多示例
- 在 GitHub 上给个 ⭐️ Star 支持一下！

---

*5 分钟完成设置，享受高效的记忆检索！*
