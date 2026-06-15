function _insert_time() {
  LBUFFER+=$(date "+#   %y-%m-%d %a %H:%M:%S %Z")
  zle redisplay
}
zle -N _insert_time
bindkey "^[t" _insert_time
