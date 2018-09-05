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
    
    var currentScene: SKScene?
    let size: CGSize
    let levelService: LevelService
    
    init(size: CGSize, levelService: LevelService, skView: SKView) {
        self.size = size
        self.levelService = levelService
        currentScene = LevelChoiceScene(size: size, levelService: levelService)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        currentScene?.scaleMode = .resizeFill
        skView.presentScene(currentScene)
    }
    func loadLevelCoiceScene() {
        if currentScene == nil {
            currentScene = LevelChoiceScene(size: size, levelService: levelService)
        }
    }
    
    func loadLevelModeGameScene(levelId: Int) {
        let levelModeGameScene = LevelModeGameScene(size: size, level: levelService.getLevelById(id: levelId)!)
        currentScene?.view?.presentScene(levelModeGameScene)
        currentScene = levelModeGameScene
    }
    
    
}
