#!/bin/bash

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_PERCENT=$(ps -eo pcpu | awk -v cores="$CORE_COUNT" \
  'NR>1 {sum+=$1} END {printf "%.0f", sum/cores}')

PAGE_SIZE=$(pagesize)
MEM_LABEL=$(vm_stat | awk -v page="$PAGE_SIZE" '
  /Pages active/                 {gsub(/\./, "", $3); active=$3}
  /Pages wired down/             {gsub(/\./, "", $4); wired=$4}
  /Pages free/                   {gsub(/\./, "", $3); free=$3}
  /Pages speculative/            {gsub(/\./, "", $3); spec=$3}
  /File-backed pages/            {gsub(/\./, "", $3); filebacked=$3}
  END {
    used = (active + wired) * page / 1073741824
    free_gb = (free + spec) * page / 1073741824
    cache_gb = filebacked * page / 1073741824
    printf "%.1fG / %.1fG cache / %.1fG free", used, cache_gb, free_gb
  }
')

sketchybar --set $NAME label="$CPU_PERCENT%" \
           --set memory label="$MEM_LABEL"
