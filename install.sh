#!/bin/bash

# symlink files
ln -sfn ~/.config/env/public/zsh/zshrc ~/.zshrc
ln -sfn ~/.config/env/public/zsh/p10k.zsh ~/.p10k.zsh

# tmux-plugin-manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
