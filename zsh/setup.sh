#!/bin/zsh
source "${0:A:h:h}/lib.sh"

echo "📦 Setting up zsh configuration..."

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "📦 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
echo "✅ zsh configuration setup completed!"
