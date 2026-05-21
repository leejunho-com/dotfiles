#!/bin/bash

CONFIG=$(readlink -f "$HOME/.config/ghostty/config")
CURRENT=$(awk -F'= ' '/^background-opacity/{print $2}' "$CONFIG")

if [ "$CURRENT" = "0.5" ]; then
  sed -i 's/^background-opacity = .*/background-opacity = 0.8/' "$CONFIG"
else
  sed -i 's/^background-opacity = .*/background-opacity = 0.5/' "$CONFIG"
fi

kill -SIGUSR2 $(pgrep -x ghostty) 2>/dev/null
