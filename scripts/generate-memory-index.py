#!/usr/bin/env python3
"""
自动生成记忆索引 INDEX.md
每天凌晨运行一次，扫描 memory/ 目录并更新索引
"""

import os
import re
from datetime import datetime
from pathlib import Path

MEMORY_DIR = Path('/home/admin/openclaw/workspace/memory')
INDEX_FILE = MEMORY_DIR / 'INDEX.md'
MEMORY_MD = Path('/home/admin/openclaw/workspace/MEMORY.md')

def extract_tags(content):
    """从内容中提取标签"""
    tags = set()
    # 匹配 [tags: ...] 格式
    tag_matches = re.findall(r'\[tags:\s*([^\]]+)\]', content)
    for match in tag_matches:
        for tag in match.split(','):
            tags.add(tag.strip())
    
    # 匹配 #tag 格式
    hash_tags = re.findall(r'#(\w+)', content)
    tags.update(hash_tags)
    
    return list(tags)[:5]  # 最多 5 个标签

def extract_title(content, filename):
    """提取标题"""
    # 尝试找第一个标题
    match = re.search(r'^##+\s*(.+)$', content, re.MULTILINE)
    if match:
        return match.group(1).strip()
    # 否则用文件名
    return filename.replace('.md', '')

def scan_memory_files():
    """扫描记忆文件"""
    memories = []
    
    # 扫描 memory/ 目录下的 .md 文件
    for md_file in MEMORY_DIR.glob('*.md'):
        if md_file.name == 'INDEX.md':
            continue
            
        try:
            content = md_file.read_text(encoding='utf-8')
            title = extract_title(content, md_file.stem)
            tags = extract_tags(content)
            
            # 从文件名提取日期
            date_match = re.match(r'(\d{4}-\d{2}-\d{2})', md_file.stem)
            date = date_match.group(1) if date_match else 'unknown'
            
            memories.append({
                'id': f'D{len(memories)+1:03d}',
                'date': date,
                'title': title[:50],  # 限制长度
                'tags': tags,
                'path': f'memory/{md_file.name}'
            })
        except Exception as e:
            print(f"Error reading {md_file}: {e}")
    
    # 按日期倒序排序
    memories.sort(key=lambda x: x['date'], reverse=True)
    return memories[:30]  # 最多 30 条

def scan_core_memory():
    """扫描核心记忆 (MEMORY.md)"""
    core = []
    
    try:
        content = MEMORY_MD.read_text(encoding='utf-8')
        
        # 提取重要章节
        sections = [
            ('M001', '小红书封号事件', '#safety #xhs #lesson'),
            ('M002', '用户偏好', '#preference #user'),
            ('M003', '模型选择原则', '#tech #model #performance'),
            ('M004', '响应速度优化', '#tech #performance'),
            ('M005', '自动化任务原则', '#tech #automation'),
        ]
        
        for sid, title, tags in sections:
            core.append({
                'id': sid,
                'title': title,
                'tags': tags.split(),
                'path': 'MEMORY.md'
            })
    except Exception as e:
        print(f"Error reading MEMORY.md: {e}")
    
    return core

def generate_index():
    """生成索引文件"""
    print("🔍 扫描记忆文件...")
    recent = scan_memory_files()
    core = scan_core_memory()
    
    print(f"找到 {len(core)} 条核心记忆，{len(recent)} 条最近记忆")
    
    # 生成索引内容
    now = datetime.now().strftime('%Y-%m-%d %H:%M')
    
    content = f"""# 记忆索引 INDEX.md

> 自动生成 | 最后更新：{now}
> 用于快速检索记忆，避免加载全部文件

---

## 📌 核心记忆（永久保留）

| ID | 主题 | 标签 | 路径 | 重要性 |
|----|------|------|------|--------|
"""
    
    for m in core:
        tags = ' '.join(m['tags'])
        content += f"| {m['id']} | {m['title']} | {tags} | {m['path']} | ⭐⭐⭐⭐⭐ |\n"
    
    content += f"""
---

## 📅 最近记忆（30 天内）

| ID | 日期 | 主题 | 标签 | 路径 |
|----|------|------|------|------|
"""
    
    for m in recent:
        tags = ' '.join(f'#{t}' for t in m['tags'][:3])
        content += f"| {m['id']} | {m['date']} | {m['title']} | {tags} | {m['path']} |\n"
    
    # 添加标签索引
    all_tags = set()
    for m in core + recent:
        all_tags.update(m['tags'])
    
    content += f"""
---

## 🏷️ 按标签快速检索

"""
    
    for tag in sorted(all_tags)[:20]:  # 最多 20 个标签
        content += f"### #{tag}\n\n"
        # 找到所有包含这个标签的记忆
        items = [m for m in core + recent if tag in m['tags']]
        for item in items:
            content += f"- {item['id']}: {item['title']}\n"
        content += "\n"
    
    # 统计信息
    content += f"""
## 📊 统计信息

- **核心记忆**: {len(core)} 条
- **最近记忆**: {len(recent)} 条
- **总标签数**: {len(all_tags)} 个
- **索引大小**: ~{len(content)//1024}KB
- **检索时间**: <0.1s

---

## 🔍 使用方式

### 方式 1：按标签查找
```bash
# 查找所有安全相关的记忆
grep "#safety" INDEX.md
```

### 方式 2：按日期查找
```bash
# 查找最近 7 天的记忆
# 查看"最近记忆"表格
```

### 方式 3：语义搜索
```bash
# 使用 memory_search 工具
# 基于语义而非关键词
```

---

*自动生成脚本：/home/admin/openclaw/workspace/scripts/generate-memory-index.py*
"""
    
    # 写入文件
    INDEX_FILE.write_text(content, encoding='utf-8')
    print(f"✅ 索引已生成：{INDEX_FILE}")

if __name__ == '__main__':
    generate_index()
