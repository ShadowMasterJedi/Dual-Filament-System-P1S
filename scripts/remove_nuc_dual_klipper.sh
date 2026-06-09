#!/bin/bash
# Fjern parallel dual-Klipper stack fra NUC (UR3 på :7125 beholdes uændret)
# Dual Filament hostes nu på Raspberry Pi (pi3feeder)
set -euo pipefail

SERVICES=(
    klipper-dual-filament
    moonraker-dual-filament
    feeder-dashboard
    feeder-mainsail
)

USER_UNIT="${HOME}/.config/systemd/user"
HOST_IP="$(hostname -I | awk '{print $1}')"

echo "==> Stopper og deaktiverer dual-filament services..."
for s in "${SERVICES[@]}"; do
    systemctl --user stop "${s}.service" 2>/dev/null || true
    systemctl --user disable "${s}.service" 2>/dev/null || true
    rm -f "${USER_UNIT}/${s}.service"
done
systemctl --user daemon-reload

echo "==> Opdaterer Mainsail printervælger (kun UR3)..."
mkdir -p "${HOME}/mainsail"
cat > "${HOME}/mainsail/config.json" <<EOF
{
    "defaultLocale": "da",
    "defaultMode": "dark",
    "defaultTheme": "mainsail",
    "hostname": null,
    "port": null,
    "path": null,
    "instancesDB": "json",
    "instances": [
        {
            "name": "UR3 Octopus",
            "hostname": "${HOST_IP}",
            "port": null,
            "path": null
        }
    ]
}
EOF

echo ""
echo "✅ NUC dual Klipper fjernet"
echo "   UR3 Mainsail:     http://${HOST_IP}/"
echo "   Dual Filament:    http://pi3feeder.local/  (Raspberry Pi)"
echo ""
echo "Valgfri oprydning (arkivér først hvis du vil beholde backup):"
echo "   ~/printer_data_dual_filament/"
echo "   ~/mainsail-dual-filament/"
echo "   ~/printer_data/config/dual_filament_*"
echo "   ~/printer_data/comms/dual_filament.*"
