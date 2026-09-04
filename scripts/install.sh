#!/bin/sh
# claude-devteamのSkill、flowctl、hooks、Codex監査用profileを配備する。
set -eu

repo_dir=$(cd "$(dirname "$0")/.." && pwd)

python3 -B -m unittest discover -s "$repo_dir/tests" >/dev/null
python3 -B "$repo_dir/claude/skills/pm/scripts/validate_handoff.py" --self-test >/dev/null
echo "verified: flowctl regression tests and handoff validator"

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
cp "$repo_dir/scripts/flowctl.py" "$runtime_dir/flowctl"
cp "$repo_dir/scripts/flowctl_lib.py" "$runtime_dir/flowctl_lib.py"
cp "$repo_dir/claude/skills/pm/scripts/validate_handoff.py" "$runtime_dir/validate_handoff.py"
chmod 755 "$runtime_dir/flowctl" "$runtime_dir/flowctl_lib.py" "$runtime_dir/validate_handoff.py"
echo "installed: flowctl runtime -> ~/.ai-devteam/bin/"

mkdir -p "$HOME/.codex"
for profile in "$repo_dir"/codex/profiles/*.config.toml; do
  cp "$profile" "$HOME/.codex/$(basename "$profile")"
done
echo "installed: codex least-privilege profiles -> ~/.codex/"

python3 -B "$runtime_dir/flowctl" install-hooks --provider codex --executable "$runtime_dir/flowctl"
python3 -B "$runtime_dir/flowctl" install-hooks --provider claude --executable "$runtime_dir/flowctl"

if [ -f "$HOME/.codex/prompts/auditor.md" ]; then
  rm "$HOME/.codex/prompts/auditor.md"
  echo "removed legacy: ~/.codex/prompts/auditor.md"
fi

echo "note: restart Codex/Claude sessions to load the installed lifecycle hooks"
echo "note: ai-devteam is opt-in; roleless sessions stay normal until an explicit Skill runs flowctl role-start"
echo "note: existing projects are not rewritten; replace each project's CLAUDE.md with $repo_dir/CLAUDE.md when common rules change"
echo "note: run ~/.ai-devteam/bin/flowctl diagnose --project-root <project> after replacing CLAUDE.md"
echo "note: if diagnose finds legacy Claude Git permissions, the owner can run flowctl remove-legacy-claude-guards with --owner-confirmed"
echo "note: Codex permission profiles are optional hardening; legacy sandbox_mode in ~/.codex/config.toml takes precedence and disables them"
echo "done"
