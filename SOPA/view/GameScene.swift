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
    let currentMovesNode = SKLabelNode(fontNamed: "Impact")
    var currentMoves: Int = 0
    
    init(size: CGSize, level: Level) {
        self.level = level
        super.init(size: size)
        gameFieldNode = GameFieldNode(gameScene: self)
        addChild(gameFieldNode!)
        addButtons()
        addStaticLabels()
        addDynamicLabels()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
    }
    
    func addStaticLabels() {
        let minMovesLabel = SKLabelNode(fontNamed: "Impact")
        minMovesLabel.text = "Min. Moves:"
        minMovesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        minMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        minMovesLabel.position.y = size.height
        addChild(minMovesLabel)
        
        let currentMovesLabel = SKLabelNode(fontNamed: "Impact")
        currentMovesLabel.text = "Current moves:"
        currentMovesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        currentMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        currentMovesLabel.position.y = size.height
        currentMovesLabel.position.x = size.width
        addChild(currentMovesLabel)
        
        let levelLabel = SKLabelNode(fontNamed: "Impact")
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelLabel.text = "Level"
        addChild(levelLabel)
        
        let levelNumber = SKLabelNode(fontNamed: "Impact")
        levelNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelNumber.position.y = levelLabel.fontSize
        levelNumber.fontSize *= 2
        levelNumber.text = String(level.id!)
        addChild(levelNumber)
        
        let minMovesNumber = SKLabelNode(fontNamed: "Impact")
        minMovesNumber.text = String(level.minimumMovesToSolve!)
        minMovesNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        minMovesNumber.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        minMovesNumber.position.y = size.height - minMovesLabel.fontSize
        minMovesNumber.fontSize *= 2
        addChild(minMovesNumber)
    }
    
    func addDynamicLabels() {
        currentMovesNode.text = String(currentMoves)
        currentMovesNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        currentMovesNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        currentMovesNode.position.y = size.height - currentMovesNode.fontSize
        currentMovesNode.fontSize *= 2
        currentMovesNode.position.x = size.width
        addChild(currentMovesNode)
    }
    
    func onSolvedGame() {
        print("Level Solved")
    }
    
    override func didMove(to view: SKView) {
        gameFieldNode!.update()
    }
    func moveLine(horizontal: Bool, rowOrColumn:  Int, steps: Int) {
        if gameFieldService.shiftLine(level: level, horizontal: horizontal, rowOrColumn: rowOrColumn, steps: steps) {
            currentMoves = currentMoves + 1
            currentMovesNode.text = String(currentMoves)
        }
        levelSolved = gameFieldService.solvedPuzzle(level: level)
        if levelSolved {
            onSolvedGame()
        }
    }
    
  
}

