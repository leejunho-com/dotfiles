#!/bin/bash

sketchybar --add item power right \
           --set power icon.font="$ICON_FONT" \
                       update_freq=30 \
                       script="$PLUGIN_DIR/power.sh" \
           --subscribe power system_woke power_source_change
