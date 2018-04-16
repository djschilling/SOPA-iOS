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
    
    init(size: CGSize, level: Level) {
        self.level = level
        super.init(size: size)
        gameFieldNode = GameFieldNode(level: level, gameScene: self)
        addChild(gameFieldNode!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        gameFieldNode!.update()
    }
    func moveVertical(column:  Int, steps: Int) {
        gameFieldService.shiftLine(level: level, horizontal: false, rowOrColumn: column, steps: steps)
        levelSolved = gameFieldService.solvedPuzzle(level: level)
    }
    
    func moveHorizontal(row:  Int, steps: Int) {
        gameFieldService.shiftLine(level: level, horizontal: true, rowOrColumn: row, steps: steps)
        levelSolved = gameFieldService.solvedPuzzle(level: level)
    }
}

