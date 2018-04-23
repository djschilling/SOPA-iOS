//
//  GameScene.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var level: Level
    var gameFieldNode: GameFieldNode?
    
    let gameFieldService = GameFieldService()
    var levelSolved = false
    let BUTTON_SIZE = CGFloat(0.3)
    
    init(size: CGSize, level: Level) {
        self.level = level
        super.init(size: size)
        gameFieldNode = GameFieldNode(gameScene: self)
        addChild(gameFieldNode!)
        addButtons()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
    }
    override func didMove(to view: SKView) {
        gameFieldNode!.update()
    }
    func moveLine(horizontal: Bool, rowOrColumn:  Int, steps: Int) {
        gameFieldService.shiftLine(level: level, horizontal: horizontal, rowOrColumn: rowOrColumn, steps: steps)
        levelSolved = gameFieldService.solvedPuzzle(level: level)
    }
    
  
}

