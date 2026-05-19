#!/bin/bash

SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null)
if [[ "$SOURCE" == *"com.apple.inputmethod.Korean"* ]]; then
  sketchybar --set inputsource label="ko" background.color=0xfff37021
else
  sketchybar --set inputsource label="en" background.color=0x3f000000
fi