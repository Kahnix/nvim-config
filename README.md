# Neovim configuration

My personal Neovim configuration for Go, TypeScript, React, React Native, Nix, and Lua development.

## Install

Back up any existing Neovim configuration, then clone this repository:

```sh
git clone https://github.com/Kahnix/nvim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Plugins and external editor tools are installed automatically on the first launch. Language tools supplied by Nix, including `nixd` and `nixfmt`, should be available in the shell that launches Neovim.
