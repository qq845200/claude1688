#!/bin/bash
# auto-localize.sh - 每次启动时检查并重新汉化 Claude Code 二进制
# 修复: 升级后二进制被还原，需重新打补丁并正确签名

LOG="/tmp/claude-localize.log"
BIN="/opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe"
SRC="/opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/node_modules/@anthropic-ai/claude-code-darwin-arm64/claude"
BAK="/Users/oo/.claude/localize/backups/claude-2.1.148.bak.exe"

# 备份不存在则跳过
[ ! -f "$BAK" ] && exit 0

# 对比 SHA256
ORIG_SHA=$(shasum -a 256 "$BAK" 2>/dev/null | cut -d' ' -f1)
BIN_SHA=$(shasum -a 256 "$BIN" 2>/dev/null | cut -d' ' -f1)

if [ "$ORIG_SHA" != "$BIN_SHA" ]; then
    # 已经是汉化版本，无需重复
    exit 0
fi

# 需要重新汉化
echo "$(date): 检测到二进制被恢复，重新汉化..." >> "$LOG"

# 1. 先恢复原始备份
cp "$BAK" "$BIN" 2>> "$LOG"
cp "$BAK" "$SRC" 2>> "$LOG"

# 2. 执行汉化
node /Users/oo/.claude/localize/localize.js >> "$LOG" 2>&1

# 3. 复制汉化后的二进制到源
cp "$BIN" "$SRC" 2>> "$LOG"

# 4. 重新签名（macOS 必须，否则会被 kill）
codesign --force --sign - "$BIN" >> "$LOG" 2>&1
codesign --force --sign - "$SRC" >> "$LOG" 2>&1

echo "$(date): 汉化完成" >> "$LOG"
