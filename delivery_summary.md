# Dual Filament System – Delivery Summary & Memory Context

**Projektnavn**: Dual Filament Feeder System til Bambu P1S  
**Dato**: Juni 2026  
**Status**: Klar til byggestart  
**Sværhedsgrad**: Medium (Mekanik + Klipper opsætning)

---

## Projektmål

Bygge et automatisk dual-filament feeder system med to uafhængige steppere, Y-splitter, BTT sensor og Klipper-styring, så filamentskift sker semi-automatisk med minimal manuel indgriben.

---

## Arbejdsgang (defineret)

1. Indlæs filament fra **Spool A** → Feeder 1 → Y-splitter → BTT Sensor → P1S
2. **Preload Spool B** via Feeder 2 op til Y-splitteren (standby)
3. Start print på P1S (Feeder 1 assisterer aktivt)
4. **Runout** trigges på BTT-sensor
5. **Klipper-macro** pauser print, aktiverer Feeder 2 (feed igennem Y-splitter → sensor → P1S)
6. Macro kører **automatisk purge-sekvens** (retract → skift → prime → purge tower/wipe)
7. Print **genoptages automatisk** – ingen manuel indgriben
8. **Notifikation** sendes som info (ikke som krav om handling)

> ⚠️ **Design-krav**: Systemet skal være fuldt autonomt. Ingen manuel load eller purge på P1S.

---

## Komponentstatus

| Komponent                  | Rolle                          | Status       |
|---------------------------|--------------------------------|--------------|
| Feeder 1 + Stepper 1      | Aktiv feeder                   | ✅ Har       |
| Feeder 2 + Stepper 2      | Standby/preload                | ✅ Har       |
| BTT Filament Sensor       | Runout-sensor efter Y-splitter | ✅ Har       |
| FYSETC S6 v2.1 + 2× TMC2209 | Styring af steppere (E0+E1 slots) | ✅ Har  |
| Y-Splitter (PTFE)         | Passiv sammenføjning           | 🖨️ Skal printes |
| Raspberry Pi 4/5          | Klipper + Fluidd/Mainsail      | ⚠️ Anbefales |

---

## BOM – Mangler

| Vare                              | Antal | Note                        |
|----------------------------------|-------|-----------------------------|
| PTFE Tubing Capricorn 1.75mm     | 4–5 m | Lav friktion anbefales      |
| PC4-M6 / PC4-M10 fittings       | 10 stk| Push-to-connect             |
| Filament Feeder (BMG/Orbiter)    | 2 stk | Hobbed gear + bearings      |
| Dual Spool Holder                | 1 stk | Printes eller købes         |
| Y-Splitter + mounts              | 1 sæt | 3D-printes                  |
| Raspberry Pi 4/5 + MicroSD      | 1 stk | Kun hvis mangler            |
| USB-kabel (Pi → SKR Pro)        | 1 stk |                             |
| 24V PSU (5–10A ekstra)          | 1 stk | Anbefales                   |

**Estimeret ekstraomkostning**: 450–850 DKK

---

## Faser & Næste Trin

### Fase 1 – Hardware & Print (Uge 1–2)
- [ ] Print Y-splitter, feeder mounts, spool holder
- [ ] Bestil manglende komponenter (PTFE, fittings, feedere)
- [ ] Saml mekanik og monter feedere

### Fase 2 – Klipper Opsætning (Uge 2–3)
- [ ] Installer Klipper + Fluidd/Mainsail på Raspberry Pi
- [ ] Tilslut og konfigurer BTT SKR Pro
- [ ] Tilføj 2× TMC2209 i printer.cfg
- [ ] Definer ekstra steppere (stepper_a, stepper_b)

### Fase 3 – Kalibrering (Uge 3)
- [ ] Kalibrer E-steps på Feeder 1
- [ ] Kalibrer E-steps på Feeder 2
- [ ] Test PTFE-routing og Y-splitter flow

### Fase 4 – Sensor & Macros (Uge 3–4)
- [ ] Opsæt BTT Filament Sensor i Klipper
- [ ] Skriv og test `FILAMENT_RUNOUT` macro
- [ ] Skriv og test `PRELOAD_B` macro (80–120 mm burst)
- [ ] Opsæt notifikationer (Discord/Telegram)

### Fase 5 – Test & Finjustering (Uge 4)
- [ ] Kør end-to-end test med runout-simulation
- [ ] Juster burst-længde og timing
- [ ] Dokumentér endelig konfiguration

---

## Åbne Spørgsmål / Beslutninger

- [x] Har bruger Raspberry Pi allerede? **JA**
- [x] System skal køre **fuldt autonomt** – ingen manuel load/purge på P1S
- [ ] Foretrukket notifikationskanal (Discord / Telegram / email)?
- [ ] Ønskes Klipper config-eksempler (copy-paste klar)? **→ JA, næste skridt**
- [ ] Præcis PTFE-distance fra Y-splitter til P1S extruder? (til feed-kalibrering)
- [ ] Har P1S AMS eller kører den stock single-feed?

---

## Leverancer Produceret

| Fil                        | Indhold                              | Dato      |
|---------------------------|--------------------------------------|-----------|
| delivery_summary.md       | Memory-kontekst og projektoversigt   | Juni 2026 |

---

## Noter til Fremtidige Sessions

- Projekt bruger **BTT SKR Pro** (ikke Octopus/Manta) – husk port-navne
- Y-splitter er **passiv** – ingen aktiv selector mekanik i V1
- Macro-burst på **80–120 mm** er udgangspunkt, skal kalibreres
- P1S kræver stadig **manuel purge** ved skift – dette er en known limitation
- Mulig fremtidig udvidelse: 3. stepper som selector (V2)
