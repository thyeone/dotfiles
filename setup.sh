#!/bin/zsh

SCRIPT_DIR="${0:A:h}"
INSTALL_ALL=false
[[ "$1" == "--all" ]] && INSTALL_ALL=true

# Order matters: brew first (later steps need it), nvm needs brew's nvm.
steps=(
  "Homebrew & Packages:brew"
  "Node.js:nvm"
  "Ghostty Configuration:ghostty"
  "Git Configuration:git"
  "Zsh Configuration:zsh"
  "Cursor Configuration:cursor"
  "VSCode Configuration:vscode"
  "Claude Code Configuration:claude"
)

load_brew() {
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$b" ]] && eval "$("$b" shellenv)" && return
  done
}

echo "🚀 Starting setup..."
failed=()
i=0
for step in "${steps[@]}"; do
  name="${step%%:*}" dir="${step##*:}"
  (( i++ ))
  if [[ "$INSTALL_ALL" != true ]]; then
    echo ""
    read -q "?Install $name? (y/n): " || { echo; continue; }
    echo
  fi
  echo ""
  echo "========================================="
  echo "$i. $name"
  echo "========================================="
  load_brew  # brew may have just been installed by an earlier step
  zsh "$SCRIPT_DIR/$dir/setup.sh" "$INSTALL_ALL" || failed+=("$name")
done

echo ""
if (( ${#failed} )); then
  echo "❌ Failed: ${(j:, :)failed}"
  exit 1
fi
echo "✅ macOS setup completed!"
