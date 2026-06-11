#!/bin/bash
# Tjek TMC2208 UART-status via Moonraker på pi3feeder
set -euo pipefail

HOST="${MOONRAKER_HOST:-pi3feeder.local}"
PORT="${MOONRAKER_PORT:-7125}"
URL="http://${HOST}:${PORT}"

echo "=== TMC2208 UART — produktion E0+E1 ==="
echo "    Moonraker: ${URL}"
echo ""

if ! curl -sf --connect-timeout 5 "${URL}/server/info" >/dev/null; then
    echo "❌ Kan ikke nå ${HOST}"
    echo "   Tjek at Pi er tændt og på netværket."
    exit 1
fi

STATE=$(curl -sf "${URL}/printer/objects/query?webhooks" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('result',{}).get('status',{}).get('webhooks',{}).get('state','unknown'))
" 2>/dev/null || echo "unknown")

echo "Klipper state: ${STATE}"
echo ""
echo "Kør i Mainsail Console:"
echo "  FIRMWARE_RESTART"
echo "  DUMP_TMC STEPPER=feeder1"
echo "  DUMP_TMC STEPPER=feeder2"
echo "  TEST_FEEDER1"
echo "  TEST_FEEDER2"
echo ""
echo "UART OK  = ingen IFCNT-fejl i klippy.log, DUMP_TMC viser registerdata"
echo "UART FAIL = 'Unable to read tmc2208' i loggen"
echo ""
echo "Log (seneste TMC-linjer):"
ssh -o ConnectTimeout=5 "pi@${HOST}" \
    "grep -iE 'tmc2208|IFCNT|uart' ~/printer_data/logs/klippy.log 2>/dev/null | tail -15" \
    2>/dev/null || echo "   (SSH ikke tilgængelig — tjek log i Mainsail)"
