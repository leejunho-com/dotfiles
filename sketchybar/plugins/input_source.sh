#!/bin/bash

source "$CONFIG_DIR/theme.sh"

SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null)

if [[ "$SOURCE" == *"com.apple.inputmethod.Korean"* ]]; then
  sketchybar --set inputsource label="ko" background.color=$SELECT \
             --set front_app  background.color=$SELECT \
             --set cpu        background.color=$SELECT \
             --set memory     background.color=$SELECT \
             --set power      background.color=$SELECT \
             --set clock      background.color=$SELECT \
             --set volume     background.color=$SELECT \
             #--bar color=$BAR_KO_COLOR
else
  sketchybar --set inputsource label="en" background.color=$NONE \
             --set front_app  background.color=$ITEM_BG_COLOR \
             --set cpu        background.color=$ITEM_BG_COLOR \
             --set memory     background.color=$ITEM_BG_COLOR \
             --set power      background.color=$ITEM_BG_COLOR \
             --set clock      background.color=$ITEM_BG_COLOR \
             --set volume     background.color=$ITEM_BG_COLOR \
             #--bar color=0x00000000
fi
