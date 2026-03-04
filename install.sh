#!/bin/bash
# Memory Index 安装脚本

set -e

echo "🚀 安装 Memory Index - 三层记忆架构系统..."
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
mkdir -p "$WORKSPACE/outputs"
mkdir -p "$WORKSPACE/data"

# 复制脚本
echo "📝 复制脚本..."
cp "$SCRIPT_DIR/scripts/generate-memory-index.py" "$WORKSPACE/scripts/"
cp "$SCRIPT_DIR/scripts/check-timeout.py" "$WORKSPACE/scripts/"
chmod +x "$WORKSPACE/scripts/"*.py

# 创建示例文件
echo "📄 创建示例文件..."

# ACTIVE_CONTEXT.md
cat > "$WORKSPACE/ACTIVE_CONTEXT.md" << 'EOF'
# ACTIVE_CONTEXT.md - 当前工作上下文

> **最后更新**: 刚刚
> **用途**: 记录正在做什么、进度、阻塞点

---

## 🎯 当前任务

### 1. 示例任务
- **状态**: 🟡 进行中
- **进度**: 0%
- **下一步**: 开始执行

---

## 🚧 阻塞点

*暂无*

---

## 🔄 Session 恢复检查清单

- [ ] 读取 ACTIVE_CONTEXT.md
- [ ] 检查 TODO.md
- [ ] 查看 memory/YYYY-MM-DD.md
EOF

# TODO.md
cat > "$WORKSPACE/TODO.md" << 'EOF'
# TODO.md - 任务追踪

> **最后更新**: 刚刚
> **超时规则**: 6h→⏰ | 12h→⚠️ | 24h→🚨

---

## 📋 待办

### 🔴 高优先级
- [ ] 示例任务 | 来源：自己 | 截止：明天 | 优先：高

### 🟡 中优先级
*暂无*

### 🟢 低优先级
*暂无*

---

## ✅ 已完成

*暂无*

---

## ⏰ 超时警告

*暂无*
EOF

# 示例记忆文件
cat > "$WORKSPACE/memory/$(date +%Y-%m-%d).md" << EOF
# $(date +%Y-%m-%d) - 开始使用 Memory Index

[tags: first, memory-index]

## 今天学会了
- 安装了 Memory Index 三层记忆架构系统
- 创建了 ACTIVE_CONTEXT.md 和 TODO.md
- 设置了自动索引生成和超时检查

## 下一步
- 开始记录每天的工作
- 使用标签系统
- 定期回顾 MEMORY.md
EOF

# 运行一次生成索引
echo "📊 生成初始索引..."
python3 "$WORKSPACE/scripts/generate-memory-index.py"

# 添加 Cron 任务
echo ""
echo "⏰ 添加定时任务..."

# 索引生成（每天 2:00）
CRON_INDEX="0 2 * * * python3 $WORKSPACE/scripts/generate-memory-index.py"
if crontab -l 2>/dev/null | grep -q "$CRON_INDEX"; then
    echo "✅ 索引生成 Cron 已存在"
else
    (crontab -l 2>/dev/null | grep -v "$CRON_INDEX"; echo "$CRON_INDEX") | crontab -
    echo "✅ 索引生成 Cron 已添加（每天 2:00）"
fi

# 超时检查（每小时）
CRON_TIMEOUT="0 * * * * python3 $WORKSPACE/scripts/check-timeout.py"
if crontab -l 2>/dev/null | grep -q "$CRON_TIMEOUT"; then
    echo "✅ 超时检查 Cron 已存在"
else
    (crontab -l 2>/dev/null | grep -v "$CRON_TIMEOUT"; echo "$CRON_TIMEOUT") | crontab -
    echo "✅ 超时检查 Cron 已添加（每小时）"
fi

echo ""
echo "=========================================="
echo "✅ 安装完成！"
echo "=========================================="
echo ""
echo "📁 文件位置:"
echo "   - MEMORY.md: $WORKSPACE/MEMORY.md"
echo "   - ACTIVE_CONTEXT.md: $WORKSPACE/ACTIVE_CONTEXT.md"
echo "   - TODO.md: $WORKSPACE/TODO.md"
echo "   - 索引：$WORKSPACE/memory/INDEX.md"
echo "   - 脚本：$WORKSPACE/scripts/"
echo ""
echo "🎯 下一步:"
echo "   1. 编辑 ACTIVE_CONTEXT.md 添加当前任务"
echo "   2. 编辑 TODO.md 添加待办事项"
echo "   3. 在 memory/$(date +%Y-%m-%d).md 开始记录今天"
echo "   4. 查看索引：cat $WORKSPACE/memory/INDEX.md"
echo ""
echo "📖 更多信息：查看 README.md"
echo ""
