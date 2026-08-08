#!/bin/bash

source "$CONFIG_DIR/theme.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME=$INFO
else
  VOLUME=$(osascript -e "output volume of (get volume settings)" 2>/dev/null)
fi

if [ -z "$VOLUME" ] || [ "$VOLUME" = "missing value" ]; then
  # icon only: empty label still reserves its padding, so balance both sides
  sketchybar --set $NAME icon="$ICON_VOL_EXTERNAL" label="" \
                         label.padding_right=0 \
                         icon.padding_right=9 \
                         background.padding_right=4
  exit 0
fi

case $VOLUME in
  [6-9][0-9]|100) ICON="$ICON_VOL_HIGH"  ;;
  [3-5][0-9])     ICON="$ICON_VOL_MID"   ;;
  [1-9]|[1-2][0-9]) ICON="$ICON_VOL_LOW" ;;
  *)               ICON="$ICON_VOL_MUTE"  ;;
esac

# restore the defaults in case the previous state was icon-only
sketchybar --set $NAME icon="$ICON" label="$VOLUME%" \
                       label.padding_right=10 \
                       icon.padding_right=2 \
                       background.padding_right=4
