#!/bin/bash
# Memory Index 安装脚本

set -e

echo "🚀 安装 Memory Index..."
echo ""

# 获取脚本目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE="${MEMORY_INDEX_WORKSPACE:-/home/admin/openclaw/workspace}"

echo "📁 工作目录：$WORKSPACE"
echo ""

# 创建目录
echo "📁 创建目录结构..."
mkdir -p "$WORKSPACE/scripts"
mkdir -p "$WORKSPACE/memory"

# 复制脚本
echo "📝 复制脚本..."
cp "$SCRIPT_DIR/scripts/generate-memory-index.py" "$WORKSPACE/scripts/"
chmod +x "$WORKSPACE/scripts/generate-memory-index.py"

# 创建示例索引文件
echo "📄 创建示例索引..."
cat > "$WORKSPACE/memory/INDEX.md" << 'EOF'
# 记忆索引 INDEX.md

> 自动生成 | 最后更新：刚刚
> 用于快速检索记忆，避免加载全部文件

---

## 📌 核心记忆（永久保留）

| ID | 主题 | 标签 | 路径 | 重要性 |
|----|------|------|------|--------|
| M001 | 核心记忆示例 | #example | MEMORY.md | ⭐⭐⭐⭐⭐ |

---

## 📅 最近记忆（30 天内）

*暂无最近记忆，开始记录吧！*

---

## 🏷️ 按标签快速检索

*暂无标签*

---

## 📊 统计信息

- **核心记忆**: 0 条
- **最近记忆**: 0 条
- **总标签数**: 0 个

---

*自动生成脚本：scripts/generate-memory-index.py*
EOF

# 复制 README
echo "📖 复制使用说明..."
cp "$SCRIPT_DIR/README.md" "$WORKSPACE/memory/README.md"

# 运行一次生成索引
echo "📊 生成初始索引..."
python3 "$WORKSPACE/scripts/generate-memory-index.py"

# 添加 Cron 任务
echo ""
echo "⏰ 添加定时任务（每天凌晨 2 点）..."
CRON_JOB="0 2 * * * python3 $WORKSPACE/scripts/generate-memory-index.py"

# 检查是否已存在
if crontab -l 2>/dev/null | grep -q "$CRON_JOB"; then
    echo "✅ Cron 任务已存在"
else
    (crontab -l 2>/dev/null | grep -v "$CRON_JOB"; echo "$CRON_JOB") | crontab -
    echo "✅ Cron 任务已添加"
fi

echo ""
echo "=========================================="
echo "✅ 安装完成！"
echo "=========================================="
echo ""
echo "📁 文件位置:"
echo "   - 脚本：$WORKSPACE/scripts/generate-memory-index.py"
echo "   - 索引：$WORKSPACE/memory/INDEX.md"
echo "   - 说明：$WORKSPACE/memory/README.md"
echo ""
echo "🎯 下一步:"
echo "   1. 在 memory/YYYY-MM-DD.md 开始记录今天的事件"
echo "   2. 添加标签：[tags: your, tags, here]"
echo "   3. 查看索引：cat $WORKSPACE/memory/INDEX.md"
echo ""
echo "📖 更多信息：查看 README.md"
echo ""
