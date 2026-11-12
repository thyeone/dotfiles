# dotfiles

A personal collection of dotfiles and setup scripts for macOS development environment.

## Overview

This repository contains configuration files and automated setup scripts to quickly configure a new macOS machine with essential development tools and settings.

## Features

- 🍺 **Homebrew**: Package manager installation and package management
- 📦 **Node.js**: Automatic LTS version installation via nvm
- 👻 **Ghostty**: Terminal configuration
- 🔧 **Git**: Global Git configuration and ignore patterns
- 🐚 **Zsh**: Oh My Zsh install and shell configuration
- ✏️ **Cursor / VSCode**: Editor settings and extension management
- 🤖 **Claude Code**: Status line script

## Quick Start

```bash
git clone https://github.com/thyeone/macos-setup.git
cd macos-setup

./setup.sh
```

### Installation Modes

**Interactive Mode (Default)**

- The script will prompt you for each configuration step
- Choose which components to install (y/n)
- Allows selective installation of only the components you need

**Automatic Mode**

- Install all components without prompts
- Use the `--all` flag:

```bash
./setup.sh --all
```

### Available Components

1. **Homebrew & Packages** - Installs Homebrew and packages from `brew/Brewfile`
2. **Node.js** - Installs Node.js LTS via nvm
3. **Ghostty Configuration** - Links `~/.config/ghostty/config`
4. **Git Configuration** - Links `~/.gitconfig` and `~/.gitignore`
5. **Zsh Configuration** - Installs Oh My Zsh and links `~/.zshrc`
6. **Cursor Configuration** - Links settings and installs extensions
7. **VSCode Configuration** - Links settings and installs extensions
8. **Claude Code Configuration** - Links `~/.claude/statusline-command.sh`

Existing files are backed up as `<file>.backup.<timestamp>` before linking. Re-running is safe.
