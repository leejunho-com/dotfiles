# discord webhook
# usage:
#   discord "msg"     plain text, no footer
#   discord -m "msg"  plain text + footer
#   discord -c "code" code block + footer
#   discord -j        job notification, title auto-detected from preceding command

_discord_host=${HOSTNAME%%.*}
_discord_last_cmd=""

autoload -Uz add-zsh-hook
add-zsh-hook preexec _discord_preexec
_discord_preexec() { _discord_last_cmd="$1" }

discord() {
  local OPTIND=1 opt mode="plain" content=""

  while getopts ":m:c:j" opt; do
    case $opt in
      m) mode="msg"; content="$OPTARG" ;;
      c) mode="code"; content="$OPTARG" ;;
      j) mode="job" ;;
    esac
  done
  shift $((OPTIND-1))
  [[ "$mode" == "plain" && -z "$content" ]] && content="$*"
  [[ -z "$content" && ! -t 0 ]] && content=$(cat)

  local host=$_discord_host session="" payload
  [[ -n "$TMUX" ]] && session=" (tmux: $(tmux display-message -p '#S'))"

  case "$mode" in
    plain)
      payload=$(jq -n --arg c "$content" '{content: $c}')
      ;;
    msg)
      local body
      printf -v body $'%s\n> 📍 %s%s\n> 🕒 %s\n' \
        "$content" "$host" "$session" "$(date '+%Y-%m-%d %H:%M:%S')"
      payload=$(jq -n --arg c "$body" '{content: $c}')
      ;;
    code)
      local body
      printf -v body $'```\n%s\n```\n📋 From %s\n> 📍 %s%s\n> 🕒 %s\n' \
        "$content" "$host" "$host" "$session" "$(date '+%Y-%m-%d %H:%M:%S')"
      payload=$(jq -n --arg c "$body" '{content: $c}')
      ;;
    job)
      local title
      title=$(echo "$_discord_last_cmd" | sed 's/ *[|&][|&][[:space:]]*discord.*//; s/^[[:space:]]*//')
      local body
      printf -v body "# %s\n⚡️Job Finished\n> 📍 %s%s\n> 🕒 %s\n" \
        "$title" "$host" "$session" "$(date '+%Y-%m-%d %H:%M:%S')"
      payload=$(jq -n --arg c "$body" '{content: $c}')
      ;;
  esac

  printf '%s' "$payload" | \
    curl -s -H "Content-Type: application/json" -X POST -d @- "$DISCORD_WEBHOOK" > /dev/null
}
