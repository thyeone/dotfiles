#!/bin/zsh
source "${0:A:h:h}/lib.sh"

echo "📦 Setting up Git configuration..."
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore"
echo "✅ Git configuration setup completed!"
