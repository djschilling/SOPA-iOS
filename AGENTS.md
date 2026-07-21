# AGENTS.md - SOPA iOS

## Scope
Diese Datei gilt fuer dieses Repo (`sopa-ios`).

## Projektziel
SOPA iOS soll in der **Spiellogik** Android-Verhalten erreichen (UI darf abweichen).

## Repo-Setup
- iOS-Projekt: `SOPA.xcodeproj`
- Scheme: `SOPA`
- Test-Target: `SOPATests`
- Deployment Target: iOS 18.0

## Build und Test
- Build:
  - `xcodebuild -project SOPA.xcodeproj -scheme SOPA -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- Voller Testlauf:
  - `xcodebuild -project SOPA.xcodeproj -scheme SOPA -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test`
- Hinweis: Simulator-Namen mit `xcrun simctl list devices available` prüfen (der Name variiert je nach installierter Xcode-Version; aktuell iOS 26.5, iPhone 17 Pro).

## App im Simulator ansehen (visuelle Verifikation mit idb)
Für UI-/Design-Arbeit lässt sich die App im Simulator fernsteuern (Taps/Swipes), um Screens
gegen das Android-Design abzugleichen. Setup ist installiert (siehe unten bei Problemen).

Ablauf (Beispiel iPhone 17 Pro):
```bash
export PATH="$HOME/.local/bin:$PATH"          # idb-CLI liegt in ~/.local/bin (pipx)
UDID=$(xcrun simctl list devices booted | grep -oE '[0-9A-F-]{36}' | head -1)
BUNDLE=de.davidschilling.SOPA

xcrun simctl boot "iPhone 17 Pro" 2>/dev/null   # falls nicht gebootet
xcrun simctl install "$UDID" "$(find ~/Library/Developer/Xcode/DerivedData/SOPA-*/Build/Products/Debug-iphonesimulator -maxdepth 1 -name SOPA.app | head -1)"
xcrun simctl launch "$UDID" "$BUNDLE"

idb connect "$UDID"
idb ui tap  --udid "$UDID" <x> <y>              # Koordinaten in POINTS (iPhone 17 Pro = 402x874)
idb ui swipe --udid "$UDID" <x1> <y1> <x2> <y2> # z.B. Reihe/Spalte im Spielfeld schieben
xcrun simctl io "$UDID" screenshot out.png       # Screenshot zum Vergleich
```
Menü-Tap-Punkte (Points, iPhone 17 Pro): LEVEL MODE ≈ (201,345), JUST PLAY ≈ (201,439),
TUTORIAL ≈ (201,535), CREDITS ≈ (201,629).

Grenzen: Screens hinter Gameplay (Level Complete, JustPlay-Score) erscheinen erst nach
gelöstem Puzzle und lassen sich per Blind-Swipe kaum reproduzierbar erreichen – dafür
Quellcode heranziehen. JustPlay-Game-Over erreicht man einfach, indem man den Timer
ablaufen lässt (~12 s ohne Lösung).

### idb-Setup (falls nicht vorhanden)
- `brew install facebook/fb/idb-companion`
- `pipx install --python /opt/homebrew/bin/python3.12 fb-idb`
  (**muss Python 3.12 sein**, nicht 3.14 – fb-idb 1.1.7 crasht auf 3.14 wegen entferntem
  `asyncio.get_event_loop()`).
- Die Meldung `objc[...] Class FBProcess is implemented in both ...` bei jedem Aufruf ist harmlos.

## Wichtige Dateien
- Produktplan: `IOS_PRODUCT_COMPLETION_PLAN.md`
- Navigation/Flow: `SOPA/manager/StoryServiceImpl.swift`
- JustPlay-Logik: `SOPA/JustPlay/JustPlayGameScene.swift`, `SOPA/model/game/*JustPlay*`
- Level/Unlocking: `SOPA/helper/LevelServiceImp.swift`
- Level-Content: `SOPA/levels/`

## Bekannte Stolpersteine
- **Tests in Xcode-Projekt eintragen**: neue Testdateien muessen in `SOPA.xcodeproj/project.pbxproj` als FileReference + BuildFile + Sources-Phase enthalten sein.
- **CoreData Klassenkonflikt im Testhost**: `LevelInfoMO`/`JustPlayResults` werden in App + Test-Bundle geladen. Tests sollten CoreData-kritische Pfade moeglichst vermeiden oder als reine Logiktests gebaut werden.
- **Asset-Warnung**: Doppelte Symbolauflosung fuer `restart` in Assets (`GeneratedAssetSymbols.swift` Warnung).

## Aktueller Teststatus (Stand)
- Erweiterte Tests vorhanden fuer:
  - JustPlay Score/Timer-Basislogik
  - JustPlay Highscore-Persistenz
  - Unlocking-Regel (highest solved + 1) als pure Logik
  - StarCalculator Grenzwerte
  - GameService-Verhalten bei bereits geloestem Puzzle
- Letzter gesamter Lauf: `19 tests, 0 failures`.

## Arbeitsregeln fuer Aenderungen
- Keine unbeabsichtigten Aenderungen ausserhalb dieses iOS-Projekts.
- Vor groesseren Refactorings immer erst `xcodebuild test` laufen lassen.
- Bei UI-Flows immer Ruecknavigation pruefen (Startmenu <-> Mode <-> Level/JustPlay).
- Unlocking-Regel beibehalten: freigeschaltet = geloest + 1.

## Offene Schwerpunkte (naechste sinnvolle Schritte)
- Settings (mind. Audio-Mute)
- Credits
- Tutorial/Onboarding
- Optional Loading-Transition
- Release-Haertung (Dev-Flags, Info.plist-Aufraeumen, Signing/Versionierung)
