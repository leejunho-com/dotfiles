#!/bin/bash

sketchybar --add item front_app left \
           --set front_app background.color=$AERO_0 \
                           icon.background.drawing=on \
                           label.font="$FONT" \
                           label.color=$WHITE \
                           script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
