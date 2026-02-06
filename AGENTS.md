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
  - `xcodebuild -project SOPA.xcodeproj -scheme SOPA -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' build`
- Voller Testlauf:
  - `xcodebuild -project SOPA.xcodeproj -scheme SOPA -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' test`

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
