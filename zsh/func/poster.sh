# cut fanart.jpg to poster.jpg
# usage:
#   poster                     right edge (default)
#   poster l|lm|m|rm|r         5-step preset positions
#   poster <ratio>             custom x ratio (0.0 ~ 0.5275)
#   poster -a|--append <pos>   append position to filename (poster-<pos>.jpg)
poster() {
  local append=0
  if [[ "$1" == "-a" || "$1" == "--append" ]]; then
    append=1
    shift
  fi

  local pos="${1:-r}"
  local x
  case "$pos" in
    l)      x=0 ;;
    lm)     x=0.1318 ;;
    m)      x=0.2638 ;;
    rm)     x=0.3956 ;;
    r|"")   x=0.5275 ;;
    *)      x="$pos" ;;
  esac

  local output="poster.jpg"
  (( append )) && output="poster-$pos.jpg"

  ffmpeg -i "fanart.jpg" -vf "crop=iw*0.4725:ih:iw*$x:0" -update 1 "$output"
}
