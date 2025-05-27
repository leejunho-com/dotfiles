#!/bin/bash

# env/private
git clone https://github.com/leejunho-com/private.git ~/.config/env/private

# symlink files
ln -sfn ~/.config/env/public/zsh/zshrc ~/.zshrc
ln -sfn ~/.config/env/public/zsh/p10k.zsh ~/.p10k.zsh
ln -sfn ~/.config/env/public/vim/vimrc ~/.vimrc

# tmux-plugin-manager
rm -r ~/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
