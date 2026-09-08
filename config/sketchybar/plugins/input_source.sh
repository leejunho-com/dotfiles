#!/bin/bash

source "$CONFIG_DIR/theme.sh"

SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null)

if [[ "$SOURCE" == *"com.apple.inputmethod.Korean"* ]]; then
  sketchybar --set inputsource label="ko" label.color=$WHITE background.color=$SELECT \
             --set front_app  background.color=$SELECT \
             --set sysinfo    background.color=$SELECT \
             --set clock      background.color=$SELECT \
             --set volume     background.color=$SELECT \
             #--bar color=$BAR_KO_COLOR
else
  sketchybar --set inputsource label="en" label.color=$WHITE background.color=$NONE background.border_width=0 \
             --set front_app  background.color=$ITEM_BG_COLOR \
             --set sysinfo    background.color=$ITEM_BG_COLOR \
             --set clock      background.color=$ITEM_BG_COLOR \
             --set volume     background.color=$ITEM_BG_COLOR \
             #--bar color=0x00000000
fi
