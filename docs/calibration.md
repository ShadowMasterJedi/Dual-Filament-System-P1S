# Kalibrering – rotation_distance & Afstande

## E-steps (rotation_distance)

1. Marker filament 100mm fra feeder-indgang
2. Kør `TEST_FEEDER1` i Fluidd (ekstruder 50mm)
3. Mål faktisk bevægelse
4. Beregn: `ny = gammel × (faktisk / requested)`
5. Opdatér `rotation_distance` i `printer.cfg`
6. Gentag til præcis

## Fysiske afstande – MÅL DISSE

Opdatér `_FEEDER_VARS` i `macros.cfg`:

| Variabel       | Mål                                          |
|----------------|----------------------------------------------|
| `retract_dist` | Feeder 1 udgang → Y-splitter indgang + 20mm  |
| `load_dist`    | Y-splitter udgang → P1S extruder gear        |
| `purge_mm`     | Start 50mm, juster efter test                |

## Test-sekvens

```
1. PRELOAD_B          → Spool B skal nå Y-splitteren
2. FILAMENT_RUNOUT    → Observer hele det autonome skift
3. Juster variabler   → Gentag til skiftet er rent
```
