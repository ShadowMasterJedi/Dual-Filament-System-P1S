# FYSETC S6 v2.1 – Jumper-guide

**Opdateret:** 11. juni 2026

---

## Aktuel produktionsopsætning: UART (TMC2208 V2)

Dual Filament kører **UART** med **BTT TMC2208 V2** i E0+E1.  
Se **`tmc2208_uart_test.md`** for config og test.

**E0 + E1 (begge feeder-slots):**

| Jumper | Indstilling |
|--------|-------------|
| **PDN-EN** | **PÅ** |
| 2×4 blok mellem headers | **AF** |
| UART1 / øvrige | **AF** |
| E2, Z, X, Y | **AF** |

Config: `[include tmc2208_uart.cfg]` i `printer.cfg` — strøm via **`run_current`** i Klipper.

---

## Driver-moduler

| Slot | Driver | UART |
|------|--------|------|
| E0 — Feeder 1 | BTT TMC2208 V2 | ✅ Bekræftet |
| E1 — Feeder 2 | BTT TMC2208 V2 | ✅ Bekræftet |

**Montering:** Varmesink opad, notch matcher boardets markering.

**BTT TMC2208 V2:** Nogle moduler kræver **bridged UART-pads** på driver-printet (ved MS3/PDN_UART). Vores moduler virkede med kun PDN-EN på S6.

---

## UART-pins og config

| Feeder | Slot | `uart_pin` |
|--------|------|------------|
| Feeder 1 | E0 | `PA15` |
| Feeder 2 | E1 | `PC5` |

```cfg
[tmc2208 manual_stepper feeder1]
uart_pin: PA15
run_current: 0.650
hold_current: 0.400
sense_resistor: 0.110

[tmc2208 manual_stepper feeder2]
uart_pin: PC5
run_current: 0.650
hold_current: 0.400
sense_resistor: 0.110
```

UART OK = ingen `Unable to read tmc2208 ... register IFCNT` i `klippy.log`.

---

## Billeder og tegninger

- `hardware/jumper-pdn-en-uart.jpg`
- `hardware/jumper-btt-drivers-e0-e1.jpg`
- `hardware/jumper-raekke3-guide.svg`
- `hardware/jumper-tegning-dit-board.svg`
- `hardware/jumper-overlay.html`

---

## Arkiv: TMC2209 V1.3 (standalone — udfaset)

BTT TMC2209 V1.3 UART blev testet uden succes:

- PDN-EN på + række 1/2/3 i 2×4-blok
- Kun PDN-EN på
- E2-slot test (`uart_pin: PE0`) — samme `IFCNT`-fejl

**Standalone-fallback** (alle jumpere AF, strøm via VREF): se `standalone_guide.md`.

Officiel kilde: [FYSETC/FYSETC-S6](https://github.com/FYSETC/FYSETC-S6) · [Wiki](https://wiki.fysetc.com/FYSETC_S6/)
