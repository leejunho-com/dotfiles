# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

plugins=(git)

# ======================= ENV =======================

# Ctrl + d disale
setopt ignoreeof

# p10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# thefuck
eval $(thefuck --alias)

# Zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# tmux unicode
alias tmux='tmux -u'
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Eza (better ls)
alias ls="eza --icons=always"

# fzf
source <(fzf --zsh)

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# pyenv setting
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd "$cwd"
	fi
	rm -f -- "$tmp"
}	

# === Custom ===
# nvim
alias vi="nvim"
# check dotfile inode
alias dotconfig-check="ls -lia ~/.config/.zshrc ~/.zshrc && ls -lia ~/.config/.p10k.zsh ~/.p10k.zsh"
# sync ~/dotfile
alias dotconfig-sync="ln -f ~/.config/.zshrc ~/.zshrc && ln -f ~/.config/.p10k.zsh ~/.p10k.zsh"
# cut fanart.jpg to poster.jpg
ffmpeg -i fanart.jpg -vf crop=iw*0.4725:ih:iw*0.5275:0 -update 1 poster.jpg

# (temp)incoming
# alias ic='cd ~/git/incoming && python3 -m incoming.main'
