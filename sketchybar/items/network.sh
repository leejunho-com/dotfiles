#!/bin/bash

sketchybar --add item network e \
           --set network update_freq=2 \
                     icon="$ICON_NETWORK" \
                     icon.font="$ICON_FONT" \
                     background.padding_left=6 \
                     script="$PLUGIN_DIR/network.sh"
