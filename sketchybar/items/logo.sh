#!/bin/bash

sketchybar --add item logo left \
           --set logo icon="" \
                      icon.font="$ICON_FONT" \
                      label.drawing=off \
                      icon.padding_left=20 \
                      background.drawing=off \
                      background.padding_left=-20 \
                      background.y_offset=10 \
                      background.height=40
