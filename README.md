# Dual Filament System – Bambu P1S + FYSETC S6 v2.1

Automatisk dual-filament feeder system til Bambu P1S med Klipper-styring via FYSETC S6 v2.1 board.

## Systemarkitektur

```
[Spool A] → [Feeder 1] ─┐
                          ├─ [Y-Splitter] → [BTT Sensor] → [P1S]
[Spool B] → [Feeder 2] ─┘
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
| 2× NEMA17 steppere | ✅ |
| BTT Filament Sensor | ✅ |
| Raspberry Pi 4/5 | ✅ |
| Y-Splitter (PTFE) | 🖨️ Print selv |
| Capricorn PTFE 4–5m | 🛒 Køb |
| PC4-M6/M10 fittings ×10 | 🛒 Køb |
| BMG/Orbiter feedere ×2 | 🛒 Køb |

**Estimeret ekstraomkostning**: 450–850 DKK

## Mappestruktur

```
├── klipper/
│   ├── printer.cfg          # Hoved-konfiguration
│   ├── macros.cfg           # Alle macros
│   └── filament_sensor.cfg  # Sensor-konfiguration
├── hardware/
│   └── wiring_notes.md      # Tilslutningsguide
├── docs/
│   ├── flash_guide.md       # Flash-vejledning FYSETC S6
│   └── calibration.md       # E-steps kalibrering
├── scripts/
│   └── install.sh           # Klipper include-hjælper
└── delivery_summary.md      # Projekthukommelse / status
```

## Kom i gang

Se [`docs/flash_guide.md`](docs/flash_guide.md) for første skridt.

## Status

**Fase**: Klipper opsætning  
**Sidst opdateret**: Juni 2026
