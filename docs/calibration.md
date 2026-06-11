# Kalibrering – strøm, rotation_distance & afstande

## Strøm (TMC2208 UART)

Strøm styres i Klipper — **ikke VREF** (PDN-EN jumper PÅ, VREF ignoreres).

| Parameter | Fil | Standard |
|-----------|-----|----------|
| `run_current` | `klipper/tmc2208_uart.cfg` | 0.650 A |
| `hold_current` | `klipper/tmc2208_uart.cfg` | 0.400 A |

Live-justering i Mainsail:

```
SET_TMC_CURRENT STEPPER=feeder1 CURRENT=0.65
SET_TMC_CURRENT STEPPER=feeder2 CURRENT=0.65
```

**Pancake NEMA17:** Start ved 0.65 A. Øg til ~0.75 A hvis filament glider; sænk hvis motoren bliver varm.

Permanent ændring: redigér `run_current` i `tmc2208_uart.cfg` og `SAVE_CONFIG` / genstart.

---

## E-steps (rotation_distance)

1. Marker filament 100 mm fra feeder-indgang
2. Kør `TEST_FEEDER1` i Mainsail (50 mm)
3. Mål faktisk bevægelse
4. Beregn: `ny = gammel × (faktisk / requested)`
5. Opdatér `rotation_distance` i `printer.cfg`
6. Gentag til præcis

---

## Fysiske afstande – MÅL DISSE

Opdatér `_FEEDER_VARS` i `macros.cfg`:

| Variabel       | Mål                                          |
|----------------|----------------------------------------------|
| `retract_dist` | Feeder 1 udgang → Y-splitter indgang + 20 mm |
| `load_dist`    | Y-splitter udgang → P1S extruder gear        |
| `purge_mm`     | Start 50 mm, juster efter test               |

---

## Test-sekvens

```
1. PRELOAD_B          → Spool B skal nå Y-splitteren
2. FILAMENT_RUNOUT    → Observer hele det autonome skift
3. Juster variabler   → Gentag til skiftet er rent
```
