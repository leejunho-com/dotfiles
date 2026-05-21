#!/bin/bash

sketchybar --add item front_app q \
           --set front_app icon.background.drawing=on \
                           background.x_offset=4 \
                           background.padding_right=10 \
                           label.padding_right=5 \
                           script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
