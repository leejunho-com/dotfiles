#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set front_app icon.background.image="app.$INFO" \
                             label="$INFO"
fi
