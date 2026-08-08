#!/bin/bash

# throughput from netstat byte counters, delta against the previous sample
CACHE="/tmp/sketchybar_network_$USER"

# physical port, not the default route: VPN tunnels carry no LAN traffic
IFACE=""
for i in $(ifconfig -l); do
  case "$i" in en*) ;; *) continue ;; esac
  ifconfig "$i" 2>/dev/null | grep -q "status: active" || continue
  ipconfig getifaddr "$i" >/dev/null 2>&1 && IFACE="$i" && break
done
[ -z "$IFACE" ] && IFACE=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')

if [ -z "$IFACE" ]; then
  sketchybar --set "$NAME" label="↓ --- ↑ ---"
  exit 0
fi

# count fields from the end: interfaces without an address shift the columns left
read -r RX TX <<<"$(netstat -ibn | awk -v i="$IFACE" \
  '$1 == i && $3 ~ /Link/ { print $(NF-4), $(NF-1); exit }')"
NOW=$(date +%s)

if [ -f "$CACHE" ]; then
  read -r P_TIME P_RX P_TX <"$CACHE"
else
  P_TIME=$NOW P_RX=$RX P_TX=$TX
fi
echo "$NOW $RX $TX" >"$CACHE"

ELAPSED=$((NOW - P_TIME))
[ "$ELAPSED" -le 0 ] && ELAPSED=1

# counters reset on interface change, clamp negatives to 0
# drop the decimal at 100+ so the label stays narrow on a saturated 10G link
rate() {
  awk -v now="$1" -v prev="$2" -v t="$ELAPSED" \
    'BEGIN {
       d = (now - prev) / t / 1048576
       if (d < 0) d = 0
       printf (d < 100 ? "%.1f" : "%.0f"), d
     }'
}

sketchybar --set "$NAME" label="↓$(rate "$RX" "$P_RX") ↑$(rate "$TX" "$P_TX")"
