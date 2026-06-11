#!/bin/bash
# Omdøb Pi via SSH: pi1zero → feedled (eller vilkårligt)
# Brug:  bash rename_pi_hostname.sh <IP> [nyt-hostname]
set -euo pipefail

IP="${1:?Brug: bash $0 <IP> [hostname]}"
NEW_HOST="${2:-feedled}"
USER="${PI_USER:-pi}"

echo "==> SSH til ${USER}@${IP} — sæt hostname til ${NEW_HOST}"

ssh -o StrictHostKeyChecking=accept-new "${USER}@${IP}" bash -s -- "${NEW_HOST}" <<'REMOTE'
set -euo pipefail
NEW="$1"
OLD="$(hostname)"
echo "Gammelt hostname: ${OLD}"
sudo hostnamectl set-hostname "${NEW}"
sudo sed -i "s/${OLD}/${NEW}/g" /etc/hosts
grep -q "127.0.1.1" /etc/hosts || echo "127.0.1.1 ${NEW}" | sudo tee -a /etc/hosts
sudo sed -i "s/^127.0.1.1.*/127.0.1.1 ${NEW}/" /etc/hosts
echo "Nyt hostname: $(hostname)"
echo "Reboot om 3 sek for mDNS-opdatering..."
sleep 3
sudo reboot
REMOTE

echo "✅ ${IP} omdøbt til ${NEW_HOST} — vent 2 min, prøv: ssh ${USER}@${NEW_HOST}.local"
