#!/bin/bash

sketchybar --add item cpu e \
           --set cpu update_freq=2 \
                     icon="$ICON_CPU" \
                     icon.font="$ICON_FONT" \
                     background.padding_left=6 \
                     label.width=40 \
                     script="$PLUGIN_DIR/cpu.sh"
