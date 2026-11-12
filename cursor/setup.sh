#!/bin/zsh
# Export extensions: cursor --list-extensions > cursor/vscode-extensions.txt
source "${0:A:h:h}/lib.sh"

echo "📦 Setting up Cursor configuration..."
link "$DOTFILES_DIR/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
install_extensions cursor "$DOTFILES_DIR/cursor/vscode-extensions.txt"
echo "✅ Cursor configuration setup completed!"
