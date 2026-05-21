#!/bin/bash

sketchybar --add item media e \
           --set media label.max_chars=20 \
                       scroll_texts=on \
                       icon=􀑪 \
                       script="$PLUGIN_DIR/media.sh" \
           --subscribe media media_change
