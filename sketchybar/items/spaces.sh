#!/bin/bash

SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)

for sid in "${SPACE_SIDS[@]}"
do
  sketchybar --add space space.$sid left                                 \
             --set space.$sid space=$sid                                 \
                              icon=$sid                                  \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.padding_left=-5                     \
                              label.padding_right=16                     \
                              label.y_offset=-1                          \
                              script="$PLUGIN_DIR/space.sh"
done

sketchybar --add item space_separator left                             \
           --set space_separator drawing=off                           \
                                 script="$PLUGIN_DIR/space_windows.sh" \
           --subscribe space_separator space_windows_change
