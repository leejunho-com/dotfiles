#!/bin/bash

sketchybar --add item cpu right \
           --set cpu update_freq=2 \
                     icon="$ICON_CPU" \
                     icon.font="$ICON_FONT" \
                     script="$PLUGIN_DIR/resources.sh"
