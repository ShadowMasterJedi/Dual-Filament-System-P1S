#!/bin/bash
# CH340 (ESP32 m.fl.) — BRLTTY tager fejlagtigt serielporten på Ubuntu.
# Kør: sudo bash scripts/fix_esp32_usb_serial.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

RULE=/etc/udev/rules.d/49-ch340-no-brltty.rules
cat > "${RULE}" << 'EOF'
# CH340 USB-serial (ESP32, Arduino) — omgå BRLTTY's forkerte 1a86:7523-match
SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", ENV{PRODUCT}="1a86/0000/00", ENV{BRLTTY_BRAILLE_DRIVER}=""
SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666", GROUP="dialout"
EOF

# Stop kørende brltty (den holder stadig porten selvom servicen er masked)
systemctl stop brltty.service brltty-udev.service 2>/dev/null || true
systemctl mask brltty-udev.service 2>/dev/null || true
killall brltty 2>/dev/null || true

udevadm control --reload-rules
udevadm trigger --subsystem-match=usb --action=add

echo ""
echo "✅ BRLTTY stoppet + CH340 udelukket"
echo "   Træk ESP32 ud, vent 2 sek, sæt den i igen."
echo "   Tjek:  ls -l /dev/ttyUSB0"
