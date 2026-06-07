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

## Filament Sensor

| BTT Sensor pin | S6 pin         |
|----------------|----------------|
| GND            | GND            |
| VCC            | 5V             |
| SIGNAL         | PB10 (endstop) |

## Strømforsyning

| S6 terminal | PSU |
|-------------|-----|
| 24V+        | +   |
| GND         | –   |

> ⚠️ PSU kræves kun til stepper-test. USB alene er nok til flash.

## USB

USB-C fra Raspberry Pi → S6 v2.1 USB-C port.
