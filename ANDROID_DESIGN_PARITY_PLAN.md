# iOS ↔ Android Design-Parität – Aufgabenplan

Ziel: Das aktuelle **Android-Design** (siehe `sopa-android/pr/dev-screenshots/`) auf iOS
übernehmen. Grundlage dieses Plans ist ein Vergleich der 7 Android-Referenz-Screens mit
dem aktuellen iOS-Zustand (Branch `backup/ios-ui-level-overview-2026-02-25`).

Die iOS-Screens wurden **live im Simulator** (iPhone 17 Pro, iOS 26.5) per idb erfasst und
mit den Android-Vorlagen verglichen. Ausnahmen: „Level Complete" und der JustPlay-Zwischen-
Score erscheinen nur nach gelöstem Puzzle und wurden über den Quellcode abgeglichen.

## Statusüberblick pro Screen

| Screen | iOS-Datei | Status | Kernabweichung zu Android |
|---|---|---|---|
| Hauptmenü | `StartMenuScene.swift` | 🟢 fast fertig | Menüpunkt-Label + Social-Icons; kein Settings-Screen |
| Level-Auswahl | `LevelChoiceScene` + `LevelButtonArea` + `LevelSelectButton` | 🟢 (live bestätigt) | fehlender Tutorial-Einstieg |
| Level-Mode Spiel | `LevelModeGameScene.swift` | 🟢 (live bestätigt) | Back-Button (Android hat keinen) |
| Level Complete | `LevelModeScoreScene.swift` | 🟢 (P2 erledigt) | Wording + Play-Icon angepasst |
| Just-Play Spiel | `JustPlayGameScene.swift` (+ Basis `GameScene`) | 🟢 (P1 erledigt) | – (schwarz + Android-HUD) |
| Just-Play Highscore | `JustPlayLostScene` (in `JustPlayGameScene.swift`) | 🟢 (P2 erledigt) | Farbbalken + „Share Score" ergänzt |
| Tutorial | `TutorialScene.swift` / `TutorialGameScene.swift` | 🟢 (P2 erledigt) | visuelle Android-Screens; Einstiegspunkt offen (P3) |
| Credits | `CreditsScene.swift` | 🟢 (kein Referenz-Screenshot) | – |

Grundursache vieler roter Punkte: Die Basis-Klasse `GameScene` (`SOPA/view/GameScene.swift:33`)
setzt weiterhin den **warmen braunen** Hintergrund und ein altes Inline-HUD
(„Optimum: N", „Moves:", „N. Level"). `LevelModeGameScene` überschreibt beides bereits
Android-konform – `JustPlayGameScene` und die Score-Szenen tun das noch nicht.

---

## P1 – Hintergrund & Theme vereinheitlichen (schnelle, hochwirksame Fixes)

Android nutzt durchgängig **Schwarz** als Hintergrund. Auf iOS sind noch braun:
`LevelModeScoreScene`, `JustPlayScoreScene`, `JustPlayLostScene`, `TutorialScene` sowie die
Basis `GameScene` (→ trifft `JustPlayGameScene` und `TutorialGameScene`).

- [x] `GameScene` Default-Hintergrund auf schwarz umgestellt (`GameScene.swift`)
- [x] `LevelModeScoreScene` Hintergrund schwarz
- [x] `JustPlayScoreScene` + `JustPlayLostScene` Hintergrund schwarz
- [x] `TutorialScene` Hintergrund schwarz
- [ ] Toten braunen `warmBackground`-Pfad in `SopaTheme` später entfernen

## P1 – Just-Play Spiel-HUD an Android angleichen

Android zeigt oben „Min. Moves"/„Current Moves" (Label + große Zahl darunter) und unten
„Left Time" (große Zahl). iOS `JustPlayGameScene` erbt aktuell das alte Basis-HUD und
addiert nur „Left Time" → doppelte/inkonsistente Beschriftung.

- [x] In `JustPlayGameScene` `addStaticLabels()`/`addDynamicLabels()` überschrieben, analog
      zu `LevelModeGameScene` (Impact-Font, Label + große Zahl)
- [x] „Left Time" ins gleiche Layout gebracht (Label oben, große Zahl darunter, unten links)
- [ ] Prüfen, ob das rote Warn-Overlay bei ≤5 s dem Android-Verhalten entspricht

Live bestätigt (idb): JustPlay zeigt jetzt schwarz „Min. Moves / Current Moves" oben und
„Left Time" unten links, Restart unten rechts – wie Android.

## P1 – Safe-Area / Notch (weitgehend erledigt)

Live-Befund war: im JustPlay ragte der „1. Level"-Titel (altes Basis-HUD) in die
**Dynamic Island**, und die Spiel-Buttons überlappten die Labels.

- [x] Ursache behoben durch den JustPlay-HUD-Umbau (kein Level-Titel oben mehr) und die
      manuelle Button-Positionierung (Restart unten rechts, minimaler Back oben links)
- [ ] Optional: Top-Labels zusätzlich an Safe-Area-Insets ausrichten (statt `size.height`),
      auf mehreren iPhone-Größen gegenprüfen

Hinweis: Der große Leerraum **unter** dem Spielfeld ist **kein** Parität-Fehler –
Android platziert das Feld ebenfalls im oberen Bereich (`FIELD_SART_FROM_TOP = 0.2`,
`GameFieldNode.swift:18`), der untere Bereich trägt das HUD. `GameFieldNode` bleibt
daher unverändert; eine Zentrierung würde von Android *wegführen*.

Zusatzbefund: `IPadProportionSet` ist nur eine leere Unterklasse von `IPhone6Proportionset`
(`IPadProportionSet.swift`), also faktisch identisch – die frühere „iPad-hardcoded"-Sorge
ist gegenstandslos. Positionswerte für das Spiel-HUD kommen aus `ProportionSet`, werden aber
in Level-Mode/JustPlay inzwischen durch absolute Layouts überschrieben.

## P2 – Level Complete an Android angleichen

Android: **schwarzer** Hintergrund, Titel „N. Level Complete", „Your moves: X",
„Moves for 3 Stars: Y", 3 goldene Sterne, unten 3 weiße Kreis-Buttons (Grid / Restart / Play).

- [x] Hintergrund schwarz (P1)
- [x] Titel-Wording auf „N. Level Complete"
- [x] Untertitel „Moves for 3 Stars: N"
- [x] „Next"-Button: gefülltes Play-Dreieck (`play.fill`)
- [ ] Optional: Titel-Font/Größe/links-Ausrichtung noch näher an Android (aktuell zentriert, Optima)
- [ ] Sterne-Optik gegen Android prüfen (`star_score`/`starSW_score`)

## P2 – Just-Play Highscore an Android angleichen

Android: schwarzer Hintergrund, Titel „New Highscore", **blauer Balken** „Score: N",
**gelber Balken** „Level: N", unten 3 Kreis-Buttons: Zurück-Pfeil, Restart, **„SHARE SCORE"**.

- [x] Hintergrund schwarz (P1)
- [x] Score/Level als farbige Balken (blau/gelb) statt reinem Text
- [x] **„SHARE SCORE"-Button ergänzt** (neuer `makeCircleTextButtonTexture`)
- [x] Button-Set an Android angeglichen (Zurück-Pfeil / Restart / Share)
- [x] „Reached Level"/„Highscore"-Klartextzeilen für Parität entfernt (Konfetti bleibt als iOS-Extra bei neuem Highscore)

## P2 – Tutorial neu aufbauen (anderes Konzept)

Android-Tutorial = **visueller** 2-Screen-Ablauf: Titel „Tutorial" + „Click to see next info",
ein Spielfeld-Grid mit grünem/rotem Gate und blauen Röhren, unten farbig hervorgehobener
Erklärtext („Connect the **GREEN** and the **RED** gate, using the **BLUE** tubes. Use all tubes.").
Wird in Android **aus der Level-Auswahl** gestartet (`loadTutorialSceneFromLevelChoiceScene`)
bzw. beim Erststart, nicht aus dem Menü.

- [x] Tutorial als visuelle Screens umgebaut – Android-Artwork nach
      `Assets.xcassets/tutorial` importiert (first/second Screen A+B, Let's Go)
- [x] Farbige Keywords (GREEN/RED/BLUE) – über die importierten Screens abgedeckt
- [x] 2-Screen-Ablauf + „Lets GO" → interaktives Tutorial-Level (analog Android)
- [ ] Einstiegspunkt: Android startet aus der Level-Auswahl / beim Erststart; iOS startet
      aktuell aus dem Menü (hängt an der SETTINGS/TUTORIAL-Entscheidung, siehe P3)

## P3 – Menü: Settings vs. Tutorial klären + Social-Icons

Android-Menü: **LEVEL MODE / JUST PLAY / SETTINGS / CREDITS** (kein Tutorial-Eintrag).
Der Settings-Screen in Android ist ein **Musik-Mute-Toggle** (`SettingsService`: `MUTE`,
`MY_FIRST_TIME`). Tutorial läuft über Level-Auswahl/Erststart.

iOS aktuell: der 3. Menüpunkt wurde von „SETTINGS" auf **„TUTORIAL"** umbenannt und öffnet
das (Text-)Tutorial. Es gibt auf iOS **keinerlei Audio/Musik** und keinen Settings-Screen.

- [ ] Entscheidung: Menü an Android angleichen (SETTINGS statt TUTORIAL) – setzt Settings-Screen
      + Audio voraus – **oder** iOS bewusst mit TUTORIAL-Eintrag abweichen lassen
- [ ] Social-Icons an Android angleichen: Share-Glyph + klassischer Twitter-Vogel
      (iOS nutzt SF-Symbols `point.3.connected.trianglepath.dotted` / `paperplane.fill`,
      `StartMenuScene.swift:54/61`)

## P3 – Audio/Musik + Settings (Voraussetzung für „SETTINGS")

Android hat Menü-Musik und einen Mute-Toggle; iOS hat aktuell **kein Audio**.

- [ ] Musik-Playback (z. B. `AVAudioPlayer`) + Mute-Persistenz (analog `SettingsService`)
- [ ] Settings-Szene mit Mute/Unmute-Button (schwarz, Neon-Stil)
- [ ] Erststart-Logik (`isFirstTime`) für automatischen Tutorial-Aufruf

---

## Offene Punkte / zu verifizieren

- Android-Credits-Screen liegt nicht als Screenshot vor → Parität nicht abgleichbar.
- Ob Android im Just-Play einen Zwischen-Score-Screen pro Level hat (iOS `JustPlayScoreScene`),
  ist aus den Screenshots nicht ersichtlich – gegen die Android-App verifizieren.

## Empfohlene Reihenfolge

1. ~~**P1** – Hintergründe schwarz + Just-Play-HUD~~ ✅ erledigt
2. ~~**P2** – Level Complete, Just-Play Highscore, Tutorial-Neuaufbau~~ ✅ erledigt
3. **P3** – Menü-Entscheidung (SETTINGS vs. TUTORIAL) + Tutorial-Einstiegspunkt,
   Audio/Settings, Social-Icons
