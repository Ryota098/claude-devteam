#!/bin/sh
# claude-devteam のテンプレ一式をローカル環境へ配備する
# - claude/skills/* → ~/.claude/skills/  (Claude Codeの /pm /tl /implementer /auditor)
# - codex/skills/*  → ~/.agents/skills/  (Codex監査の $auditor)
# テンプレを改訂したら、このスクリプトを再実行して反映する
set -eu

repo_dir=$(cd "$(dirname "$0")/.." && pwd)

mkdir -p "$HOME/.claude/skills"
if [ -d "$HOME/.claude/skills/tech-lead" ]; then
  rm -rf "$HOME/.claude/skills/tech-lead"
  echo "removed legacy skill: ~/.claude/skills/tech-lead/"
fi
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

echo "note: existing projects are not rewritten; replace each project's CLAUDE.md with $repo_dir/CLAUDE.md when common rules change"
echo "done"
