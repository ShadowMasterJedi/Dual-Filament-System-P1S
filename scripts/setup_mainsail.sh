#!/bin/bash
# Opsæt Moonraker + Mainsail + dashboard for Dual Filament (parallel med UR3)
# Kører uden sudo – bruger systemd user services
set -euo pipefail

PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
DATA="${HOME}/printer_data_dual_filament"
HOST_IP="$(hostname -I | awk '{print $1}')"
USER_UNIT="${HOME}/.config/systemd/user"

echo "==> Opretter printer_data_dual_filament..."
mkdir -p "${DATA}"/{config,logs,database,gcodes,comms,systemd}

echo "==> Deployer Moonraker config..."
cp "${PROJECT}/config/moonraker.conf" "${DATA}/config/"

echo "==> Deployer Klipper config (parallel)..."
bash "${PROJECT}/scripts/install.sh"

echo "==> Kopierer Mainsail til mainsail-dual-filament..."
rm -rf "${HOME}/mainsail-dual-filament"
cp -a "${HOME}/mainsail" "${HOME}/mainsail-dual-filament"
cat > "${HOME}/mainsail-dual-filament/config.json" <<EOF
{
    "defaultLocale": "da",
    "defaultMode": "dark",
    "defaultTheme": "mainsail",
    "hostname": "${HOST_IP}",
    "port": 7126,
    "path": null,
    "instancesDB": "moonraker",
    "instances": []
}
EOF

echo "==> Opdaterer hoved-Mainsail med printervælger..."
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
        },
        {
            "name": "Dual Filament S6",
            "hostname": "${HOST_IP}",
            "port": 7126,
            "path": null
        }
    ]
}
EOF

echo "==> Installerer systemd user services..."
mkdir -p "${USER_UNIT}"

cat > "${DATA}/systemd/moonraker-dual-filament.env" <<EOF
MOONRAKER_ARGS="/home/per/moonraker/moonraker/moonraker.py -d /home/per/printer_data_dual_filament"
EOF

cp "${PROJECT}/deploy/moonraker-dual-filament.service" "${USER_UNIT}/"
cp "${PROJECT}/deploy/feeder-dashboard.service" "${USER_UNIT}/"
cp "${PROJECT}/deploy/feeder-mainsail.service" "${USER_UNIT}/"

echo "==> Genstarter services..."
systemctl --user daemon-reload
systemctl --user enable moonraker-dual-filament.service feeder-dashboard.service feeder-mainsail.service
systemctl --user restart klipper-dual-filament.service
systemctl --user restart moonraker-dual-filament.service
systemctl --user restart feeder-dashboard.service
systemctl --user restart feeder-mainsail.service

sleep 2
echo ""
echo "✅ Dual Filament UI klar:"
echo "   Dashboard:     http://${HOST_IP}:8881/"
echo "   Mainsail S6:   http://${HOST_IP}:8082/"
echo "   UR3 + vælger:  http://${HOST_IP}/  → vælg 'Dual Filament S6'"
echo ""
systemctl --user is-active moonraker-dual-filament feeder-dashboard feeder-mainsail klipper-dual-filament
