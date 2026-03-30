# WooCommerce Kassenintegration – Bug-Workaround
**Ein pragmatischer Lösungsansatz für inkonsistente Transaktionsdaten in einer WordPress/WooCommerce-Umgebung**

---

## Hintergrund
Dieses Projekt entstand während meiner Umschulung zum Anwendungsentwickler (2023–2025) als Teil eines Praktikumsplugins für eine WooCommerce-Kassenintegration. **Kurz vor der Abgabe** trat ein kritischer Bug auf:
- **Transaktionsdaten** (Wallet-Guthaben + Bezahlvorgänge) stimmten nicht mit den **Bestelldaten** überein.
- Der Fehler lag in der **Fremdsoftware (Kassensystem, geschrieben in Dart)**, die ich **nicht modifizieren konnte** (kein Zugriff auf den Quellcode).
- **Zeitdruck:** Die Lösung musste vor dem Prüfungstermin fertig sein – **ohne Möglichkeit, zu Hause weiterzuarbeiten** (Datenschutzbestimmungen).

---

## Problemanalyse
### 1. Fehlersuche
- **Erste Annahme:** Fehler lag in meinem Plugin-Code → **Kleinen Bug behoben**, aber das Problem blieb bestehen.
- **Systematische Analyse:**
  - **Monat für Monat** Live-Daten des Kassensystems mit WooCommerce-DB-Tabellen abgeglichen.
  - **Logs analysiert** (WordPress-Debug-Logs, Plugin-Interaktionen).
  - **Ergebnis:** Der Fehler entstand durch eine **Kombination aus fehlerhafter Wallet-Guthaben-Generierung** und **Bezahlvorgang** in der Fremdsoftware.

### 2. Herausforderungen
- **Kein Zugriff auf die Fremdsoftware** (Dart-Code, unbekannte Sprache).
- **Kein Home-Office** möglich (Datenschutz) → **Begrenzte Arbeitszeit im Praktikum** (nur wenige Stunden/Woche).
- **Unklare Prüfungsanforderungen** → Lösung musste **sauber und dokumentierbar** sein, um Risiken zu minimieren.

---

## Lösung: SQL-basierter Workaround
Da eine direkte Behebung des Bugs in der Fremdsoftware **nicht möglich** war, entwickelte ich eine **SQL-basierte Lösung**, die:
1. **Die inkonsistenten Transaktionsdaten korrigiert** (via `SUBSTRING`-Logik für Wallet-IDs).
2. **Alle relevanten Bestellinformationen** (Produkte, Preise, Kunden-IDs) in einem **strukturierten JSON-Format** ausgibt.
3. **Valide Daten für die Abrechnung** liefert – **ohne die Fremdsoftware zu modifizieren**.
