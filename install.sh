#!/bin/bash
# OpenClaw Memory Kit 安装脚本
# OpenClaw Memory Kit Installation Script

set -e

echo "🚀 安装 OpenClaw Memory Kit - 三层记忆架构系统..."
echo "🚀 Installing OpenClaw Memory Kit - Three-Layer Memory System..."
echo ""

# 获取脚本目录 | Get Script Directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE="${MEMORY_INDEX_WORKSPACE:-/home/admin/openclaw/workspace}"

echo "📁 工作目录 | Workspace: $WORKSPACE"
echo ""

# 创建目录 | Create Directories
echo "📁 创建目录结构 | Creating directory structure..."
mkdir -p "$WORKSPACE/scripts"
mkdir -p "$WORKSPACE/memory"
mkdir -p "$WORKSPACE/outputs"
mkdir -p "$WORKSPACE/data"

# 复制脚本 | Copy Scripts
echo "📝 复制脚本 | Copying scripts..."
cp "$SCRIPT_DIR/scripts/generate-memory-index.py" "$WORKSPACE/scripts/"
cp "$SCRIPT_DIR/scripts/check-timeout.py" "$WORKSPACE/scripts/"
chmod +x "$WORKSPACE/scripts/"*.py

# 创建示例文件 | Create Example Files
echo "📄 创建示例文件 | Creating example files..."

# ACTIVE_CONTEXT.md
cat > "$WORKSPACE/ACTIVE_CONTEXT.md" << 'EOF'
# ACTIVE_CONTEXT.md - 当前工作上下文 | Current Context

> **最后更新 | Last Updated**: 刚刚 | Just now  
> **用途 | Purpose**: 记录正在做什么、进度、阻塞点 | Record what you're doing, progress, blockers

---

## 🎯 当前任务 | Current Tasks

### 1. 示例任务 | Example Task
- **状态 | Status**: 🟡 进行中 | In Progress
- **进度 | Progress**: 0%
- **下一步 | Next**: 开始执行 | Start execution

---

## 🚧 阻塞点 | Blockers

*暂无 | None*

---

## 🔄 Session 恢复检查清单 | Session Recovery Checklist

- [ ] 读取 ACTIVE_CONTEXT.md | Read ACTIVE_CONTEXT.md
- [ ] 检查 TODO.md | Check TODO.md
- [ ] 查看 memory/YYYY-MM-DD.md | View memory/YYYY-MM-DD.md
EOF

# TODO.md
cat > "$WORKSPACE/TODO.md" << 'EOF'
# TODO.md - 任务追踪 | Task Tracking

> **最后更新 | Last Updated**: 刚刚 | Just now  
> **超时规则 | Timeout Rules**: 6h→⏰ | 12h→⚠️ | 24h→🚨

---

## 📋 待办 | Todo

### 🔴 高优先级 | High Priority
- [ ] 示例任务 | Example Task | 来源：自己 | Source: Self | 截止：明天 | Due: Tomorrow | 优先：高 | Priority: High

### 🟡 中优先级 | Medium Priority
*暂无 | None*

### 🟢 低优先级 | Low Priority
*暂无 | None*

---

## ✅ 已完成 | Done

*暂无 | None*

---

## ⏰ 超时警告 | Timeout Alerts

*暂无 | None*
EOF

# 示例记忆文件 | Example Memory File
cat > "$WORKSPACE/memory/$(date +%Y-%m-%d).md" << EOF
# $(date +%Y-%m-%d) - 开始使用 Memory Index | Start Using Memory Index

[tags: first, memory-index]

## 今天学会了 | Today I Learned
- 安装了 Memory Index 三层记忆架构系统 | Installed Memory Kit
- 创建了 ACTIVE_CONTEXT.md 和 TODO.md | Created files
- 设置了自动索引生成和超时检查 | Set up auto index and timeout check

## 下一步 | Next Steps
- 开始记录每天的工作 | Start recording daily work
- 使用标签系统 | Use tag system
- 定期回顾 MEMORY.md | Review MEMORY.md regularly
EOF

# 运行一次生成索引 | Generate Initial Index
echo "📊 生成初始索引 | Generating initial index..."
python3 "$WORKSPACE/scripts/generate-memory-index.py"

# 添加 Cron 任务 | Add Cron Jobs
echo ""
echo "⏰ 添加定时任务 | Adding cron jobs..."

# 索引生成（每天 2:00）| Index Generation (Daily 2AM)
CRON_INDEX="0 2 * * * python3 $WORKSPACE/scripts/generate-memory-index.py"
if crontab -l 2>/dev/null | grep -q "$CRON_INDEX"; then
    echo "✅ 索引生成 Cron 已存在 | Index cron exists"
else
    (crontab -l 2>/dev/null | grep -v "$CRON_INDEX"; echo "$CRON_INDEX") | crontab -
    echo "✅ 索引生成 Cron 已添加（每天 2:00）| Index cron added (Daily 2AM)"
fi

# 超时检查（每小时）| Timeout Check (Hourly)
CRON_TIMEOUT="0 * * * * python3 $WORKSPACE/scripts/check-timeout.py"
if crontab -l 2>/dev/null | grep -q "$CRON_TIMEOUT"; then
    echo "✅ 超时检查 Cron 已存在 | Timeout cron exists"
else
    (crontab -l 2>/dev/null | grep -v "$CRON_TIMEOUT"; echo "$CRON_TIMEOUT") | crontab -
    echo "✅ 超时检查 Cron 已添加（每小时）| Timeout cron added (Hourly)"
fi

echo ""
echo "=========================================="
echo "✅ 安装完成！| Installation Complete!"
echo "=========================================="
echo ""
echo "📁 文件位置 | File Locations:"
echo "   - MEMORY.md: $WORKSPACE/MEMORY.md"
echo "   - ACTIVE_CONTEXT.md: $WORKSPACE/ACTIVE_CONTEXT.md"
echo "   - TODO.md: $WORKSPACE/TODO.md"
echo "   - 索引 | Index: $WORKSPACE/memory/INDEX.md"
echo "   - 脚本 | Scripts: $WORKSPACE/scripts/"
echo ""
echo "🎯 下一步 | Next Steps:"
echo "   1. 编辑 ACTIVE_CONTEXT.md 添加当前任务 | Edit to add current tasks"
echo "   2. 编辑 TODO.md 添加待办事项 | Edit to add todo items"
echo "   3. 在 memory/$(date +%Y-%m-%d).md 开始记录今天 | Start recording today"
echo "   4. 查看索引 | View index: cat $WORKSPACE/memory/INDEX.md"
echo ""
echo "📖 更多信息 | More Info: 查看 | See README.md"
echo ""
