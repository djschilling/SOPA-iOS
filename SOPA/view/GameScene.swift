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
    let proportionSet: ProportionSet
    var levelSolved = false
    let fontName = "Optima-Bold"
    let fontColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    let currentMovesNode = SKLabelNode(fontNamed: "Optima-Bold")
    let movesLabels = SKNode()
    
    init(size: CGSize, proportionSet: ProportionSet, level: Level) {
        self.proportionSet = proportionSet
        gameService = GameServiceImpl(level: level)
        super.init(size: size)
        gameFieldNode = GameFieldNode(gameScene: self)
        addChild(gameFieldNode!)
        addButtons()
        addStaticLabels()
        addDynamicLabels()
        //self.backgroundColor = UIColor(red: 169.0 / 255.0, green: 162.0 / 255.0, blue: 121.0 / 255, alpha: 1.0)greenbrown
        self.backgroundColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
    }
    
    func addStaticLabels() {
        addChild(movesLabels)
        
        let minMovesLabel = SKLabelNode(fontNamed: fontName)
        minMovesLabel.text = "Optimum: \(gameService.getLevel().minimumMovesToSolve!)"
        minMovesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        minMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        minMovesLabel.fontSize = proportionSet.movesFontSize()
        minMovesLabel.position = proportionSet.minMovesPos()
        minMovesLabel.fontColor = fontColor
        movesLabels.position = proportionSet.movesLabelsPos()
        movesLabels.addChild(minMovesLabel)
        

        
        
        let currentMovesLabel = SKLabelNode(fontNamed: fontName)
        currentMovesLabel.text = "Moves:"
        currentMovesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        currentMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        currentMovesLabel.position = proportionSet.currentMovesLabelPos()
        currentMovesLabel.fontSize = proportionSet.movesFontSize()
        currentMovesLabel.fontColor = fontColor
        movesLabels.addChild(currentMovesLabel)
        
      

        
        let levelNumber = SKLabelNode(fontNamed: fontName)
        levelNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelNumber.position = proportionSet.levelNumberPos()
        levelNumber.fontSize = proportionSet.levelNumberFontSize()
        levelNumber.text = String(gameService.getLevel().id!) + ". Level"
        levelNumber.fontColor = fontColor
        addChild(levelNumber)
        
       
    }
    
    func addDynamicLabels() {
        currentMovesNode.text = String(gameService.getLevel().movesCounter)
        currentMovesNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        currentMovesNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        currentMovesNode.fontSize = proportionSet.movesFontSize()
        currentMovesNode.position = proportionSet.currentMovesNodePos()
        currentMovesNode.fontColor = fontColor
        movesLabels.addChild(currentMovesNode)
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

