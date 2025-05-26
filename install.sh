#!/bin/bash

# symlink files
ln -sf ~/.config/env-pub/zsh/zshrc ~/.zshrc
ln -sf ~/.config/env-pub/zsh/p10k.zsh ~/.p10k.zsh

# tmux-plugin-manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
