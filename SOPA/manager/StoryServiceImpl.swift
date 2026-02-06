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
    private var justPlayService: JustPlayService?
    
    func loadStartMenuScene() {
        let startMenuScene = StartMenuScene(size: size)
        startMenuScene.scaleMode = .resizeFill
        currentView.presentScene(startMenuScene)
    }

    func loadJustPlaySceneFromJustPlayScene(timeBasedGameService: TimeBasedGameService, justPlayLevel: JustPlayLevel) {
        guard let currentJustPlayService = justPlayService else {
            loadJustPlaySceneFromMenuScene()
            return
        }
        let justPlayGameScene = JustPlayGameScene(size: size, proportionSet: proportionSet, justPlayLevel: justPlayLevel, justPlayService: currentJustPlayService, timeBasedGameService: timeBasedGameService)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        currentView.presentScene(justPlayGameScene, transition: transition)
    }
    
    func loadJustPlayScoreSceneFromJustPlayScene(justPlayLevelResult: JustPlayLevelResult) {
        guard let currentJustPlayService = justPlayService else {
            loadStartMenuScene()
            return
        }
        let justPlayResult = currentJustPlayService.calculateResult(justPlayLevelResult: justPlayLevelResult)
        let justPlayScoreScene = JustPlayScoreScene(size: size, proportionSet: proportionSet, justPlayResult: justPlayResult)
        let transition = SKTransition.push(with: .left, duration: 0.5)
        currentView.presentScene(justPlayScoreScene, transition: transition)
    }
    
    func loadJustPlayLostSceneFromJustPlayScene(justPlayLevelResult: JustPlayLevelResult) {
        guard let currentJustPlayService = justPlayService else {
            loadStartMenuScene()
            return
        }
        let justPlayResult = currentJustPlayService.calculateResult(justPlayLevelResult: justPlayLevelResult)
        let justPlayLostScene = JustPlayLostScene(size: size, proportionSet: proportionSet, justPlayResult: justPlayResult)
        let transition = SKTransition.push(with: .left, duration: 0.5)
        currentView.presentScene(justPlayLostScene, transition: transition)
    }
    
    func loadNextJustPlayGameScene() {
        guard let currentJustPlayService = justPlayService else {
            loadJustPlaySceneFromMenuScene()
            return
        }
        let justPlayLevel = currentJustPlayService.getNextLevel()
        let timeBasedGameService = TimeBasedGameServiceImpl(remainingTime: justPlayLevel.leftTime)
        timeBasedGameService.start()
        let justPlayScene = JustPlayGameScene(size: size, proportionSet: proportionSet, justPlayLevel: justPlayLevel, justPlayService: currentJustPlayService, timeBasedGameService: timeBasedGameService)
        let transition = SKTransition.push(with: .left, duration: 0.5)
        currentView.presentScene(justPlayScene, transition: transition)
    }
    
    func reloadJustPlayGameScene(level: Level) {
        if justPlayService == nil {
            justPlayService = JustPlayServiceImpl()
        }
        let timeBasedGameService = TimeBasedGameServiceImpl(remainingTime: 10)
        timeBasedGameService.start()
        let justPlayGameScene = JustPlayGameScene(size: size, proportionSet: proportionSet, justPlayLevel: JustPlayLevel(leftTime: 10, level: level), justPlayService: justPlayService!, timeBasedGameService: timeBasedGameService)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        currentView.presentScene(justPlayGameScene, transition: transition)
    }
    
    func loadJustPlaySceneFromMenuScene() {
        let currentJustPlayService = JustPlayServiceImpl()
        justPlayService = currentJustPlayService
        let justPlayLevel = currentJustPlayService.getNextLevel()
        let timeBasedGameService = TimeBasedGameServiceImpl(remainingTime: justPlayLevel.leftTime)
        timeBasedGameService.start()
        let justPlayScene = JustPlayGameScene(size: size, proportionSet: proportionSet, justPlayLevel: justPlayLevel, justPlayService: currentJustPlayService, timeBasedGameService: timeBasedGameService)
        let transition = SKTransition.push(with: .down, duration: 0.5)
        currentView.presentScene(justPlayScene, transition: transition)
    }
    
    
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
    
    func loadLevelModeScoreSceneFromLevelModeScene(levelResult: LevelResult) {
        let levelModeScoreScene = LevelModeScoreScene(size: size, levelResult: levelResult)
        let transition = SKTransition.push(with: .left, duration: 0.35)
        currentView.presentScene(levelModeScoreScene, transition: transition)
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
