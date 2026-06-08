# Feeder BOM – HANOV BMG Dual Drive

Valgt setup til Feeder 1 og Feeder 2: selvprintet BMG-hus + købte gear-sæt.

## Anbefalet gear-sæt (valgt)

| | |
|---|---|
| **Produkt** | POLISI MK3 Dual Drive Gear Kit |
| **ASIN** | `B07L23XRQT` |
| **Link** | [amazon.de/dp/B07L23XRQT](https://www.amazon.de/dp/B07L23XRQT) |
| **Pris** | ca. €7–8 pr. sæt |
| **Antal** | **2 stk** (én per feeder) |

### Specifikationer

| Parameter | Værdi |
|-----------|-------|
| Type | Dual drive (BMG-kompatibel) |
| Filament | 1,75 mm |
| Motoraksel | 5 mm bore (NEMA17) |
| Materiale | Rustfrit stål |
| Indhold | 2× gear, M3×20 aksel, 2× nadellager, møtrikker |

MK3-navnet i titlen refererer til Prusa MK3's Bondtech-gears — samme geometri som BMG-extrudere.

### Hvorfor POLISI

- Tyske anmeldelser bekræfter pasform i BMG-kloner og Voron Afterburner
- Direkte sammenlignet med originale Bondtech gears — minimal forskel
- Billigere end UniTak3D og Turmberg3D med tilsvarende spec

---

## Printet hus

| | |
|---|---|
| **Model** | [HANOV Dual Drive Printable Extruder](https://www.printables.com/model/308550-hanov-dual-drive-gear-printable-extruder) |
| **Antal** | **2 stk** |
| **Materiale** | PETG eller ABS anbefalet |

---

## Allerede på lager

| Komponent | Antal | Status |
|-----------|-------|--------|
| NEMA17 stepper | 2 | ✅ Har |
| FYSETC S6 E0/E1 slots | 2 | ✅ Har |
| TMC2209 v1.3 (standalone) | 2 | ✅ Har |

---

## Indkøbsliste

| # | Komponent | Antal | Est. pris | Status |
|---|-----------|-------|-----------|--------|
| 1 | POLISI gear kit B07L23XRQT | 2 | ~€14–16 | 🛒 Køb |
| 2 | HANOV BMG-hus (print) | 2 | — | 🖨️ Print |
| 3 | PC4-M6 bowden fitting | 4 | ~€4 | 🛒 Køb |
| 4 | M3 skruer/sæt (per STL) | 1 sæt | ~€3 | 🛒 Køb |
| 5 | Capricorn PTFE (4–5 m) | 1 | ~€10 | 🛒 Køb |

**Estimeret gear + fittings**: ca. 150–200 DKK

---

## Alternativer (ikke valgt)

| Produkt | ASIN | Pris | Note |
|---------|------|------|------|
| UniTak3D Dual Drive Gear | B09JJQLJB9 | ~€10 | OK budget-alternativ |
| Turmberg3D Dual Drivegear Kit | B09LR9N53Z | ~€15 | Tysk sælger, god kendt |
| Bondtech EXT-KIT33 | — | ~€32 | Original — ikke på amazon.de |

---

## Undgå

| Produkt | Hvorfor |
|---------|---------|
| MK8/MK7 single-gear kits | Forkert geometri — ikke dual drive |
| 8 mm bore varianter | Til Prusa MK3 med 8 mm aksel — ikke standard NEMA17 |
| Hele BMG-extrudere (Redrex, 3DMAN) | Vi printer selv HANOV-huset — kun gears nødvendigt |

---

## Montering

1. Print 2× HANOV BMG-hus
2. Montér POLISI gear-sæt i hvert hus (primær på motor, sekundær på 3 mm aksel)
3. Smør gears med lithiumfedt (tyndt lag)
4. Tilslut NEMA17 til S6 E0 (Feeder 1) og E1 (Feeder 2)
5. Kalibrer `rotation_distance` — se [`calibration.md`](calibration.md)
