#!/bin/sh
# claude-devteam のテンプレ一式をローカル環境へ配備する
# - claude/skills/* → ~/.claude/skills/  (Claude Codeの /pm /tech-lead /implementer /auditor)
# - codex/skills/*  → ~/.agents/skills/  (Codex監査の $auditor)
# テンプレを改訂したら、このスクリプトを再実行して反映する
set -eu

repo_dir=$(cd "$(dirname "$0")/.." && pwd)

mkdir -p "$HOME/.claude/skills"
for skill_dir in "$repo_dir"/claude/skills/*/; do
  name=$(basename "$skill_dir")
  rm -rf "$HOME/.claude/skills/$name"
  cp -R "$skill_dir" "$HOME/.claude/skills/$name"
done
echo "installed: $(ls -d "$repo_dir"/claude/skills/*/ | wc -l | tr -d ' ') claude skills -> ~/.claude/skills/"

mkdir -p "$HOME/.agents/skills"
rm -rf "$HOME/.agents/skills/auditor"
cp -R "$repo_dir/codex/skills/auditor" "$HOME/.agents/skills/auditor"
echo "installed: codex auditor skill -> ~/.agents/skills/auditor/"

echo "done"
