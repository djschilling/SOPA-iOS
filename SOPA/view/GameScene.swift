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
    var gameFieldNode: GameFieldNode?
    
    let gameService : GameService
    var levelSolved = false
    let BUTTON_SIZE: CGFloat
    let currentMovesNode = SKLabelNode(fontNamed: "Impact")
    
    init(size: CGSize, level: Level) {
        BUTTON_SIZE = CGFloat(0.14) * size.height
        gameService = GameServiceImpl(level: level)
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
        levelNumber.text = String(gameService.getLevel().id!)
        addChild(levelNumber)
        
        let minMovesNumber = SKLabelNode(fontNamed: "Impact")
        minMovesNumber.text = String(gameService.getLevel().minimumMovesToSolve!)
        minMovesNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        minMovesNumber.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        minMovesNumber.position.y = size.height - minMovesLabel.fontSize
        minMovesNumber.fontSize *= 2
        addChild(minMovesNumber)
    }
    
    func addDynamicLabels() {
        currentMovesNode.text = String(gameService.getLevel().movesCounter)
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
        gameService.shiftLine(horizontal: horizontal, row: rowOrColumn, steps: steps)
        currentMovesNode.text = String(gameService.getLevel().movesCounter)
        levelSolved = gameService.solvedPuzzle()
        if levelSolved {
            onSolvedGame()
        }
    }
    
  
}

