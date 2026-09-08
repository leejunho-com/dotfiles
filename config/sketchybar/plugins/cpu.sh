#!/bin/bash

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_PERCENT=$(ps -eo pcpu | awk -v cores="$CORE_COUNT" \
  'NR>1 {sum+=$1} END {printf "%.0f", sum/cores}')

sketchybar --set $NAME label="$CPU_PERCENT%"
