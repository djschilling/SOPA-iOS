//
//  StoryServiceImpl.swift
//  SOPA
//
//  Created by Raphael Schilling on 05.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

class StoryServiceImpl: StoryService {

    //var currentScene: SKScene?
    var currentView: SKView
    let size: CGSize
    let levelService: LevelService

    init(size: CGSize, levelService: LevelService, skView: SKView) {
        self.size = size
        self.levelService = levelService
        currentView = skView
       // skView.showsFPS = true
       // skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
    }

    func loadLevelCoiceScene() {
        let levelChoiceScene = LevelChoiceScene(size: size, levelService: levelService)
        levelChoiceScene.scaleMode = .resizeFill
        currentView.presentScene(levelChoiceScene)

    }

    func loadLevelModeGameScene(levelId: Int) {
        let levelModeGameScene = LevelModeGameScene(size: size, level: levelService.getLevelById(id: levelId)!)
        let transition = SKTransition.push(with: .left, duration: 0.5)
        currentView.presentScene(levelModeGameScene, transition: transition)
    }

    func loadLevelModeScoreScene(levelResult: LevelResult) {
        let levelModeScoreScene = LevelModeScoreScene(size: size, levelResult: levelResult)
        currentView.presentScene(levelModeScoreScene)
    }


}
