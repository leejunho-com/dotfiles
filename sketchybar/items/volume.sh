#!/bin/bash

sketchybar --add item volume right \
           --set volume icon.font="$ICON_FONT" \
                        script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change
