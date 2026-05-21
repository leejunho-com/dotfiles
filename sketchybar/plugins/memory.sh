#!/bin/bash

PAGE_SIZE=$(pagesize)
TOTAL_BYTES=$(sysctl -n hw.memsize)
MEM_LABEL=$(vm_stat | awk -v page="$PAGE_SIZE" -v total="$TOTAL_BYTES" '
  /Pages active/                  {gsub(/\./, "", $3); active=$3}
  /Pages wired down/              {gsub(/\./, "", $4); wired=$4}
  /Pages free/                    {gsub(/\./, "", $3); free=$3}
  /Pages speculative/             {gsub(/\./, "", $3); spec=$3}
  /Pages purgeable/               {gsub(/\./, "", $3); purgeable=$3}
  /File-backed pages/             {gsub(/\./, "", $3); filebacked=$3}
  END {
    used     = (active + wired) * page / 1073741824
    avail_gb = (total - (active + wired) * page) / 1073741824
    cache_gb = filebacked * page / 1073741824
    free_gb  = (free + spec) * page / 1073741824
    printf "u%.1f a%.1f c%.1f f%.1f", used, avail_gb, cache_gb, free_gb
  }
')

SWAP_GB=$(sysctl -n vm.swapusage | awk '{
  val  = substr($6, 1, length($6)-1) + 0
  unit = substr($6, length($6))
  if      (unit == "G") printf "%.1f", val
  else if (unit == "M") printf "%.1f", val/1024
  else                  printf "0.0"
}')

sketchybar --set $NAME label="$MEM_LABEL s${SWAP_GB}"
