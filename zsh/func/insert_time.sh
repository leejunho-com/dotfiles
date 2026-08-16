# filename-safe timestamp at the cursor, leading dash so it appends to a name
function _insert_time() {
  LBUFFER+="-$(date +%Y-%m-%d_%H%M%S)"
  zle redisplay
}
zle -N _insert_time
bindkey "^[t" _insert_time
