#!/bin/zsh
source "${0:A:h:h}/lib.sh"

echo "👻 Setting up Ghostty configuration..."
link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
echo "✅ Ghostty configuration setup completed!"
