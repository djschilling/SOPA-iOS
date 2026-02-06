//
//  StoryService.swift
//  SOPA
//
//  Created by Raphael Schilling on 05.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

protocol StoryService {
    func loadStartMenuScene()
    func loadLevelCoiceScene()
    func loadLevelCoiceSceneFromLevelModeScene()

    func loadCreditsSceneFromMenuScene()
    func loadTutorialSceneFromMenuScene()
    func loadTutorialGameSceneFromTutorialScene()

    func loadJustPlaySceneFromMenuScene()
    func loadJustPlaySceneFromJustPlayScene(timeBasedGameService: TimeBasedGameService, justPlayLevel: JustPlayLevel)
    func loadJustPlayScoreSceneFromJustPlayScene(justPlayLevelResult: JustPlayLevelResult)
    func loadJustPlayLostSceneFromJustPlayScene(justPlayLevelResult: JustPlayLevelResult)
    func loadNextJustPlayGameScene()
    func reloadJustPlayGameScene(level: Level)

    func loadLevelModeGameSceneFromChoiceScene(levelId: Int)
    func loadLevelModeScoreSceneFromLevelModeScene(levelResult: LevelResult)
    func reloadLevelModeGameScene(levelId: Int)
    func loadNextLevelModeGameScene(levelId: Int)
}
