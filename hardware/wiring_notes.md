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
| E0-MOT      | NEMA17 #1 (Feeder 1) |
| E1-MOT      | NEMA17 #2 (Feeder 2) |

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
