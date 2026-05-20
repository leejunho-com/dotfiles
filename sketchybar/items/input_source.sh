#!/bin/bash

sketchybar --add item inputsource left \
           --set inputsource \
               script="$PLUGIN_DIR/input_source.sh" \
               icon.drawing=off \
               label.drawing=on \
               label.color=0xffffffff \
               label.padding_left=10 \
               label.padding_right=10 \
           --add event input_source_changed \
               "com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged" \
           --subscribe inputsource input_source_changed
