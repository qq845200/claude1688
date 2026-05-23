#!/bin/bash
# ========================================
# Claude Code 一键恢复汉化
# 用法: bash ~/Desktop/claude-汉化备份/恢复汉化.sh
# ========================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[38;5;206m'
NC='\033[0m'

BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
LOCALIZE_DIR="$CLAUDE_DIR/localize"
HOOKS_DIR="$CLAUDE_DIR/hooks"
MONITOR_DIR="$CLAUDE_DIR/monitor"
BIN=""
SRC=""

echo ""
echo "${MAGENTA}════════════════════════════════════════════${NC}"
echo "${MAGENTA}     Claude Code 汉化恢复工具${NC}"
echo "${MAGENTA}════════════════════════════════════════════${NC}"
echo ""

# 检测 Claude Code 安装路径
PKG_NAME="@anthropic-ai/claude-code"
NPM_ROOT=$(npm root -g 2>/dev/null)
if [ -z "$NPM_ROOT" ]; then
  echo "${RED}错误: 找不到 npm 全局目录${NC}"
  exit 1
fi

BIN="$NPM_ROOT/$PKG_NAME/bin/claude.exe"
SRC_CANDIDATES=(
  "$NPM_ROOT/$PKG_NAME/node_modules/@anthropic-ai/claude-code-darwin-arm64/claude"
  "$NPM_ROOT/$PKG_NAME/node_modules/@anthropic-ai/claude-code-darwin-x64/claude"
  "$NPM_ROOT/$PKG_NAME/node_modules/@anthropic-ai/claude-code-linux-arm64/claude"
  "$NPM_ROOT/$PKG_NAME/node_modules/@anthropic-ai/claude-code-linux-x64/claude"
)

SRC=""
for c in "${SRC_CANDIDATES[@]}"; do
  if [ -f "$c" ]; then SRC="$c"; break; fi
done

if [ ! -f "$BIN" ]; then
  echo "${RED}错误: 找不到 Claude Code 二进制${NC}"
  echo "${YELLOW}路径: $BIN${NC}"
  exit 1
fi

# 获取版本号
VERSION=$(node -e "
  try { console.log(require('$NPM_ROOT/$PKG_NAME/package.json').version) }
  catch(e) { console.log('unknown') }
")

echo "${CYAN}Claude Code 版本: $VERSION${NC}"
echo "${CYAN}二进制路径: $BIN${NC}"
if [ -n "$SRC" ]; then
  echo "${CYAN}源文件路径: $SRC${NC}"
fi
echo ""

# 1. 复制汉化脚本
echo "${MAGENTA}[1/5] 复制汉化脚本...${NC}"
mkdir -p "$LOCALIZE_DIR" "$HOOKS_DIR" "$MONITOR_DIR"

cp "$BACKUP_DIR/binary-overrides.js" "$LOCALIZE_DIR/"
cp "$BACKUP_DIR/keyword.js" "$LOCALIZE_DIR/"
cp "$BACKUP_DIR/description-map.js" "$LOCALIZE_DIR/"
cp "$BACKUP_DIR/localize.js" "$LOCALIZE_DIR/"
cp "$BACKUP_DIR/localize-assets.js" "$LOCALIZE_DIR/"
cp "$BACKUP_DIR/ensure-localized.js" "$LOCALIZE_DIR/"
echo "${GREEN}  已复制 6 个汉化脚本${NC}"

# 2. 复制 Hook 和监控脚本
echo "${MAGENTA}[2/5] 复制工具提示 Hook + 监控状态栏...${NC}"
cp "$BACKUP_DIR/tool-tips-post.sh" "$HOOKS_DIR/"
chmod +x "$HOOKS_DIR/tool-tips-post.sh"

cp "$BACKUP_DIR/auto-localize.sh" "$HOOKS_DIR/"
chmod +x "$HOOKS_DIR/auto-localize.sh"

cp "$BACKUP_DIR/statusline.js" "$MONITOR_DIR/"
cp "$BACKUP_DIR/constants.js" "$MONITOR_DIR/"
cp "$BACKUP_DIR/formatters.js" "$MONITOR_DIR/"
cp "$BACKUP_DIR/stats-cache.js" "$MONITOR_DIR/"
cp "$BACKUP_DIR/transcript-counter.js" "$MONITOR_DIR/"
chmod +x "$MONITOR_DIR/statusline.js"
echo "${GREEN}  已复制 Hook + 监控脚本${NC}"

# 3. 备份当前二进制
echo "${MAGENTA}[3/5] 备份原始二进制...${NC}"
BACKUP_ROOT="$LOCALIZE_DIR/backups"
mkdir -p "$BACKUP_ROOT"
BAK="$BACKUP_ROOT/claude-$VERSION.bak.exe"
if [ ! -f "$BAK" ]; then
  cp "$BIN" "$BAK"
  echo "${GREEN}  已备份: claude-$VERSION.bak.exe${NC}"
else
  echo "${YELLOW}  备份已存在，跳过${NC}"
fi

# 4. 执行汉化
echo "${MAGENTA}[4/5] 执行二进制汉化...${NC}"
cd "$LOCALIZE_DIR"
node localize.js

# 复制汉化后的二进制到源
if [ -n "$SRC" ]; then
  cp "$BIN" "$SRC"
fi

# 签名
echo "${MAGENTA}[5/5] 重新签名...${NC}"
codesign --force --sign - "$BIN" 2>/dev/null
if [ -n "$SRC" ]; then
  codesign --force --sign - "$SRC" 2>/dev/null
fi

# 更新 auto-localize.sh 中的路径变量
cat > "$HOOKS_DIR/auto-localize.sh" << AUTOSHELL
#!/bin/bash
# auto-localize.sh - 每次启动时检查并重新汉化
LOG="/tmp/claude-localize.log"
BIN="$BIN"
SRC="$SRC"
BAK="$BAK"

[ ! -f "\$BAK" ] && exit 0

ORIG_SHA=\$(shasum -a 256 "\$BAK" 2>/dev/null | cut -d' ' -f1)
BIN_SHA=\$(shasum -a 256 "\$BIN" 2>/dev/null | cut -d' ' -f1)

if [ "\$ORIG_SHA" != "\$BIN_SHA" ]; then
    exit 0
fi

echo "\$(date): 检测到二进制被恢复，重新汉化..." >> "\$LOG"
cp "\$BAK" "\$BIN" 2>> "\$LOG"
cp "\$BAK" "\$SRC" 2>> "\$LOG"
node $LOCALIZE_DIR/localize.js >> "\$LOG" 2>&1
cp "\$BIN" "\$SRC" 2>> "\$LOG"
codesign --force --sign - "\$BIN" >> "\$LOG" 2>&1
codesign --force --sign - "\$SRC" >> "\$LOG" 2>&1
echo "\$(date): 汉化完成" >> "\$LOG"
AUTOSHELL
chmod +x "$HOOKS_DIR/auto-localize.sh"

# 更新 settings.json 中的 hooks
echo ""
echo "${MAGENTA}更新 settings.json...${NC}"
node -e "
const fs = require('fs');
const path = require('path');
const settingsPath = path.join('$CLAUDE_DIR', 'settings.json');
const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));

settings.hooks = settings.hooks || {};
settings.hooks.SessionStart = settings.hooks.SessionStart || [];
const hasAuto = settings.hooks.SessionStart.some(h =>
  h.hooks && h.hooks.some(hh => (hh.command || '').includes('auto-localize'))
);
if (!hasAuto) {
  settings.hooks.SessionStart.push({
    hooks: [{ type: 'command', command: '$HOOKS_DIR/auto-localize.sh' }]
  });
}

settings.hooks.PostToolUse = settings.hooks.PostToolUse || [];
const hasTips = settings.hooks.PostToolUse.some(h =>
  h.hooks && h.hooks.some(hh => (hh.command || '').includes('tool-tips-post'))
);
if (!hasTips) {
  settings.hooks.PostToolUse.push({
    matcher: 'Bash|Read|Write|Edit|Glob|Grep|mcp__*',
    hooks: [{ type: 'command', command: '$HOOKS_DIR/tool-tips-post.sh' }]
  });
}

settings.statusLine = { type: 'command', command: 'node \"$MONITOR_DIR/statusline.js\"' };

fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + '\n', 'utf8');
console.log('  settings.json 已更新');
"

# 验证
echo ""
echo "${MAGENTA}════════════════════════════════════════════${NC}"
echo "${MAGENTA}     验证${NC}"
echo "${MAGENTA}════════════════════════════════════════════${NC}"
claude --version 2>&1
echo ""
echo "${GREEN}════════════════════════════════════════════${NC}"
echo "${GREEN}  汉化恢复完成！请重启 Claude Code 生效${NC}"
echo "${GREEN}════════════════════════════════════════════${NC}"
echo ""
echo "${YELLOW}  提示：${NC}"
echo "  - 升级 Claude Code 后，重新运行此脚本即可恢复汉化"
echo "  - 每次 Claude Code 启动也会自动检查并重新汉化"
echo "  - 运行方式: bash ~/Desktop/claude-汉化备份/恢复汉化.sh"
echo ""
