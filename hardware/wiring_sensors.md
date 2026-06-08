# Sensor Wiring – BTT SFS V2.0 + Downstream

## Arkitektur

```
[Spool A] → [Sensor A] → [Feeder 1] ─┐
                                      ├─ [Y-Splitter] → [Sensor DS] → [P1S]
[Spool B] → [Sensor B] → [Feeder 2] ─┘
```

## BTT Smart Filament Sensor V2.0 – pinout (per sensor)

| Ledning | Farve (typisk) | Funktion        |
|---------|----------------|-----------------|
| VCC     | Rød            | 5V              |
| GND     | Sort           | Ground          |
| OUT0    | Hvid/Gul       | Switch (runout) |
| OUT1    | Grøn           | Motion (encoder) |

> Hver SFS V2.0 har **to** 3-pin stik: OUT0 (switch) og OUT1 (motion).

## Port-mapping – FYSETC S6 v2.1

| Signal           | Sensor     | S6 Port    | Klipper Pin | Kabel til S6 |
|------------------|------------|------------|-------------|--------------|
| Switch (runout)  | Sensor A   | E2 endstop | `^PC15`     | OUT0 → E2 STOP |
| Motion (encoder) | Sensor A   | Z+ endstop | `^PA0`      | OUT1 → Z+ STOP |
| Switch (runout)  | Sensor B   | X+ endstop | `^PC14`     | OUT0 → X+ STOP |
| Motion (encoder) | Sensor B   | Y+ endstop | `^PA1`      | OUT1 → Y+ STOP |
| Switch (runout)  | Downstream | Z- endstop | `^PB12`     | OUT0 → Z- STOP |

### Endstop-stik på S6 (3-pin, alle sensorer)

| Pin på stik | Tilslut |
|-------------|---------|
| **S** (signal) | Sensor OUT0 eller OUT1 |
| **V** (+)      | 5V (delt fra S6 5V rail) |
| **G** (GND)    | GND |

`^` i Klipper = intern pull-up (anbefalet for BTT switch/motion).

## Strøm

- Alle sensorer: **5V** fra S6 (ikke 24V).
- Downstream-sensor kan være BTT SFS V1.0 (kun switch) eller V2.0 (brug kun OUT0).

## Test efter montering

Kør i Mainsail-konsol (efter `FIRMWARE_RESTART`):

```
SENSOR_STATUS
QUERY_FILAMENT_SENSOR SENSOR=sensor_a_switch
QUERY_FILAMENT_SENSOR SENSOR=sensor_a_motion
QUERY_FILAMENT_SENSOR SENSOR=sensor_b_switch
QUERY_FILAMENT_SENSOR SENSOR=sensor_b_motion
QUERY_FILAMENT_SENSOR SENSOR=sensor_downstream
```

| Test | Forventet |
|------|-----------|
| Filament i sensor | `filament_detected: True` |
| Tom / runout      | `filament_detected: False` |
| Motion under feed | `sensor_a_motion` / `sensor_b_motion` = True mens feeder koerer |

Feeder-test:

```
TEST_FEEDER1
TEST_FEEDER2
SENSOR_STATUS
```

Downstream-skift (simuleret):

```
SIMULATE_RUNOUT
```

## Fejlfinding

| Problem | Tjek |
|---------|------|
| Sensor altid False | VCC/GND byttet? Signal på S-pin? |
| Sensor altid True  | Fjern `^` pull-up test (`!^PC15`) |
| Motion jam altid   | OUT1 kabel + feeder koerer? `detection_length` |
| Downstream trigger for tidligt | Sensor placeret **efter** Y-splitter |

## Relaterede filer

- `klipper/filament_sensor.cfg` – alle 5 sensor-definitioner
- `klipper/macros_sensors.cfg` – RUNOUT_A/B, SWITCH_TO_B, SENSOR_STATUS
- `hardware/wiring_notes.md` – steppere og PSU
