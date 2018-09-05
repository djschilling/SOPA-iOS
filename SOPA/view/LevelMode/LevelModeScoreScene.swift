//
//  LevelModeScoreScene.swift
//  SOPA
//
//  Created by Raphael Schilling on 17.05.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

class LevelModeScoreScene: SKScene {
    let BUTTON_DIMENTIONS = CGFloat(0.28)
    let BUTTON_HEIGHT = CGFloat(0.05)
    let STAR_HEIGHT_HEIGH = CGFloat(0.37)
    let STAR_HEIGHT_LOW = CGFloat(0.33)
    let TITLE_HEIGHT = CGFloat(0.95)
    
    let levelResult: LevelResult
    init(size: CGSize, levelResult: LevelResult) {
        self.levelResult = levelResult
        super.init(size: size)
    
        addButtons()
        addStaticObjects()
    }
    
    func addButtons() {
        let restartButton = SpriteButton(imageNamed: "restart", onClick: restartLevel)
        let levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: levelChoiceMenu)
        let nextLevelButton = SpriteButton(imageNamed: "NextLevel", onClick: startNextLevel)
        
        let buttonSize =  CGSize(width: size.width * BUTTON_DIMENTIONS, height: size.width * BUTTON_DIMENTIONS)
        restartButton.size = buttonSize
        levelChoiceButton.size = buttonSize
        nextLevelButton.size = buttonSize
        
        let buttonY = size.width * BUTTON_DIMENTIONS / 2 + size.height * BUTTON_HEIGHT
        restartButton.position = CGPoint(x: size.width / 2, y: buttonY)
        levelChoiceButton.position = CGPoint(x: size.width / 6, y: 100)
        nextLevelButton.position = CGPoint(x: 5 * size.width / 6, y: 100)
        
        addChild(restartButton)
        addChild(levelChoiceButton)
        addChild(nextLevelButton)
    }
    
    func addStaticObjects() {
        let titleLableA = SKLabelNode(fontNamed: "Impact")
        titleLableA.text = String(levelResult.levelId) + ". Level"
        titleLableA.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        titleLableA.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        titleLableA.position.y = size.height * TITLE_HEIGHT
        titleLableA.position.x = size.width / 2
        titleLableA.fontSize = size.height * 0.1
        addChild(titleLableA)
        
        let titleLableB = SKLabelNode(fontNamed: "Impact")
        titleLableB.text = "complete"
        titleLableB.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        titleLableB.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        titleLableB.position.y = size.height * TITLE_HEIGHT - 0.1 * size.height
        titleLableB.position.x = size.width / 2
        titleLableB.fontSize = size.height * 0.1
        addChild(titleLableB)
        
        let yourMovesLable = SKLabelNode(fontNamed: "Impact")
        yourMovesLable.text = "Your moves:\t\t\t\t" + String(levelResult.moveCount)
        yourMovesLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        yourMovesLable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        yourMovesLable.position.y = size.height * (0.6)
        yourMovesLable.position.x = size.width / 2
        yourMovesLable.fontSize = size.height * 0.05
        addChild(yourMovesLable)
        
        let movesPossibleLable = SKLabelNode(fontNamed: "Impact")
        movesPossibleLable.text = "Moves for 3 stars:\t" + String(levelResult.moveCount)
        movesPossibleLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        movesPossibleLable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        movesPossibleLable.position.y = size.height * (0.52)
        movesPossibleLable.position.x = size.width / 2
        movesPossibleLable.fontSize = size.height * 0.05
        addChild(movesPossibleLable)
        
        addStars()
    }
    
    func addStars() {
        let starSize = CGSize(width: size.width * 0.36, height: size.width * 0.36)
        
        let star1 = SKSpriteNode(imageNamed: "star" )
        star1.size = starSize
        star1.position = CGPoint(x: starSize.width / 2, y: STAR_HEIGHT_HEIGH * size.height)
        addChild(star1)
        
        let star2 = SKSpriteNode(imageNamed: levelResult.stars >= 2 ? "star": "starSW")
        star2.size = starSize
        star2.position = CGPoint(x: size.width / 2, y: STAR_HEIGHT_LOW * size.height)
        addChild(star2)

        let star3 = SKSpriteNode(imageNamed: levelResult.stars == 3 ? "star": "starSW")
        star3.size = starSize
        star3.position = CGPoint(x: size.width - starSize.width / 2, y: STAR_HEIGHT_HEIGH * size.height)
        addChild(star3)
    }
    
    func restartLevel() {
        ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: levelResult.levelId)
    }
    
    func levelChoiceMenu() {
        ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
    }
    
    func startNextLevel() {
        ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: levelResult.levelId + 1)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
