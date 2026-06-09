# Deploy – NUC dual-Klipper (udfaset)

Filerne i denne mappe var til en **parallel Klipper-stack på NUC** (`linuxrobot`) på port 7126,
kørende ved siden af UR3 Octopus (port 7125).

**Status (juni 2026):** Dual Filament hostes på **Raspberry Pi 3** (`pi3feeder`) med MainsailOS.
NUC bruges kun som SD-flash/arbejdsstation.

## Fjern gammel NUC-opsætning

```bash
bash scripts/remove_nuc_dual_klipper.sh
```

## Pi-opsætning (aktuel)

| Trin | Script |
|------|--------|
| Flash MainsailOS | `scripts/flash_pi_sd.sh` |
| WiFi på SD | `scripts/apply_mainsail_wifi.sh` |
| Config på Pi | `scripts/setup_pi_host.sh` |
| Config offline (SD i NUC) | `scripts/deploy_pi_config_offline.sh` |

Mainsail: **http://pi3feeder.local/**
