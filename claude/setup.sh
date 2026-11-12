#!/bin/zsh
source "${0:A:h:h}/lib.sh"

echo "🤖 Setting up Claude Code configuration..."
link "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
echo "✅ Claude Code configuration setup completed!"
