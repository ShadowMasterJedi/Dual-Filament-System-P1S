# Wiring Guide – FYSETC S6 v2.1

## Driver-slots

```
┌─────────┬─────────┬─────────┐
│    X    │    Y    │   Z1    │
├─────────┼─────────┼─────────┤
│   Z2    │ ►► E0 ◄◄│ ►► E1 ◄◄│
│         │Feeder 1 │Feeder 2 │
└─────────┴─────────┴─────────┘
```

TMC2209 orientering: **varmesinke opad**, notch matcher boardets markering.

## Motor-tilslutning

| S6 connector | Tilslut til  |
|-------------|--------------|
| E0-MOT      | Pancake NEMA17 #1 → Redrex Feeder 1 |
| E1-MOT      | Pancake NEMA17 #2 → Redrex Feeder 2 |

**Hardware:** Redrex Dual Gear extruder + NEMA17 pancake (24 mm aksel, 5 mm D-aksel).

| Emne | Note |
|------|------|
| Aksel | 5 mm D-aksel — D-fladen skal flugte med Redrex set screw |
| Moment | Pancake er svagere end fuld NEMA17 — feeder OK, ikke hotend |
| VREF | Start 0,85–1,0 V (standalone TMC2209), juster ved slip |
| Bowden | PC4-M6 fra Redrex → Y-splitter → downstream sensor → P1S |

## Filament Sensorer

5 sensorer (2× BTT SFS V2.0 ved spoler + 1× downstream). Se **`wiring_sensors.md`** for komplet guide.

| Sensor       | S6 port    | Pin     |
|--------------|------------|---------|
| A switch     | E2 endstop | `PC15`  |
| A motion     | Z+ endstop | `PA0`   |
| B switch     | X+ endstop | `PC14`  |
| B motion     | Y+ endstop | `PA1`   |
| Downstream   | Z- endstop | `PB12`  |

## Strømforsyning

| S6 terminal | PSU |
|-------------|-----|
| 24V+        | +   |
| GND         | –   |

> ⚠️ PSU kræves kun til stepper-test. USB alene er nok til flash.

## USB

USB-C fra Raspberry Pi → S6 v2.1 USB-C port.
