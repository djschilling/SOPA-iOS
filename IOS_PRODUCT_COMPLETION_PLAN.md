# SOPA iOS – Produktfertigstellungsplan

## Ziel
Die iOS-Version soll sich in der **Spiellogik** wie die Android-Version verhalten (funktionale Parität), darf aber eine eigene UI/Navigation haben.

## Aktueller Stand (Kurz)
- iOS hat eine solide Basis für den Level-Mode.
- Android hat deutlich mehr vollständige Produktbausteine (u.a. JustPlay-System mit Zeit/Score, zusätzliche Flows/Szenen).
- iOS ist derzeit nicht release-ready als vollwertiges Pendant.

## Priorisierter Umsetzungsplan

### 1. JustPlay auf Android-Logik heben (höchste Priorität)
**Ziel:** Gleiches Gameplay-Verhalten wie Android in JustPlay.

**Fehlt auf iOS aktuell:**
- [x] Countdown-Timer pro Runde
- [x] Difficulty-/Levelsetting-Kurven über Fortschritt
- [x] Score-Berechnung und Zeitbonus-Mechanik
- [x] Game-Over- und Score-Screens
- [x] JustPlay-Highscore-Persistenz

**Umsetzung:**
- [x] `JustPlayService` (+ Implementierung) in iOS ergänzen
- [x] Zeitbasierten Game-Service ergänzen (analog Android-Verhalten)
- [x] JustPlay-Flow in `StoryService` erweitern (Score/Lost/Next)
- [x] Neue Szenen für Score/GameOver hinzufügen
- [x] CoreData-Entity `JustPlayResults` aktiv nutzen

**Abnahmekriterium:**
- [ ] Bei identischer Eingabe ergibt sich gleiches Zeit-/Score-Verhalten wie auf Android.

### 2. Content-Parität herstellen (100 Level)
**Ziel:** Identische Levelbasis wie Android.

**Aktuell:** iOS enthält nur 75 `.lv`-Level, Android 100.

**Umsetzung:**
- [x] Fehlende Level 76–100 nach iOS übernehmen
- [x] Reihenfolge/IDs und Freischaltlogik validieren

**Abnahmekriterium:**
- [x] iOS hat 100 Levels und korrektes sequentielles Unlocking.

### 3. Release-blockierende Endgame-Crashs beheben
**Ziel:** Kein Crash am Ende des letzten Levels.

**Risiko aktuell:**
- `levelId + 1` wird ohne Bounds-Check geladen/entsperrt.

**Umsetzung:**
- Bounds-Prüfung beim Unlock und beim Laden des nächsten Levels
- Letztes Level führt zu sauberem Abschlusszustand (z.B. Completion Scene)

**Abnahmekriterium:**
- Letztes Level ist stabil lösbar, kein Force-Unwrap-Crash.

### 4. Fehlende Produkt-Flows ergänzen
**Ziel:** Funktionsgleichwertige App-Flows wie Android.

**Android-seitig vorhanden, iOS-seitig unvollständig/fehlend:**
- [x] Hauptmenü
- [x] Credits
- [x] Tutorial/Onboarding
- [x] Levelmode-Completion
- [ ] Optional Loading-Übergang

**Umsetzung:**
- [x] Story-/Navigation auf iOS erweitern
- [x] Flows als eigene Szenen oder äquivalente iOS-Navigation umsetzen

**Abnahmekriterium:**
- [ ] Alle wesentlichen Modi/Zustände sind für Nutzer erreichbar und vollständig rücknavigierbar.

### 5. Release-Härtung (Dev/Debug entfernen)
**Ziel:** Produktionsreife Laufzeitkonfiguration.

**Umsetzung:**
- `DEVELOPER_MODE` standardmäßig deaktivieren
- Debug-Ausgaben/temporäre Buttons entfernen
- Auskommentierte Steuer-Elemente finalisieren

**Abnahmekriterium:**
- Kein Dev-only Verhalten in Release-Builds.

### 6. Stabilität erhöhen (fatalError in Runtimepfaden reduzieren)
**Ziel:** Robustes Fehlerverhalten statt App-Abbruch.

**Umsetzung:**
- Kritische `fatalError()` in Datenzugriff/State-Handling durch kontrollierte Fehlerpfade ersetzen
- Fehler protokollieren und Nutzerfluss erhalten, wo möglich

**Abnahmekriterium:**
- Typische Daten-/State-Fehler führen nicht zum sofortigen Crash.

### 7. Teststrategie auf Parität ausrichten
**Ziel:** Nachweisbare Gleichheit der Spiellogik Android vs iOS.

**Umsetzung:**
- Bestehende iOS-Tests aktualisieren (inkl. korrekter Level-Anzahl)
- Golden-Tests einführen für:
  - Shift-/Move-Verhalten
  - Solve-Check
  - Star-Berechnung
  - JustPlay-Zeit-/Score-Logik
- Optional: Vergleichsfixtures zwischen Android und iOS nutzen

**Abnahmekriterium:**
- Kritische Kernlogik ist automatisiert getestet und stabil reproduzierbar.

### 8. Technische Modernisierung für Store-Release
**Ziel:** Zeitgemäße iOS-Build-/Release-Basis.

**Umsetzung:**
- [x] Deployment-Target und Build-Einstellungen aktualisieren
- [ ] `Info.plist` auf aktuelle Anforderungen prüfen/aufräumen
- [ ] Signierung/Versionierung finalisieren

**Abnahmekriterium:**
- [ ] Sauberer Release-Build mit aktueller Toolchain und plausiblen Store-Metadaten.

## Empfohlene Reihenfolge
1. Crash-Fixes + 100-Level-Parität
2. JustPlay vollständig (Timer/Score/Lost/Score/Highscore)
3. Fehlende Flows (Menü/Tutorial/Credits/Completion)
4. Release-Härtung + Testausbau
5. Build-/Store-Modernisierung und finaler Release-Check

## Definition of Done
- iOS-Gameplay entspricht Android in der Spiellogik (Levelmode + JustPlay).
- 100 Level vollständig, Unlocking stabil.
- Keine bekannten Crashes in Standard-Flows.
- Alle relevanten Nutzerflüsse vollständig bedienbar.
- Testabdeckung für Kernlogik vorhanden und grün.
- Release-Build erfolgreich, produktionsreif.
