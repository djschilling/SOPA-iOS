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
        restartButton!.position.y = size.height * 0.15
        restartButton!.position.x = size.width * 0.5 - size.height * 0.1
        addChild(restartButton!)
        
        levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: loadLevelChoiceScene)
        levelChoiceButton!.size.height = BUTTON_SIZE
        levelChoiceButton!.size.width = BUTTON_SIZE
        levelChoiceButton!.position.y = size.height * 0.15
        levelChoiceButton!.position.x =  size.width * 0.5 + size.height * 0.1
        addChild(levelChoiceButton!)

    }
    
    func restartLevel() {
      ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: gameService.getLevel().id!)
    }
    
    func loadLevelChoiceScene() {
        ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
    }
    
    override func onSolvedGame() {
        let time = stopCounter()
        restartButton!.isUserInteractionEnabled = false
        restartButton!.isHidden = true
        levelChoiceButton!.isUserInteractionEnabled = false
        levelChoiceButton!.isHidden = true
        let level = gameService.getLevel()
        let levelService = ResourcesManager.getInstance().levelService
        let levelResult = levelService!.calculateLevelResult(level: level)
        levelResult.time = time
        levelService?.persistLevelResult(levelResult: levelResult)
        levelService?.unlockLevel(levelId: level.id! + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            ResourcesManager.getInstance().storyService?.loadLevelModeScoreScene(levelResult: levelResult)
        }
    }
}
