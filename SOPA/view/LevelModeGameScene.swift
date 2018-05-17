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
    let levelCopy: Level
    var restartButton: SpriteButton?
    override init(size: CGSize, level: Level) {
        levelCopy = Level(level: level)
        super.init(size: size, level: level)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func addButtons() {
        restartButton = SpriteButton(imageNamed: "restart", onClick: restartLevel)
        restartButton!.size.height = BUTTON_SIZE * size.width
        restartButton!.size.width = BUTTON_SIZE *  size.width
        restartButton!.position.y = BUTTON_SIZE *  size.width / 2
        restartButton!.position.x = size.width - BUTTON_SIZE *  size.width / 2
        addChild(restartButton!)
    }
    func restartLevel() {
      
    }
    
    override func onSolvedGame() {
        restartButton!.isUserInteractionEnabled = false
        restartButton!.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            let closeDoorAnimation = SKTransition.doorsCloseHorizontal(withDuration: 1)
            let newScene = LevelModeScoreScene(size: self.size, levelResult: LevelResult(levelId: 1, moveCount: 1, stars: 1))
            self.view?.presentScene(newScene, transition: closeDoorAnimation)
        }
    }
}
