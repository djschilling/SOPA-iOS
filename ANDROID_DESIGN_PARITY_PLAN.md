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
| Level-Mode Spiel | `LevelModeGameScene.swift` | 🟢 (live bestätigt) | Back-Button (Android hat keinen); Spielfeld sitzt zu weit oben |
| Level Complete | `LevelModeScoreScene.swift` | 🔴 altes Design | brauner Hintergrund, Wording, Button-Icon |
| Just-Play Spiel | `JustPlayGameScene.swift` (+ Basis `GameScene`) | 🔴 altes Design | brauner Hintergrund, kaputtes HUD, Notch-Kollision |
| Just-Play Highscore | `JustPlayLostScene` (in `JustPlayGameScene.swift`) | 🔴 altes Design | brauner Hintergrund, keine Farbbalken, kein „Share Score" |
| Tutorial | `TutorialScene.swift` / `TutorialGameScene.swift` | 🔴 anderes Konzept | Text-Seiten statt visuellem Grid; brauner BG; Einstiegspunkt |
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

- [ ] `GameScene` Default-Hintergrund auf `SopaTheme.blackBackground` umstellen (`GameScene.swift:33`)
- [ ] `LevelModeScoreScene` Hintergrund auf schwarz (`LevelModeScoreScene.swift:14/21`)
- [ ] `JustPlayScoreScene` + `JustPlayLostScene` Hintergrund auf schwarz (`JustPlayGameScene.swift:364/498`)
- [ ] `TutorialScene` Hintergrund auf schwarz (`TutorialScene.swift:16`)
- [ ] Toten braunen `warmBackground`-Pfad nach der Umstellung entfernen bzw. dokumentieren

## P1 – Just-Play Spiel-HUD an Android angleichen

Android zeigt oben „Min. Moves"/„Current Moves" (Label + große Zahl darunter) und unten
„Left Time" (große Zahl). iOS `JustPlayGameScene` erbt aktuell das alte Basis-HUD und
addiert nur „Left Time" → doppelte/inkonsistente Beschriftung.

- [ ] In `JustPlayGameScene` `addStaticLabels()` überschreiben, analog zu
      `LevelModeGameScene.addStaticLabels()` (Impact-Font, Label + große Zahl)
- [ ] „Left Time" ins gleiche Layout bringen (große Zahl unter Label)
- [ ] Prüfen, ob das rote Warn-Overlay bei ≤5 s dem Android-Verhalten entspricht

Live bestätigt: Aktuell zeigt der JustPlay-Screen oben „1. Level" (kollidiert mit der
Dynamic Island) und unten gestapelt „Left Time / Moves: / Optimum:" – also das alte
Basis-HUD plus Timer, nicht Androids Layout.

## P1 – Safe-Area & Spielfeld-Positionierung (Layout)

Live-Befund: Titel/Back-Button ragen im JustPlay/Tutorial in die **Dynamic Island**; das
Level-Mode-Spielfeld sitzt zu weit oben, unten bleibt großer Leerraum. Ursache ist v. a. das
hart verdrahtete `IPadProportionSet` (`StoryServiceImpl.swift:115`) auf iPhone-Geräten.

- [ ] Top-Elemente an den Safe-Area-Insets ausrichten (nicht an `size.height`)
- [ ] Spielfeld vertikal zentrieren / iPhone-taugliches `ProportionSet` wählen
- [ ] Auf mehreren iPhone-Größen gegenprüfen

## P2 – Level Complete an Android angleichen

Android: **schwarzer** Hintergrund, Titel „N. Level Complete", „Your moves: X",
„Moves for 3 Stars: Y", 3 goldene Sterne, unten 3 weiße Kreis-Buttons (Grid / Restart / Play).

- [ ] Hintergrund schwarz (siehe P1)
- [ ] Titel-Wording auf „N. Level Complete" + Font/Größe an Android angleichen
      (`LevelModeScoreScene.swift:49`, aktuell „Level N Complete", Optima statt Impact)
- [ ] Untertitel „3-star target: N" → „Moves for 3 Stars: N" (`:68`)
- [ ] „Next"-Button: Icon `chevron.right` → gefülltes Play-Dreieck (`:30`)
- [ ] Sterne-Optik gegen Android prüfen (`star_score`/`starSW_score`)

## P2 – Just-Play Highscore an Android angleichen

Android: schwarzer Hintergrund, Titel „New Highscore", **blauer Balken** „Score: N",
**gelber Balken** „Level: N", unten 3 Kreis-Buttons: Zurück-Pfeil, Restart, **„SHARE SCORE"**.

- [ ] Hintergrund schwarz (siehe P1)
- [ ] Score/Level als farbige Balken (blau/gelb) statt reinem Text (`JustPlayGameScene.swift:546–560`)
- [ ] **„SHARE SCORE"-Button ergänzen** (fehlt komplett) – Share-Flow wie im Menü nutzen
- [ ] Button-Set an Android angleichen (Zurück-Pfeil statt `chevron.left`)
- [ ] Entscheiden: Konfetti/„Highscore:"-Zeile beibehalten (iOS-Extra) oder für Parität entfernen

## P2 – Tutorial neu aufbauen (anderes Konzept)

Android-Tutorial = **visueller** 2-Screen-Ablauf: Titel „Tutorial" + „Click to see next info",
ein Spielfeld-Grid mit grünem/rotem Gate und blauen Röhren, unten farbig hervorgehobener
Erklärtext („Connect the **GREEN** and the **RED** gate, using the **BLUE** tubes. Use all tubes.").
Wird in Android **aus der Level-Auswahl** gestartet (`loadTutorialSceneFromLevelChoiceScene`)
bzw. beim Erststart, nicht aus dem Menü.

iOS aktuell: reines **Text-Tutorial** (Seiten „Goal"/„How It Works"/„Try It Now") mit
„Let's Go"-Button, brauner Hintergrund, gestartet aus dem Menü.

- [ ] Tutorial als visuellen Screen mit Spielfeld-Grid + farbigem Erklärtext umbauen
- [ ] Farbige Keywords (GREEN/RED/BLUE) im Text
- [ ] Einstiegspunkt an Android angleichen: aus der Level-Auswahl (+ optional Erststart)
- [ ] Übergänge Tutorial → erstes Level bzw. → Level-Auswahl analog Android

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

1. **P1** – Hintergründe schwarz + Just-Play-HUD (kleiner Aufwand, größter sichtbarer Effekt)
2. **P2** – Level Complete, Just-Play Highscore, Tutorial-Neuaufbau
3. **P3** – Menü-Entscheidung, Audio/Settings, Social-Icons
