# Dotfiles Management with Dotbot

This project is a dotfiles management system using Dotbot. It sets up various configurations for Zsh, including plugins and aliases, and installs Starship prompt.

## Purpose

The main purpose of this project is to:
1. Manage dotfiles across different systems
2. Automate the setup of a new development environment
3. Maintain consistent Zsh configurations with plugins

## How to Run This Project

1. Clone the repository:
   ```
   git clone https://github.com/MC313/zsh-config.git
   cd zsh-config
   ```

2. Run the install script:
   ```
   ./install
   ```

   This script will:
   - Execute Dotbot to symlink configuration files
   - Install Zsh if not already installed
   - Set Zsh as the default shell
   - Install Starship prompt

## Updating Zsh Plugins

The Zsh plugins are managed as git submodules. To update them:

1. Update all submodules:
   ```
   git submodule update --remote --merge
   ```

2. Commit the changes:
   ```
   git add .
   git commit -m "Update Zsh plugins"
   ```

## What Gets Set Up

When you run the install script, the following will be set up:

1. Zsh configuration:
   - `.zshenv` - Environment variables and PATH configuration
   - `.zshrc` - Interactive shell settings
   - `.zprofile` - Login shell configuration
   - `.zsh_aliases` - Command aliases
   - Zsh plugins:
     - zsh-nvm (with lazy loading)
     - zsh-autosuggestions
     - fast-syntax-highlighting
     - zsh-completions

2. PATH configuration:
   - `~/.opencode/bin`
   - `~/.local/bin`
   - `~/Library/pnpm` (macOS) for pnpm global executables
   - `~/.local/share/pnpm/bin` (Linux) for pnpm global executables
   - `/usr/local/go/bin` and `~/go/bin` for Go
   - Node version management via nvm

3. pnpm configuration:
   - Sets home directory to `~/Library/pnpm` (macOS) or `~/.local/share/pnpm` (Linux)
   - Configures global bin directory
   - Fixes permissions if needed

4. Starship prompt

5. Git configuration (sensible defaults + preferences + aliases)

6. Any other dotfiles specified in the `install.conf.yaml` file

## Platform-specific settings

Shared Zsh settings live in `zsh/.zshrc` and `zsh/.zshenv`. Platform-specific
setup is selected using Zsh's `OSTYPE` value:

- macOS loads Homebrew and OrbStack setup from `.zprofile` and uses
  `~/Library/pnpm` for pnpm.
- Linux keeps pnpm global executables in `~/.local/share/pnpm/bin` and enables
  the pnpm Node-version helper. It does not run the macOS Homebrew or OrbStack
  setup.
- Both platforms use the shared nvm configuration and common shell plugins.

## Customization

You can customize the setup by modifying the `install.conf.yaml` file. This file specifies which dotfiles should be linked and where they should be linked to.

## Troubleshooting

### pnpm global bin directory not in PATH

If you see: `ERROR The configured global bin directory "/Users/username/Library/pnpm" is not in PATH`

**Solution:**
1. Reload your shell environment:
   ```bash
   source ~/.zshenv
   ```

2. Verify pnpm is in PATH:
   ```bash
   echo $PATH | grep pnpm
   ```

3. If still not working, run the install script again to reconfigure pnpm:
   ```bash
   ./install
   ```

### pnpm requires sudo for global installs

If you need `sudo` to install packages globally, it means pnpm files are owned by root.

**Solution:** Fix ownership of pnpm directory (one-time fix):
```bash
sudo chown -R "$(whoami):$(id -gn)" ~/Library/pnpm
```

After this, global installs will work without sudo:
```bash
pnpm add -g <package>  # No sudo needed
```
## Note

Make sure to review and adjust any personal information or paths in the dotfiles before using this setup on a new system.
