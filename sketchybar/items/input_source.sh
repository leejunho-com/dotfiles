#!/bin/bash

sketchybar --add item inputsource left \
           --set inputsource \
               script="$PLUGIN_DIR/input_source.sh" \
               icon="$ICON_INPUT" \
               icon.font="$ICON_FONT" \
               label.drawing=on \
               label.padding_right=10 \
           --add event input_source_changed \
               "com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged" \
           --subscribe inputsource input_source_changed
