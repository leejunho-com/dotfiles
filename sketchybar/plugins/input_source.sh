#!/bin/bash

SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null)
if [[ "$SOURCE" == *"com.apple.inputmethod.Korean"* ]]; then
  sketchybar --set inputsource drawing=off \
             --bar color=0xE6f37021
else
  sketchybar --set inputsource drawing=off \
             --bar color=0x00000000
fi
