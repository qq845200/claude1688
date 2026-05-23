# 🎨 Claude Code 中文汉化完整方案

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Supported Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Linux-brightgreen)](##安装与部署)
[![Claude Code Version](https://img.shields.io/badge/Claude%20Code-2.1.100+-yellow)](##版本兼容性)

> **一键恢复 Claude Code 中文界面** | 支持最新版本 | 自动升级保护

## ✨ 功能特性

- 🌍 **完整中文汉化** - 界面、命令、工具提示全覆盖
- ⚡ **一键恢复** - 无需手动配置，运行脚本即可
- 🔄 **升级保护** - Claude Code 升级后自动重新汉化
- 📊 **状态监控** - 中文状态栏显示使用统计
- 🎯 **智能钩子** - 工具执行后显示中文提示
- 💾 **版本备份** - 自动备份原始二进制文件
- 🔧 **易于维护** - 模块化设计，支持快速更新

## 📦 包含内容

```
claude-code-chinese-localization/
├── 恢复汉化.sh                    # 主恢复脚本（一键启动）
├── 快速开始.md                    # 快速入门指南
├── 完整安装指南.md                # 详细步骤说明
├── 常见问题FAQ.md                 # 问题解答
├── 原理说明.md                    # 技术原理
└── src/
    ├── localize.js                # 汉化核心引擎
    ├── binary-overrides.js        # 汉化词库（560+ 条目）
    ├── keyword.js                 # 界面关键词映射
    ├── description-map.js         # 命令与技能描述
    ├── localize-assets.js         # 资源文件处理
    ├── ensure-localized.js        # 验证汉化状态
    ├── auto-localize.sh           # 自动重汉化钩子
    ├── tool-tips-post.sh          # 工具提示（中文解释）
    └── monitor/                   # 状态监控模块
        ├── statusline.js          # 中文状态栏
        ├── constants.js           # 常量定义
        ├── formatters.js          # 格式化工具
        ├── stats-cache.js         # 缓存管理
        └── transcript-counter.js  # 会话统计
```

## 🚀 快速开始（3 步）

### 方式一：一键脚本（推荐）

```bash
# 1. 下载汉化脚本
mkdir -p ~/claude-汉化
cd ~/claude-汉化
git clone https://github.com/qq845200/claude1688.git
cd claude1688

# 2. 运行恢复脚本
bash 恢复汉化.sh

# 3. 重启 Claude Code 即生效
```

### 方式二：手动安装

```bash
# 1. 克隆本仓库
git clone https://github.com/qq845200/claude1688.git ~/claude-汉化备份

# 2. 进入项目目录
cd ~/claude-汉化备份

# 3. 执行主脚本
bash ~/claude-汉化备份/恢复汉化.sh
```

## 📋 详细指南

- 📘 [快速开始指南](docs/快速开始.md) - 5 分钟快速上手
- 📗 [完整安装指南](docs/完整安装指南.md) - 详细步骤和问题排查
- 📙 [常见问题 FAQ](docs/常见问题FAQ.md) - 问题与解答
- 📕 [原理说明](docs/原理说明.md) - 技术细节和工作机制
- 📓 [更新日志](docs/更新日志.md) - 版本历史

## 🔄 升级说明

**Claude Code 升级后怎么办？**

✅ **无需担心！** 我们提供了两种方式自动重新汉化：

1. **自动方式**（推荐）
   - 安装时自动配置 hooks
   - 每次 Claude Code 启动时自动检查并重汉化
   - 无需用户手动操作

2. **手动方式**
   - 升级后再次运行 `bash 恢复汉化.sh` 即可
   - 脚本会自动检测新版本并应用汉化

## 💻 系统要求

| 项目 | 要求 |
|------|------|
| **操作系统** | macOS 10.15+ / Ubuntu 20.04+ / Debian 11+ |
| **Claude Code** | v2.1.100 及以上 |
| **必要工具** | npm, node, bash, git |
| **磁盘空间** | ~50 MB（含备份） |
| **网络** | 仅首次安装需要（下载依赖） |

### 平台支持

- ✅ **macOS** (Intel / Apple Silicon)
- ✅ **Linux** (x86_64 / ARM64)
- ⚠️ **Windows** (WSL 推荐，原生 PowerShell 支持开发中)

## 🎯 工作原理

### 1. 二进制汉化 (Native Mode)
- 直接修改 Claude Code 二进制文件
- 支持 560+ 界面文本替换
- 自动版本备份和签名

### 2. 资源汉化 (Asset Mode)
- 处理命令描述和技能说明
- 支持 Markdown frontmatter 自动翻译
- 覆盖工作区和全局命令

### 3. 状态监控 (Monitor)
- 实时显示中文状态栏
- 统计调用次数、费用、Token 使用
- 自动缓存和增量更新

### 4. 智能钩子 (Hooks)
- PostToolUse 钩子：工具执行后显示中文提示
- SessionStart 钩子：启动时自动重汉化
- 支持 Bash、Edit、Grep、Glob 等工具提示

## 📊 汉化覆盖范围

| 类别 | 覆盖 | 数量 |
|------|------|------|
| 🎨 界面文本 | 完全 | 380+ 条目 |
| 💬 命令描述 | 完全 | 120+ 条目 |
| 🔧 工具提示 | 完全 | 60+ 条目 |
| 📝 技能说明 | 完全 | 150+ 条目 |
| 🖥️ 命令解释 | 完全 | 100+ 命令 |
| **总计** | **完全覆盖** | **810+ 条目** |

## 🔐 安全性

- ✅ **MIT 开源许可** - 完全透明
- ✅ **自动备份** - 保留原始二进制
- ✅ **可随时还原** - 从备份恢复原始
- ✅ **代码审计** - 所有脚本可读可审查
- ✅ **无远程连接** - 本地执行，不收集数据

## 📁 备份位置

```bash
# 汉化文件和备份位置
~/.claude/localize/              # 汉化脚本目录
~/.claude/localize/backups/      # 备份文件夹
~/.claude/hooks/                 # 钩子脚本
~/.claude/monitor/               # 监控模块
```

## 🆘 问题排查

### 问题 1：权限不足
```bash
# 解决方案：赋予脚本执行权限
chmod +x 恢复汉化.sh
bash 恢复汉化.sh
```

### 问题 2：找不到 Claude Code
```bash
# 检查安装路径
which claude
npm list -g @anthropic-ai/claude-code
```

### 问题 3：升级后汉化消失
```bash
# 自动重新汉化
bash ~/claude-汉化备份/恢复汉化.sh

# 或使用自动钩子（已在首次安装时配置）
# 启动 Claude Code 即自动重汉化
```

更多问题请查看 [常见问题 FAQ](docs/常见问题FAQ.md)

## 🤝 贡献指南

欢迎贡献！提交流程：

1. **Fork** 本仓库
2. **创建** feature 分支 (`git checkout -b feature/amazing-feature`)
3. **提交** 更改 (`git commit -m 'Add some amazing feature'`)
4. **推送** 到分支 (`git push origin feature/amazing-feature`)
5. **创建** Pull Request

### 贡献方式

- 🐛 **报告问题** - 提交 Issue 描述 Bug
- ✨ **新功能建议** - 在 Discussions 中讨论
- 📝 **改进文档** - 更新或增加文档内容
- 🌍 **新语言支持** - 添加其他语言汉化
- 🔄 **词库更新** - 优化或增加汉化词条

### 维护者

- 🇨🇳 中文汉化：[@qq845200](https://github.com/qq845200)
- 📚 文档维护：[@qq845200](https://github.com/qq845200)

## 📈 版本历史

| 版本 | 日期 | Claude Code 支持 | 状态 |
|------|------|------------------|------|
| v2.1.148 | 2026-05-22 | 2.1.148 | ✅ 正式版 |
| v2.1.0-beta | 2026-05-20 | 2.1.100-2.1.148 | ✅ 测试版 |

详见 [完整更新日志](docs/更新日志.md)

## 📄 许可证

本项目采用 **MIT License** - 详见 [LICENSE](LICENSE) 文件

```
MIT License

Copyright (c) 2026 Claude Code 中文汉化项目

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
```

## 🌟 Stars & 支持

如果这个项目对您有帮助，请给个 ⭐️ Star！

这能帮助更多人发现这个项目 ~

## 📞 联系方式

- 📧 **GitHub Issues** - [报告问题](https://github.com/qq845200/claude1688/issues)
- 💬 **Discussions** - [讨论和建议](https://github.com/qq845200/claude1688/discussions)
- 🐦 **Twitter** - [@qq845200](https://twitter.com/qq845200) *(如有)*

## 🙏 致谢

感谢以下项目和贡献者：

- Claude Code 官方团队 - 优秀的编程助手
- Anthropic - 开源支持
- 所有贡献者和用户

---

## 🔗 相关链接

- [Claude 官网](https://claude.ai)
- [Claude Code 文档](https://docs.anthropic.com)
- [GitHub 仓库](https://github.com/qq845200/claude1688)
- [项目讨论](https://github.com/qq845200/claude1688/discussions)

---

<div align="center">

**Made with ❤️ for Claude Code Users**

如有问题或建议，欢迎提交 Issue 或 PR！

[⬆ 回到顶部](#-claude-code-中文汉化完整方案)

</div>
