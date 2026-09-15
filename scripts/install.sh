#!/bin/sh
# claude-devteamのSkill、安全ガード、Codex監査用profileを配備する
set -eu

repo_dir=$(cd "$(dirname "$0")/.." && pwd)

python3 -B -m unittest discover -s "$repo_dir/tests" >/dev/null
echo "verified: document workflow regression tests"

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

runtime_dir="$HOME/.ai-devteam/bin"
mkdir -p "$runtime_dir"
python3 -B "$repo_dir/scripts/remove_legacy_role_hooks.py" \
  "$HOME/.codex/hooks.json" \
  "$HOME/.claude/settings.json"
cp "$repo_dir/scripts/retired_flowctl_compat.py" "$runtime_dir/flowctl"
rm -f "$runtime_dir/flowctl_lib.py" "$runtime_dir/validate_handoff.py"
chmod 755 "$runtime_dir/flowctl"
echo "removed: retired workflow hooks and engine"
echo "installed: pass-through compatibility bridge for already-open sessions -> ~/.ai-devteam/bin/flowctl"

mkdir -p "$HOME/.codex"
for profile in "$repo_dir"/codex/profiles/*.config.toml; do
  cp "$profile" "$HOME/.codex/$(basename "$profile")"
done
echo "installed: codex least-privilege profiles -> ~/.codex/"

if [ -f "$HOME/.codex/prompts/auditor.md" ]; then
  rm "$HOME/.codex/prompts/auditor.md"
  echo "removed legacy: ~/.codex/prompts/auditor.md"
fi

echo "note: ai-devteam is opt-in; roleless sessions stay normal until an explicit Skill is invoked"
echo "note: existing projects are not rewritten; copy $repo_dir/CLAUDE.md to each Claude project and the matching AGENTS.md to each Codex project when common rules change"
echo "note: new role Skills explicitly reread the matching project rule; existing sessions need one reread and do not need a restart"
echo "note: Codex permission profiles are optional hardening; legacy sandbox_mode in ~/.codex/config.toml takes precedence and disables them"
echo "done"
