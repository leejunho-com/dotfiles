#!/bin/bash

sketchybar --add item volume right \
           --set volume icon.font="$ICON_FONT" \
                        update_freq=60 \
                        script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change
