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
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# editor
export EDITOR=nvim

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

# zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# tmux unicode
alias tmux='tmux -u'
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# eza
alias ls="eza --icons=always"

# fzf
source <(fzf --zsh)
source ~/.config/fzf/fzf-git.sh/fzf-git.sh

# fd
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1" }

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# bat
export BAT_THEME="Visual Studio Dark+"

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
# cut fanart.jpg to poster.jpg
alias poster='ffmpeg -i "fanart.jpg" -vf "crop=iw*0.4725:ih:iw*0.5275:0" -update 1 "poster.jpg"'
# poster.jpg from extrafanart 
alias eposter="cp ./extrafanart/fanart1.jpg ./poster.jpg"
# find dir no trailer
alias trailer='find . -maxdepth 1 -type d ! -exec sh -c '\''find "{}" -maxdepth 1 -type f -name "*-trailer*" | grep -q .'\'' \; -print'
