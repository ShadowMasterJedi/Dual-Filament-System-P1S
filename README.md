# Dual Filament System – Bambu P1S + FYSETC S6 v2.1

Automatisk dual-filament feeder system til Bambu P1S med Klipper-styring via FYSETC S6 v2.1 board.

## Systemarkitektur

```
[Spool A] → [Feeder 1] ─┐
                          ├─ [Y-Splitter] → [BTT Sensor] → [P1S]
[Spool B] → [Feeder 2] ─┘

Raspberry Pi 3 (pi3feeder)  →  USB  →  FYSETC S6 v2.1
NUC (linuxrobot)            →  UR3 Octopus (separat Klipper-stack)
```

## Autonom arbejdsgang

1. Spool A kører aktivt via Feeder 1
2. Spool B er preloadet til Y-splitteren (standby)
3. BTT sensor registrerer runout
4. Klipper pauser print og aktiverer Feeder 2 automatisk
5. Automatisk purge-sekvens køres
6. Print genoptages – ingen manuel indgriben

## Hardware

| Komponent | Status |
|-----------|--------|
| FYSETC S6 v2.1 | ✅ |
| 2× BTT TMC2209 v1.3 (E0 + E1 slots) | ✅ |
| 2× Redrex Dual Gear extruder | ✅ Købt |
| 2× NEMA17 pancake stepper (24 mm aksel) | ✅ Købt |
| Y-splitter 4-port (print) | ✅ Printet |
| BTT Filament Sensor | ✅ |
| Raspberry Pi 3 (`pi3feeder`) | ✅ MainsailOS host |
| PC4-M6 bowden fitting | ✅ 4 stk |
| PTFE 2× 300 mm (feeder → splitter) | ✅ Har |
| PTFE splitter → P1S (længere stykke) | 🛒 Køb |

Se komplet indkøbsliste: [`docs/feeder_bom.md`](docs/feeder_bom.md)

**Estimeret rest**: ca. 50–100 DKK (primært én længere PTFE)

## Mappestruktur

```
├── klipper/
│   ├── printer.cfg          # manual_stepper – Pi host
│   ├── macros.cfg           # Feeder-macros
│   └── filament_sensor.cfg  # Runout-sensor
├── hardware/
│   └── wiring_notes.md      # Tilslutningsguide
├── docs/
│   ├── flash_guide.md       # Flash-vejledning FYSETC S6
│   ├── calibration.md       # E-steps kalibrering
│   └── feeder_bom.md        # Feeder indkøbsliste
├── scripts/
│   ├── flash_pi_sd.sh       # Flash MainsailOS til Pi SD
│   ├── setup_pi_host.sh     # Deploy config på Pi
│   ├── deploy_pi_config_offline.sh  # Deploy via SD i NUC
│   └── remove_nuc_dual_klipper.sh   # Fjern gammel NUC-stack
└── delivery_summary.md      # Projekthukommelse / status
```

## Kom i gang (Raspberry Pi)

1. Flash S6: [`docs/flash_guide.md`](docs/flash_guide.md)
2. Flash Pi SD (på NUC): `sudo CONFIRM=JA ARCH=armhf bash scripts/flash_pi_sd.sh`
3. WiFi på SD: `sudo bash scripts/apply_mainsail_wifi.sh`
4. Config (vælg én):
   - **På Pi:** `bash scripts/setup_pi_host.sh`
   - **Offline (SD i NUC):** `sudo bash scripts/deploy_pi_config_offline.sh`
5. S6 USB → Pi, tænd, vent 3–5 min

| UI | URL |
|----|-----|
| Mainsail (Dual Filament) | `http://pi3feeder.local/` |
| UR3 (NUC) | `http://linuxrobot/` eller `http://192.168.50.119/` |

## NUC – fjern gammel dual-stack

Hvis NUC tidligere kørte parallel Klipper på port 7126:

```bash
bash scripts/remove_nuc_dual_klipper.sh
```

UR3 Octopus på port 7125 påvirkes ikke.

## Status

**Fase**: Pi-host kørende (`pi3feeder`, Klipper ready)  
**Sidst opdateret**: Juni 2026
