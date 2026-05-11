#!/bin/bash

# env/private
git clone https://github.com/leejunho-com/private.git ~/.config/env/private

# symlink files (managed by home-manager — only needed before first nix-darwin switch)
ln -sfn ~/code/dotfiles/zsh/zshrc ~/.zshrc
ln -sfn ~/code/dotfiles/zsh/p10k.zsh ~/.p10k.zsh
ln -sfn ~/code/dotfiles/vim/vimrc ~/.vimrc

# tmux-plugin-manager
rm -r ~/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
