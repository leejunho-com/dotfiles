#!/bin/bash

sketchybar --add item clock right \
           --set clock icon="$ICON_CALENDAR" \
                       icon.font="$ICON_FONT" \
                       update_freq=30 \
                       script="$PLUGIN_DIR/clock.sh"
