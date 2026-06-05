# discord webhook
# usage:
#   discord "msg"     plain text, no footer
#   discord -m "msg"  plain text + footer
#   discord -c "code" code block + footer
#   discord -c -      code block from stdin (ls | discord -c -)
#   discord -j        job notification, title auto-detected from preceding command

# capture short hostname once at load time
_discord_host=${HOST%%.*}
_discord_last_cmd=""

# track the last command via preexec hook for -j and stdin title
autoload -Uz add-zsh-hook
add-zsh-hook preexec _discord_preexec
_discord_preexec() { _discord_last_cmd="$1" }

discord() {
  local OPTIND=1 opt mode="plain" content=""

  # parse options
  while getopts ":m:c:j" opt; do
    case $opt in
      m) mode="msg";  content="$OPTARG" ;;
      c) mode="code"; content="$OPTARG" ;;
      j) mode="job" ;;
    esac
  done
  shift $((OPTIND-1))

  # auto-detect pipe: bare `discord` or `discord -c -` with stdin
  local _stdin=0
  if [[ "$mode" == "plain" && -z "$content" && ! -t 0 ]]; then
    mode="code"; content=$(cat); _stdin=1
  else
    [[ "$mode" == "plain" && -z "$content" ]] && content="$*"
    [[ "$content" == "-" ]] && { content=$(cat); _stdin=1; }
  fi

  # build shared footer
  local host=$_discord_host session="" dir payload body footer
  [[ -n "$TMUX" ]] && session=" (tmux: $(tmux display-message -p '#S'))"
  dir=$(pwd)
  printf -v footer $'> 📍 %s%s\n> 📂 %s\n> 🕒 %s\n' \
    "$host" "$session" "$dir" "$(date '+%Y-%m-%d %H:%M:%S')"

  case "$mode" in
    # plain: no footer, just the message
    plain)
      body="$content"
      ;;
    # msg: message with footer
    msg)
      printf -v body $'%s\n%s' "$content" "$footer"
      ;;
    # code: fenced code block; stdin adds pwd + command as heading
    code)
      local title=""
      [[ $_stdin == 1 ]] && title=$(echo "$_discord_last_cmd" | sed 's/ *[|&]\+[[:space:]]*discord.*//; s/^[[:space:]]*//')
      if [[ -n "$title" ]]; then
        printf -v body $'# %s\n# ❯  %s\n```\n%s\n```\n%s' \
          "$dir" "$title" "$content" "$footer"
      else
        printf -v body $'```\n%s\n```\n%s' "$content" "$footer"
      fi
      ;;
    # job: fire-and-forget notification with preceding command as title
    job)
      local title
      title=$(echo "$_discord_last_cmd" | sed 's/ *[|&]\+[[:space:]]*discord.*//; s/^[[:space:]]*//')
      printf -v body $'# %s\n⚡️Job Finished\n%s' "$title" "$footer"
      ;;
  esac

  payload=$(jq -n --arg c "$body" '{content: $c}')

  printf '%s' "$payload" | \
    curl -s -H "Content-Type: application/json" -X POST -d @- "$DISCORD_WEBHOOK" > /dev/null
}
