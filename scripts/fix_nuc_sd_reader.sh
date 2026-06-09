#!/bin/bash
# Fix Intel NUC indbygget SD-læser (8086:9d2d) – forhindrer UHS/SDR104 I/O-fejl
set -euo pipefail

CONF="/etc/modprobe.d/sdcard.conf"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

cat > "${CONF}" <<'EOF'
# Intel NUC Sunrise Point-LP SDHCI (8086:9d2d)
# Symptomer: "failed to setup card detect gpio", SDR104, mmcblk0 I/O error
#
# debug_quirks2 bits (sdhci):
#   0x2  = BROKEN_UHS      – slå UHS (SDR50/SDR104) fra
#   0x4  = NO_1_8_V        – ingen 1.8V switch (kræves for UHS)
#   0x80000000 = MERGE_CAPABILITIES – ACPI cap fix på Intel NUC
# debug_quirks:
#   0x1000 = BROKEN_ADMA   – ADMA giver I/O-fejl på nogle Intel slots
options sdhci debug_quirks=0x1000 debug_quirks2=0x80000006
softdep sdhci_pci pre: sdhci
EOF

echo "==> modprobe.d opdateret: ${CONF}"
cat "${CONF}"
echo ""

# Frigør kortet før reload
umount /dev/mmcblk0* 2>/dev/null || true
sync

echo "==> Genindlæser SDHCI-drivere..."
modprobe -r sdhci_pci 2>/dev/null || true
modprobe -r sdhci 2>/dev/null || true
sleep 1
modprobe sdhci
modprobe sdhci_pci
sleep 2

echo ""
echo "==> Driver-quirks nu:"
printf "  debug_quirks  = %s\n" "$(cat /sys/module/sdhci/parameters/debug_quirks)"
printf "  debug_quirks2 = %s\n" "$(cat /sys/module/sdhci/parameters/debug_quirks2)"
echo ""

if [ -b /dev/mmcblk0 ]; then
    echo "==> Test-læsning af sektor 0..."
    if dd if=/dev/mmcblk0 of=/dev/null bs=512 count=1 status=none 2>/dev/null; then
        echo "✅ Kort læsbart"
        lsblk -o NAME,SIZE,TYPE,MODEL,TRAN /dev/mmcblk0
    else
        echo "❌ Stadig I/O-fejl – prøv:"
        echo "   1. Tag SD-kort ud, vent 5 sek, sæt i igen"
        echo "   2. Kør scriptet igen"
        echo "   3. Eller brug ekstern USB-kortlæser"
        dmesg | tail -10
        exit 1
    fi
else
    echo "⚠️  Intet kort detekteret – sæt SD-kort i og kør scriptet igen"
fi

echo ""
echo "✅ Fix anvendt. Quirks er permanente efter reboot."
