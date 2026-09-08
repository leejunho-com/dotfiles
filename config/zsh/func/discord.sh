# discord webhook
# requires: $DISCORD_WEBHOOK env var — set your webhook URL before sourcing this file
# usage:
#   discord "msg"     plain text, no footer
#   discord -m "msg"  plain text + footer
#   discord -c "code" code block + footer
#   discord -j "note" job notification headed by the preceding command
#   ls | discord      stdin becomes the body and the argument becomes a note

# capture short hostname once at load time
_discord_host=${HOST%%.*}
_discord_last_cmd=""

# track the last command via preexec hook for -j and stdin title
autoload -Uz add-zsh-hook
add-zsh-hook preexec _discord_preexec

# ignore trailing discord calls so the title stays the real command
_discord_preexec() {
  emulate -L zsh
  setopt extendedglob
  local c=$1
  c=${c%%[[:space:]]#[;|&]##[[:space:]]#discord([[:space:]]*|)}
  c=${c##[[:space:]]#}
  c=${c%%[[:space:]]#}
  [[ -n $c && $c != discord([[:space:]]*|) ]] && _discord_last_cmd=$c
}

_discord_usage() {
  print -u2 'usage: discord [msg | -m msg | -c code | -j job], or pipe into discord'
}

discord() {
  local OPTIND=1 opt arg mode="plain" content

  # parse options; the message is the remaining argument, if any
  while getopts ":mcj" opt; do
    case $opt in
      m) mode="msg" ;;
      c) mode="code" ;;
      j) mode="job" ;;
      '?') _discord_usage; return 1 ;;
    esac
  done
  shift $((OPTIND-1))

  # flags only count before the message, so catch the reversed order
  for arg in "$@"; do
    [[ "$arg" == -[mcj] ]] && { _discord_usage; return 1 }
  done
  content="$*"

  # piped input becomes the body and demotes the argument to a note;
  # an empty pipe is ignored so scripts can still pass a message
  local note="" piped _stdin=0
  if [[ ! -t 0 ]]; then
    piped=$(cat)
    if [[ -n "$piped" ]]; then
      note="$content"; content="$piped"; _stdin=1
    fi
  fi

  # job carries no body: the argument is the note and piped input is dropped
  if [[ "$mode" == "job" ]]; then
    [[ $_stdin == 0 ]] && note="$content"
    content=""
  fi

  # nothing to send
  if [[ "$mode" != "job" && -z "$content" ]]; then
    _discord_usage
    return 1
  fi

  # build the shared footer and note, both sitting under the body
  local host=$_discord_host session="" dir payload body footer noteline=""
  [[ -n "$TMUX" ]] && session=" (tmux: $(tmux display-message -p '#S'))"
  dir=$(pwd)
  printf -v footer $'> 📍 %s%s\n> 📂 %s\n> 🕒 %s\n' \
    "$host" "$session" "$dir" "$(date '+%Y-%m-%d %H:%M:%S')"
  [[ -n "$note" ]] && noteline=$'💬 '$note$'\n'

  case "$mode" in
    # plain: no footer, just the message
    plain)
      body="$content"
      [[ -n "$noteline" ]] && body+=$'\n'$noteline
      ;;
    # msg: message with footer
    msg)
      printf -v body $'%s\n%s%s' "$content" "$noteline" "$footer"
      ;;
    # code: fenced code block; stdin adds the command as heading
    code)
      local title=""
      [[ $_stdin == 1 ]] && title=$_discord_last_cmd
      if [[ -n "$title" ]]; then
        printf -v body $'# ❯  %s\n```\n%s\n```\n%s%s' \
          "$title" "$content" "$noteline" "$footer"
      else
        printf -v body $'```\n%s\n```\n%s%s' "$content" "$noteline" "$footer"
      fi
      ;;
    # job: notification only, headed by the preceding command
    job)
      local head=""
      [[ -n "$_discord_last_cmd" ]] && head=$'# ❯  '$_discord_last_cmd$'\n'
      printf -v body $'%s%s⚡️Job Finished\n%s' "$head" "$noteline" "$footer"
      ;;
  esac

  payload=$(jq -n --arg c "$body" '{content: $c}')

  if ! printf '%s' "$payload" | \
    curl -sf -H "Content-Type: application/json" -X POST -d @- "$DISCORD_WEBHOOK" > /dev/null; then
    print -u2 'discord: post failed'
    return 1
  fi
}
