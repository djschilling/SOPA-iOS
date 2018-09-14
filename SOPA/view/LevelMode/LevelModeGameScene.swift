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
    override init(size: CGSize, level: Level) {
        super.init(size: size, level: level)
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
        restartButton!.size.height = BUTTON_SIZE
        restartButton!.size.width = BUTTON_SIZE
        restartButton!.position.y = size.height * 0.12
        restartButton!.position.x = size.height * 0.48
        addChild(restartButton!)
        
        levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: loadLevelChoiceScene)
        levelChoiceButton!.size.height = size.height * 0.08
        levelChoiceButton!.size.width = size.height * 0.08
        levelChoiceButton!.position.y = size.height * 0.91
        levelChoiceButton!.position.x =  size.height * 0.057
        addChild(levelChoiceButton!)

    }
    
    func restartLevel() {
        LogFileHandler.logger.write("LevelMode; restart; \(gameService.getLevel().id!); \(super.gameService.getLevel().movesCounter); -1; \(stopCounter()); \(NSDate())\n")
      ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: gameService.getLevel().id!)
    }
    
    func loadLevelChoiceScene() {
        LogFileHandler.logger.write("LevelMode; end; \(gameService.getLevel().id!); \(super.gameService.getLevel().movesCounter); -1; \(stopCounter()); \(NSDate())\n")
        ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
    }
    
    override func onSolvedGame() {
        hideButtons()
        let time = stopCounter()
        hideButtons()
        let level = gameService.getLevel()
        let levelService = ResourcesManager.getInstance().levelService
        let levelResult = levelService!.calculateLevelResult(level: level)
        levelResult.time = time
        levelService?.persistLevelResult(levelResult: levelResult)
        levelService?.unlockLevel(levelId: level.id! + 1)
        LogFileHandler.logger.write("LevelMode; solved; \(levelResult.levelId); \(levelResult.moveCount); \(levelResult.stars); \(time); \(NSDate())\n")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            ResourcesManager.getInstance().storyService?.loadLevelModeScoreScene(levelResult: levelResult)
        }
    }
    
    private func hideButtons() {
        restartButton!.isUserInteractionEnabled = false
        restartButton!.isHidden = true
        levelChoiceButton!.isUserInteractionEnabled = false
        levelChoiceButton!.isHidden = true
    }
}
