#!/bin/zsh
# Export extensions: code --list-extensions > vscode/vscode-extensions.txt
source "${0:A:h:h}/lib.sh"

echo "📦 Setting up VSCode configuration..."
link "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
install_extensions code "$DOTFILES_DIR/vscode/vscode-extensions.txt"
echo "✅ VSCode configuration setup completed!"
