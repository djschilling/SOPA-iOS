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
    let currentMovesNode = SKLabelNode(fontNamed: "progbot")
    
    init(size: CGSize, level: Level) {
        BUTTON_SIZE = CGFloat(0.16) * size.height
        gameService = GameServiceImpl(level: level)
        super.init(size: size)
        gameFieldNode = GameFieldNode(gameScene: self)
        addChild(gameFieldNode!)
        addButtons()
        addStaticLabels()
        addDynamicLabels()
        self.backgroundColor = UIColor(red: 169.0 / 255.0, green: 162.0 / 255.0, blue: 121.0 / 255, alpha: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
    }
    
    func addStaticLabels() {
        let minMovesLabel = SKLabelNode(fontNamed: "progbot")
        minMovesLabel.text = "Optimum: "
        minMovesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        minMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        minMovesLabel.position.x = size.height * 0.08
        minMovesLabel.position.y = size.height * 0.96
        minMovesLabel.fontSize = size.height * 0.055
        addChild(minMovesLabel)
        
        let minMovesNumber = SKLabelNode(fontNamed: "progbot")
        minMovesNumber.text = String(gameService.getLevel().minimumMovesToSolve!)
        minMovesNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        minMovesNumber.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        minMovesNumber.position.x = size.height * 0.50
        minMovesNumber.position.y = size.height * 0.96
        minMovesNumber.fontSize = size.height * 0.055
        addChild(minMovesNumber)
        
        
        let currentMovesLabel = SKLabelNode(fontNamed: "progbot")
        currentMovesLabel.text = "Moves:"
        currentMovesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        currentMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        currentMovesLabel.position.x = size.height * 0.08
        currentMovesLabel.position.y = size.height * 0.90
        currentMovesLabel.fontSize = size.height * 0.055
        addChild(currentMovesLabel)
        
      
        

        
        let levelLabel = SKLabelNode(fontNamed: "progbot")
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelLabel.text = "Level"
        levelLabel.position.x = size.height * 0.12
        levelLabel.position.y = size.height * 0.02
        levelLabel.fontSize = size.height * 0.055
  //      addChild(levelLabel)
        
        let levelNumber = SKLabelNode(fontNamed: "progbot")
        levelNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelNumber.position.x = size.height * 0.02
        levelNumber.position.y = size.height * 0.02
        levelNumber.fontSize = size.height * 0.055
        levelNumber.text = String(gameService.getLevel().id!) + ". Level"
        addChild(levelNumber)
        
       
    }
    
    func addDynamicLabels() {
        currentMovesNode.text = String(gameService.getLevel().movesCounter)
        currentMovesNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        currentMovesNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        currentMovesNode.position.x = size.height * 0.50
        currentMovesNode.position.y = size.height * 0.90
        currentMovesNode.fontSize = size.height * 0.055
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

