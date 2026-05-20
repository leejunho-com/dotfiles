#!/bin/bash

source "$CONFIG_DIR/theme.sh"

IOREG=$(ioreg -rn AppleSmartBattery)

BATTERY_INSTALLED=$(echo "$IOREG" | grep '"BatteryInstalled"' | grep -o 'Yes\|No')
PERCENTAGE=$(echo "$IOREG" | grep '"CurrentCapacity"' | grep -o '[0-9]*')
IS_CHARGING=$(echo "$IOREG" | grep '"IsCharging"' | grep -o 'Yes\|No')
WATTS=$(echo "$IOREG" | grep -o '"SystemPowerIn"=[0-9]*' | grep -o '[0-9]*')
WATTS_W=$(awk "BEGIN {printf \"%.1f\", $WATTS/1000}")

if [ "$BATTERY_INSTALLED" = "No" ]; then
  sketchybar --set $NAME icon="$ICON_BAT_AC" label="${WATTS_W}W" label.drawing=on
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON="$ICON_BAT_FULL"    ;;
  [6-8][0-9]) ICON="$ICON_BAT_HIGH"    ;;
  [3-5][0-9]) ICON="$ICON_BAT_MID"     ;;
  [1-2][0-9]) ICON="$ICON_BAT_LOW"     ;;
  *)          ICON="$ICON_BAT_CRITICAL" ;;
esac

if [ "$IS_CHARGING" = "Yes" ]; then
  ICON="$ICON_BAT_CHARGING"
fi

sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%" label.drawing=on
