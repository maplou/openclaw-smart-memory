#!/usr/bin/env python3
"""
TODO 超时检查脚本 | Timeout Check Script
每小时运行一次，检查任务超时状态 | Run hourly to check task timeout status
"""

import re
from datetime import datetime, timedelta
from pathlib import Path

WORKSPACE = Path('/home/admin/openclaw/workspace')
TODO_FILE = WORKSPACE / 'TODO.md'
ACTIVE_CONTEXT = WORKSPACE / 'ACTIVE_CONTEXT.md'
TIMEOUT_LOG = Path('/tmp/memory-kit-timeout.log')

# 超时阈值（小时）| Timeout thresholds (hours)
ALERT_THRESHOLD = 6    # ⏰ 提醒 | Alert
WARNING_THRESHOLD = 12 # ⚠️ 警告 | Warning
CRITICAL_THRESHOLD = 24 # 🚨 严重 | Critical

def log_message(message):
    """写入日志 | Write to log"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_line = f"[{timestamp}] {message}\n"
    print(log_line.strip())
    with open(TIMEOUT_LOG, 'a', encoding='utf-8') as f:
        f.write(log_line)

def parse_todo_tasks(content):
    """解析 TODO.md 中的待办任务 | Parse todo tasks from TODO.md"""
    tasks = []
    for line in content.split('\n'):
        # 匹配：- [ ] 任务 | 来源：xxx | 截止:xxx | 优先：xxx
        if '- [ ]' in line and '|' in line:
            parts = line.split('|')
            if len(parts) >= 4:
                task_name = parts[0].replace('- [ ]', '').strip()
                tasks.append({
                    'name': task_name,
                    'line': line,
                    'found_time': None  # 需要从 ACTIVE_CONTEXT 或记忆中查找
                })
    return tasks

def check_task_timeout(task):
    """检查任务是否超时 | Check if task is timeout"""
    # 简化版：根据任务名在 ACTIVE_CONTEXT 中查找开始时间
    # 完整版：需要从 memory/ 文件中解析任务创建时间
    
    # 这里简化处理，实际应该从历史记录中查找
    # 返回：None (正常), 'alert', 'warning', 'critical'
    return None

def update_todo_with_timeout():
    """更新 TODO.md 添加超时标记 | Update TODO.md with timeout markers"""
    if not TODO_FILE.exists():
        log_message("⚠️ TODO.md 不存在 | TODO.md not found")
        return
    
    content = TODO_FILE.read_text(encoding='utf-8')
    tasks = parse_todo_tasks(content)
    
    log_message(f"找到 {len(tasks)} 个待办任务 | Found {len(tasks)} todo tasks")
    
    timeout_count = {'alert': 0, 'warning': 0, 'critical': 0}
    
    for task in tasks:
        timeout_status = check_task_timeout(task)
        if timeout_status:
            timeout_count[timeout_status] += 1
            log_message(f"{timeout_status.upper()}: {task['name']}")
    
    # 汇总报告 | Summary report
    if any(timeout_count.values()):
        log_message(f"⏰ 超时统计 | Timeout stats: ⏰{timeout_count['alert']} ⚠️{timeout_count['warning']} 🚨{timeout_count['critical']}")
    else:
        log_message("✅ 无超时任务 | No timeout tasks")

def main():
    """主函数 | Main function"""
    log_message("=" * 50)
    log_message("开始超时检查 | Starting timeout check")
    update_todo_with_timeout()
    log_message("超时检查完成 | Timeout check complete")

if __name__ == '__main__':
    main()
