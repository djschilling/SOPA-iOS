# SOPA iOS Refactor Plan (Incremental)

Ziel: Architektur sauberer machen, ohne Funktionsumfang zu brechen. Jede Stufe ist klein genug, um separat review- und testbar zu sein.

## Leitlinien
- Keine UI-Änderungen nötig, Fokus liegt auf Struktur/Testbarkeit.
- Verhalten muss identisch bleiben (besonders Unlocking-Regel: gelöst + 1).
- Nach jeder Stufe laufen die Tests.

## Phase 0: Baseline & Sicherungen
- Tests ausführen, Status dokumentieren.
- Optional: Screenshots/Video der wichtigsten Flows (Startmenu → Level → Score → Back, Startmenu → JustPlay → Lost/Score).

## Phase 1: Persistence sauber kapseln
**Ziel:** CoreData nicht mehr direkt im `LevelService`/`AppDelegate` nutzen.

Schritte:
- Neuer Typ `PersistenceController` mit `NSPersistentContainer`.
- `LevelInfoDataSource` erhält `NSManagedObjectContext` über Init (keine AppDelegate-Abhängigkeit mehr).
- `LevelServiceImpl` bekommt `LevelInfoDataSource` per Init.

Resultat:
- Persistenz ist isoliert, Testbarkeit erhöht, `AppDelegate` wird entlastet.

## Phase 2: Dependency Injection statt Singleton (soft)
**Ziel:** `ResourcesManager` zurückdrängen, ohne großen Bruch.

Schritte:
- `ResourcesManager` bleibt, aber wird intern nur als DI-Root genutzt.
- Szenen erhalten Services via Init-Parameter, nicht via `ResourcesManager.getInstance()`.
- `StoryServiceImpl` erstellt Szenen und injiziert `LevelService`/`StoryService`.

Resultat:
- Weniger versteckte Abhängigkeiten, klare Objektbeziehungen.

## Phase 3: SceneFactory einführen
**Ziel:** `StoryServiceImpl` entlasten und Szenen-Setup konsistent halten.

Schritte:
- Neues Protokoll `SceneFactory`.
- Implementierung erstellt alle Szenen inkl. Abhängigkeiten.
- `StoryServiceImpl` nutzt nur noch Factory + SKView.

Resultat:
- Navigation bleibt zentral, Erzeugung wird modular.

## Phase 4: Game-Core trennen
**Ziel:** Spiel-Logik unabhängig vom Rendering.

Schritte:
- `GameServiceImpl` erhält reine Datenstrukturen und keine SpriteKit-Abhängigkeiten.
- `GameFieldNode` und `GameScene` nutzen nur noch die Service-API.
- Jede SpriteKit-UI arbeitet über DTOs/State.

Resultat:
- Logik bleibt testbar und UI wird schlanker.

## Phase 5: JustPlay und LevelMode parallelisieren
**Ziel:** Gemeinsame Mechanik zusammenfassen, Modi klar trennen.

Schritte:
- Gemeinsame Score/Timer-Regeln in eigene Services ziehen.
- LevelMode/JustPlay bekommen jeweils eigene ModeController.

Resultat:
- Weniger Code-Duplikate, klarere Verantwortung.

## Phase 6: Cleanups & Tests
- Tests ergänzen (z.B. SceneFactory-Integration, LevelService ohne CoreData Host).
- Entfernte Singletons und direkte AppDelegate-Zugriffe löschen.
- Dokumentation kurz aktualisieren.

## Teststrategie (pro Phase)
- `xcodebuild -project SOPA.xcodeproj -scheme SOPA -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' test`
- Kritische Flows manuell prüfen:
  - Startmenu → LevelChoice → Game → Score → Back
  - Startmenu → JustPlay → Lost/Score

