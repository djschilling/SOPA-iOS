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

    var currentView: SKView
    let size: CGSize
    let levelService: LevelService
    let proportionSet: ProportionSet

    init(size: CGSize, levelService: LevelService, skView: SKView) {
        self.size = size
        self.levelService = levelService
        currentView = skView
        skView.ignoresSiblingOrder = true
        skView.isMultipleTouchEnabled = false;
        //proportionSet = IPhone6Proportionset(size: size)
        proportionSet = IPadProportionSet(size: size)

    }

    func loadLevelCoiceScene() {
        let levelChoiceScene = LevelChoiceScene(size: size, levelService: levelService)
        levelChoiceScene.scaleMode = .resizeFill
        currentView.presentScene(levelChoiceScene)
    }
    
    func loadLevelCoiceSceneFromLevelModeScene() {
        let levelChoiceScene = LevelChoiceScene(size: size, levelService: levelService)
        let transition = SKTransition.push(with: .up, duration: 0.5)
        currentView.presentScene(levelChoiceScene, transition: transition)
    }
    
    func loadLevelModeGameSceneFromChoiceScene(levelId: Int) {
        let levelModeGameScene = LevelModeGameScene(size: size, proportionSet: proportionSet, level: levelService.getLevelById(id: levelId)!)
        let transition = SKTransition.push(with: .down, duration: 0.5)
        currentView.presentScene(levelModeGameScene, transition: transition)
    }
    
    func reloadLevelModeGameScene(levelId: Int) {
        let levelModeGameScene = LevelModeGameScene(size:
            size, proportionSet: proportionSet, level: levelService.getLevelById(id: levelId)!)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        currentView.presentScene(levelModeGameScene, transition: transition)
    }
    
    func loadNextLevelModeGameScene(levelId: Int) {
        let levelModeGameScene = LevelModeGameScene(size: size, proportionSet: proportionSet, level: levelService.getLevelById(id: levelId)!)
        let transition = SKTransition.push(with: .left, duration: 0.5)
        currentView.presentScene(levelModeGameScene, transition: transition)
    }
    
}
