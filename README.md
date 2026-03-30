# WooCommerce Kassenintegration – SQL-Bugfix-Workaround
**Teil eines größeren PHP-Plugins zur Korrektur inkonsistenter Transaktionsdaten**

---

## Hintergrund
Dieses **SQL-Query** war ein **kritischer Bestandteil** eines größeren **PHP-Plugins**, das ich während meiner Umschulung zum Anwendungsentwickler (2023–2025) im Praktikum entwickelte.
**Kurz vor der Abgabe** trat ein schwerwiegender Bug auf:
- **Transaktionsdaten** (Wallet-Guthaben + Bezahlvorgänge) stimmten **nicht mit den Bestelldaten** überein.
- **Ursache:** Ein Fehler in der **Fremdsoftware (Kassensystem, Dart-basiert)**, auf deren Quellcode ich **keinen Zugriff** hatte.
- **Rahmenbedingungen:**
  - **Keine Möglichkeit, zu Hause weiterzuarbeiten** (Datenschutzbestimmungen).
  - **Begrenzte Zeit** (nur wenige Stunden/Woche im Praktikum für Programmierung).
  - **Unklare Prüfungsanforderungen** → Die Lösung musste **sauber, dokumentierbar und risikoarm** sein.

**→ Das SQL-Query war der Kern der Workaround-Lösung, um die Daten für die Abrechnung zu korrigieren.**

---

## Problemanalyse
### 1. Fehlersuche
- **Erste Vermutung:** Fehler lag in meinem Plugin → **Kleinen Bug behoben**, aber das Hauptproblem blieb.
- **Systematische Eingrenzung:**
  - **Live-Daten** des Kassensystems mit **WooCommerce-DB-Tabellen** abgeglichen (monatweise).
  - **WordPress-Debug-Logs** und **Plugin-Interaktionen** analysiert.
  - **Ergebnis:** Der Fehler entstand durch eine **Kombination aus fehlerhafter Wallet-Guthaben-Generierung** und **Bezahlvorgang** in der Fremdsoftware.

### 2. Herausforderungen
- **Kein Zugriff auf die Fremdsoftware** (Dart, unbekannte Codebase).
- **Kein Home-Office** → **Begrenzte Arbeitszeit** im Praktikum.
- **Prüfungsdruck** → Lösung musste **funktionieren, aber auch sauber dokumentiert** sein.

---

## Lösung: SQL-Workaround
Da ein direkter Fix in der Fremdsoftware **nicht möglich** war, entwickelte ich dieses **SQL-Query**, das:
1. **Inkonsistente Transaktions-IDs** aus den fehlerhaften Wallet-Daten extrahiert (via `SUBSTRING`-Logik).
2. **Alle relevanten Bestellinformationen** (Produkte, Preise, Kunden-IDs) in einem **strukturierten JSON-Format** ausgibt.
3. **Valide Abrechnungsdaten** liefert – **ohne die Fremdsoftware zu ändern**.

### Wichtige technische Details
- **`SUBSTRING`-Hacks**: Notwendig, um **Wallet-Transaktions-IDs** aus den fehlerhaften Daten zu extrahieren.
- **`GROUP_CONCAT` + JSON**: Bereitet Produktdetails **maschinenlesbar** auf (für weitere Verarbeitung).
- **Performance**: Keine Optimierung für große Datenmengen (war für den Prüfungskontext ausreichend).

**→ Das Query war Teil einer größeren PHP-Lösung, die den Bug umging und valide Daten für die Prüfung lieferte.**

---

## Lessons Learned
1. **Systematische Fehlersuche ist entscheidend**:
   - **Logs und Live-Daten** sind essenziell, um Bugs in Fremdsystemen zu lokalisieren.
   - **Annahmen hinterfragen** ("Der Fehler liegt in meinem Code" war falsch).

2. **Pragmatismus > Perfektion**:
   - Unter Zeitdruck ist eine **funktionierende Lösung** wichtiger als ein "perfekter" Fix.
   - **Risikomanagement**: Lieber einen **sauberen Workaround** bauen, als unsichere Änderungen an Fremdsoftware vorzunehmen.

3. **Dokumentation und Struktur zählen**:
   - Selbst unter Zeitdruck lohnt sich **lesbarer Code** – besonders in Prüfungssituationen.

---

## Dateien im Repository
   Datei               | Beschreibung                                                                 |
 |---------------------|-----------------------------------------------------------------------------|
 | `sql_solution.sql` | Das SQL-Query zur Korrektur der Transaktionsdaten (Kern der Workaround-Lösung). |
 | `README.md`         | Diese Datei – Erklärung des Hintergrunds und der technischen Lösung.      |

---

## Lizenz
MIT
