#!/bin/bash

sketchybar --add item memory e \
           --set memory update_freq=5 \
                        icon="$ICON_MEMORY" \
                        icon.font="$ICON_FONT" \
                        script="$PLUGIN_DIR/memory.sh"
