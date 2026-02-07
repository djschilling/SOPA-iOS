# Hybrid UI Struktur (UIKit/SwiftUI + SpriteKit)

Ziel: Menüs/Settings/Credits einfacher (Text, Accessibility, Layout) und Spiel weiterhin in SpriteKit.

## Grundidee
- **Game** bleibt in `SKView`/`SKScene` (Gameplay, In-Game HUD, Gesten).
- **Nicht-Spiel-Screens** werden als UIKit/SwiftUI-ViewController umgesetzt.
- `GameViewController` bleibt Entry für SpriteKit und kann von UI-Screens präsentiert werden.

## Minimal-invasive Struktur
1. **RootContainerViewController**
   - Verwaltet Navigation (z.B. `UINavigationController`).
   - Startet im `MenuViewController` (UIKit/SwiftUI).

2. **MenuViewController**
   - Buttons: Level Mode, Just Play, Tutorial, Credits, Settings.
   - Ruft `GameViewController` für Spiel-Modus auf.

3. **GameViewController**
   - Hält `SKView` und `StoryService`.
   - Baut `ResourcesManager` wie bisher.
   - Startet gewünschte Szene (Level/JustPlay).

4. **Weitere UI-Screens**
   - `CreditsViewController`, `SettingsViewController`, `TutorialViewController`.
   - Über NavigationController push/pop.

## Varianten für SwiftUI
- `UIHostingController` für Menü/Settings.
- `GameViewController` als UIKit-VC bleibt erhalten.
- Bridging via `UIViewControllerRepresentable` möglich, aber nicht nötig.

## Vorteile
- Besseres Text-Layout, Accessibility, Dynamic Type.
- Einfachere Formular-UI (Settings), Credits, Onboarding.
- Spiel bleibt performant und unangetastet.

## Risiken / Aufwand
- Übergänge zwischen UIKit und SpriteKit müssen sauber sein (StatusBar, Rotation, Audio).
- Zwei UI-Technologien parallel (SpriteKit + UIKit/SwiftUI).

## Empfehlung für SOPA
- **Kurzfristig**: Credits/Settings als UIKit/SwiftUI.
- **Mittelfristig**: Menü ebenfalls in UIKit/SwiftUI.
- Spiel-Szenen bleiben wie sie sind.

## Nächster Schritt (optional)
- Prototyp für `MenuViewController` erstellen und SpriteKit-Flow über einen Button starten.

