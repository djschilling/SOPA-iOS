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
    override init(size: CGSize, level: Level) {
        super.init(size: size, level: level)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func addButtons() {
        restartButton = SpriteButton(imageNamed: "restart", onClick: restartLevel)
        restartButton!.size.height = BUTTON_SIZE
        restartButton!.size.width = BUTTON_SIZE
        restartButton!.position.y = BUTTON_SIZE / 2
        restartButton!.position.x = size.width - BUTTON_SIZE / 2
        addChild(restartButton!)
        
        levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: loadLevelChoiceScene)
        levelChoiceButton!.size.height = BUTTON_SIZE
        levelChoiceButton!.size.width = BUTTON_SIZE
        levelChoiceButton!.position.y = BUTTON_SIZE / 2
        levelChoiceButton!.position.x =  restartButton!.position.x - restartButton!.size.width
        addChild(levelChoiceButton!)
    }
    
    func restartLevel() {
      ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: gameService.getLevel().id!)
    }
    
    func loadLevelChoiceScene() {
        ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
    }
    
    override func onSolvedGame() {
        restartButton!.isUserInteractionEnabled = false
        restartButton!.isHidden = true
        levelChoiceButton!.isUserInteractionEnabled = false
        levelChoiceButton!.isHidden = true
        let level = gameService.getLevel()
        let levelService = ResourcesManager.getInstance().levelService
        let levelResult = levelService!.calculateLevelResult(level: level)
        levelService?.persistLevelResult(levelResult: levelResult)
        levelService?.unlockLevel(levelId: level.id! + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            ResourcesManager.getInstance().storyService?.loadLevelModeScoreScene(levelResult: levelResult)
        }
    }
}
