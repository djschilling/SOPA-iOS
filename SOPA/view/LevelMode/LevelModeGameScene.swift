//
//  LevelModeGameScene.swift
//  SOPA
//
//  Created by Raphael Schilling on 23.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
class LevelModeGameScene: GameScene {
    var restartButton: SpriteButton?
    var levelChoiceButton: SpriteButton?
    var start: NSDate?
    override init(size: CGSize, proportionSet: ProportionSet, level: Level) {
        super.init(size: size, proportionSet: proportionSet, level: level)
        startCounter()
    }
    
    private func startCounter() {
        start = NSDate()
    }
    
    private func stopCounter() -> Double {
        let end = NSDate()
        let difference: Double = end.timeIntervalSince(start! as Date)
        print(difference)
        return difference
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func addButtons() {
        restartButton = SpriteButton(imageNamed: "restart", onClick: restartLevel)
        restartButton!.size.height = proportionSet.buttonSize()
        restartButton!.size.width = proportionSet.buttonSize()
        restartButton!.position = proportionSet.restartButtonPos()
        addChild(restartButton!)
        
        levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: loadLevelChoiceScene)
        levelChoiceButton!.size.height = proportionSet.levelChoiceSize()
        levelChoiceButton!.size.width = proportionSet.levelChoiceSize()
        levelChoiceButton!.position = proportionSet.levelChoicePos()
        addChild(levelChoiceButton!)

    }
    
    func restartLevel() {
        //LogFileHandler.logger.write("LevelMode; restart; \(gameService.getLevel().id!); \(super.gameService.getLevel().movesCounter); -1; \(stopCounter()); \(NSDate())\n")
      ResourcesManager.getInstance().storyService?.reloadLevelModeGameScene(levelId: gameService.getLevel().id!)
    }
    
    func loadLevelChoiceScene() {
        //LogFileHandler.logger.write("LevelMode; end; \(gameService.getLevel().id!); \(super.gameService.getLevel().movesCounter); -1; \(stopCounter()); \(NSDate())\n")
        ResourcesManager.getInstance().storyService?.loadLevelCoiceSceneFromLevelModeScene()
    }
    
    override func onSolvedGame() {
        let time = stopCounter()
        let level = gameService.getLevel()
        let levelService = ResourcesManager.getInstance().levelService
        let levelResult = levelService!.calculateLevelResult(level: level)
        levelResult.time = time
        _ = levelService?.persistLevelResult(levelResult: levelResult)
        levelService?.unlockLevel(levelId: level.id! + 1)
        //LogFileHandler.logger.write("LevelMode; solved; \(levelResult.levelId); \(levelResult.moveCount); \(levelResult.stars); \(time); \(NSDate())\n")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
            ResourcesManager.getInstance().storyService?.loadLevelModeScoreSceneFromLevelModeScene(levelResult: levelResult)
        })
    }
}
