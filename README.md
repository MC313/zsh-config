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
   git clone <repository-url>
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
   - `.zshrc` file
   - `.zsh_aliases` file
   - Zsh plugins:
     - zsh-autosuggestions
     - fast-syntax-highlighting
     - zsh-completions

2. Starship prompt

3. Git configuration (if included in the dotfiles)

4. Any other dotfiles specified in the `install.conf.yaml` file

## Customization

You can customize the setup by modifying the `install.conf.yaml` file. This file specifies which dotfiles should be linked and where they should be linked to.

## Note

Make sure to review and adjust any personal information or paths in the dotfiles before using this setup on a new system.