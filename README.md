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
| 2× BTT TMC2208 V2 (E0 + E1, UART) | ✅ Produktion |
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
│   ├── printer.cfg          # manual_stepper + tmc2208_uart.cfg
│   ├── tmc2208_uart.cfg     # UART drivere E0+E1
│   ├── macros.cfg           # Feeder-macros
│   └── filament_sensor.cfg  # Runout-sensor
├── hardware/
│   └── wiring_notes.md      # Tilslutningsguide
├── docs/
│   ├── flash_guide.md       # Flash-vejledning FYSETC S6
│   ├── calibration.md       # Strøm + E-steps kalibrering
│   ├── tmc2208_uart_test.md # UART produktionsguide
│   ├── jumper_guide.md      # PDN-EN jumpere
│   └── feeder_bom.md        # Feeder indkøbsliste
├── scripts/
│   ├── flash_pi_sd.sh       # Flash MainsailOS til Pi SD
│   ├── setup_pi_host.sh     # Deploy config på Pi
│   ├── deploy_pi_config_offline.sh  # Deploy via SD i NUC
│   └── test_tmc2208_uart.sh # UART status-check
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
6. TMC2208: PDN-EN **PÅ** på E0+E1 — se [`docs/tmc2208_uart_test.md`](docs/tmc2208_uart_test.md)

| UI | URL |
|----|-----|
| Mainsail (Dual Filament) | `http://pi3feeder.local/` |
| UR3 (NUC) | `http://linuxrobot/` eller `http://192.168.50.119/` |

## Motor-test (Mainsail)

```
DUMP_TMC STEPPER=feeder1
TEST_FEEDER1
TEST_FEEDER2
```

## NUC – fjern gammel dual-stack

Hvis NUC tidligere kørte parallel Klipper på port 7126:

```bash
bash scripts/remove_nuc_dual_klipper.sh
```

UR3 Octopus på port 7125 påvirkes ikke.

## Status

**Fase**: TMC2208 UART produktion E0+E1 bekræftet (`pi3feeder`, Klipper ready)  
**Sidst opdateret**: 11. juni 2026
