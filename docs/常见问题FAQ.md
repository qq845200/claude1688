# 📙 Claude Code 中文汉化 - 常见问题 FAQ

## 🎯 快速导航

- [安装相关](#安装相关)
- [使用相关](#使用相关)
- [升级相关](#升级相关)
- [故障排除](#故障排除)
- [卸载和还原](#卸载和还原)

---

## 安装相关

### Q1: 支持哪些系统？

**A:** 目前支持以下系统：

| 系统 | 架构 | 支持状态 |
|------|------|----------|
| macOS | Intel (x86_64) | ✅ 完全支持 |
| macOS | Apple Silicon (ARM64) | ✅ 完全支持 |
| Ubuntu | x86_64 | ✅ 完全支持 |
| Ubuntu | ARM64 | ✅ 完全支持 |
| Debian | x86_64 | ✅ 完全支持 |
| Debian | ARM64 | ✅ 完全支持 |
| Windows (WSL) | x86_64 | 🚧 开发中 |
| Windows (native) | x86_64 | ❌ 不支持 |

### Q2: 需要什么前置条件？

**A:**

- ✅ Claude Code v2.1.100 或更新版本
- ✅ Node.js 16 或更新版本
- ✅ bash shell
- ✅ 互联网连接（仅首次安装）

验证命令：
```bash
node --version   # 应该 >= v16.0.0
npm --version    # 应该 >= 8.0.0
claude --version # 应该 >= 2.1.100
```

### Q3: 可以安装在哪些位置？

**A:** 可以安装在任何位置，推荐位置：

```bash
# 推荐位置
~/claude-汉化备份
~/Desktop/claude-汉化
~/.claude/localize

# 只要有执行权限即可
# 避免以下位置：
# - /System (macOS 系统目录)
# - /Program Files (Windows)
# - /root (root 用户主目录)
```

### Q4: 需要 sudo 权限吗？

**A:** 通常不需要。但在以下情况可能需要：

```bash
# 如果 npm 全局包安装在系统目录
npm list -g @anthropic-ai/claude-code

# 如果看到权限错误，可能需要：
sudo bash 恢复汉化.sh

# 或者更好的方法是重新配置 npm
npm config set prefix ~/.npm-global
export PATH=~/.npm-global/bin:$PATH
```

---

## 使用相关

### Q5: 安装后如何验证成功？

**A:** 启动 Claude Code 后检查以下几点：

```bash
# 1. 启动
claude

# 2. 查看是否出现中文欢迎信息
# 应该看到："欢迎回来!" 而不是 "Welcome back!"

# 3. 尝试以下命令：
/help      # 显示中文帮助
/config    # 打开配置面板（中文）
/status    # 显示中文状态信息
```

如果都是中文，恭喜！✅ 安装成功！

### Q6: 如何查看汉化了哪些内容？

**A:** 查看汉化词库：

```bash
# 查看界面文本汉化
cat ~/claude-汉化备份/claude1688/src/keyword.js

# 查看二进制汉化
cat ~/claude-汉化备份/claude1688/src/binary-overrides.js

# 查看命令描述汉化
cat ~/claude-汉化备份/claude1688/src/description-map.js
```

### Q7: 可以修改汉化内容吗？

**A:** 可以！修改步骤：

```bash
# 1. 编辑词库文件
vim ~/claude-汉化备份/claude1688/src/keyword.js

# 2. 找到要修改的条目，例如：
# "Old Text": "旧文本",
# 改为：
# "Old Text": "新文本",

# 3. 保存文件（vim: 按 :wq）

# 4. 重新运行汉化脚本
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh

# 5. 重启 Claude Code
claude
```

### Q8: 汉化会影响功能吗？

**A:** 不会！汉化只改变显示文本，不改变功能。所有命令和工具都正常工作。

---

## 升级相关

### Q9: Claude Code 升级后怎么办？

**A:** 有两种方式自动处理：

**方式 1：自动重汉化（推荐）**

```bash
# Claude Code 升级后，启动时会自动检查并重汉化
claude

# 后台会自动运行钩子脚本检查和修复
```

**方��� 2：手动重汉化**

```bash
# 如果自动方式不工作，手动运行：
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh

# 重启
claude
```

### Q10: 自动更新怎么关闭？

**A:** 关闭 Claude Code 自动更新：

```bash
# 编辑配置文件
vim ~/.claude/settings.json

# 找到或添加：
{
  "autoupdate": false
}

# 保存后生效
```

### Q11: 如何更新汉化到最新版本？

**A:**

```bash
# 1. 进入项目目录
cd ~/claude-汉化备份/claude1688

# 2. 拉取最新代码
git pull origin main

# 3. 重新运行汉化
bash 恢复汉化.sh

# 4. 重启 Claude Code
claude
```

---

## 故障排除

### Q12: 运行脚本时出现 "Permission denied"

**A:** 赋予执行权限：

```bash
# 方案 1：加权限
chmod +x ~/claude-汉化备份/claude1688/恢复汉化.sh
bash ~/claude-汉化备份/claude1688/恢复汉化.sh

# 方案 2：用 bash 明确运行
bash ~/claude-汉化备份/claude1688/恢复汉化.sh
```

### Q13: "Cannot find Claude Code"

**A:** 检查和修复安装：

```bash
# 1. 检查是否安装
which claude
npm list -g @anthropic-ai/claude-code

# 2. 如果未安装，执行：
npm install -g @anthropic-ai/claude-code

# 3. 验证
claude --version

# 4. 再次运行汉化
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh
```

### Q14: 汉化没有生效

**A:** 尝试以下排查步骤：

```bash
# 1. 确保脚本成功运行（检查输出）
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh 2>&1 | tail -20

# 2. 检查汉化文件是否存在
ls -la ~/.claude/localize/
ls -la ~/.claude/hooks/

# 3. 完全关闭 Claude Code（等 5 秒）
# 在 Claude Code 中按 Ctrl+C
# 等待 5 秒

# 4. 清除缓存
rm -rf ~/.claude/cache/*

# 5. 重新启动
claude
```

### Q15: 启动 Claude Code 很慢

**A:** 可能是钩子脚本影响，检查日志：

```bash
# 查看汉化日志
tail -50 /tmp/claude-localize.log

# 如果有很多错误，可以禁用自动钩子
vim ~/.claude/settings.json

# 找到 hooks 相关配置，改为：
{
  "hooks": {
    "SessionStart": []
  }
}
```

### Q16: 某些命令或菜单还是英文

**A:** 可能是特殊字符编码问题，尝试：

```bash
# 1. 检查系统语言设置
locale

# 应该看到 UTF-8：
# LANG=zh_CN.UTF-8

# 2. 如果不是 UTF-8，设置为：
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 3. 重新运行汉化
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh
```

---

## 卸载和还原

### Q17: 如何卸载汉化？

**A:** 完全还原为英文：

```bash
# 1. 查看备份
ls ~/.claude/localize/backups/

# 2. 复制备份覆盖当前版本
# 根据你的系统选择合适的备份，例如 macOS ARM64：
cp ~/.claude/localize/backups/claude-2.1.148.bak.exe \
   /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe

# 3. 重启
claude
```

### Q18: 如何完全删除汉化工具？

**A:**

```bash
# 1. 删除汉化文件
rm -rf ~/.claude/localize
rm -rf ~/.claude/hooks
rm -rf ~/.claude/monitor

# 2. 删除项目目录（可选）
rm -rf ~/claude-汉化备份

# 3. 还原 Claude Code 为最新版本
npm install -g @anthropic-ai/claude-code@latest

# 4. 验证
claude --version
```

### Q19: 还原后想再用汉化怎么办？

**A:** 简单重新安装：

```bash
# 1. 克隆项目
cd ~/claude-汉化备份/claude1688

# 2. 运行脚本
bash 恢复汉化.sh

# 3. 重启
claude
```

---

## 其他问题

### Q20: 这个项目是官方的吗？

**A:** 不是。这是社区项目，由热心用户维护。

- 完全开源（MIT 许可证）
- 代码可读可审查
- 不收集任何用户数据
- 不与官方 Anthropic 关联

### Q21: 会不会导致账号被封禁？

**A:** 不会。汉化只修改本地显示文本，不改变与服务器的通信。完全安全。

### Q22: 支持多个用户？

**A:** 支持！不同用户独立安装：

```bash
# 每个用户分别运行
# user1
su user1
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh

# user2
su user2
cd ~/claude-汉化备份/claude1688
bash 恢复汉化.sh
```

---

## 📞 还有问题？

- 📖 查看 [快速开始](快速开始.md)
- 📗 查看 [完整安装指南](完整安装指南.md)
- 🐛 提交 [GitHub Issue](https://github.com/qq845200/claude1688/issues)
- 💬 参与 [讨论](https://github.com/qq845200/claude1688/discussions)

---

**最后更新：2026-05-23**
