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
    private let levelResult: LevelResult
    private let background = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255.0, alpha: 1.0)
    private let textColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)

    init(size: CGSize, levelResult: LevelResult) {
        self.levelResult = levelResult
        super.init(size: size)

        self.backgroundColor = background
        addButtons()
        addStaticObjects()
    }

    private func addButtons() {
        let side = min(size.width, size.height) * 0.20
        let restartButton = SpriteButton(texture: makeRestartButtonTexture(side: side), onClick: restartLevel)
        let levelChoiceButton = SpriteButton(texture: makeBackButtonTexture(side: min(size.width, size.height) * 0.20), onClick: levelChoiceMenu)
        let nextLevelButton = SpriteButton(texture: makeNextButtonTexture(side: side), onClick: startNextLevel)

        let buttonSize = CGSize(width: side, height: side)
        restartButton.size = buttonSize
        levelChoiceButton.size = buttonSize
        nextLevelButton.size = buttonSize

        let buttonY = size.height * 0.18
        restartButton.position = CGPoint(x: size.width / 2, y: buttonY)
        levelChoiceButton.position = CGPoint(x: size.width * 0.20, y: buttonY)
        nextLevelButton.position = CGPoint(x: size.width * 0.80, y: buttonY)

        addChild(restartButton)
        addChild(levelChoiceButton)
        addChild(nextLevelButton)
    }

    private func addStaticObjects() {
        let title = SKLabelNode(fontNamed: "Optima-Bold")
        title.text = "Level \(levelResult.levelId) Complete"
        title.horizontalAlignmentMode = .center
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.86)
        title.fontSize = min(size.width, size.height) * 0.075
        title.fontColor = textColor
        addChild(title)

        let yourMovesLabel = SKLabelNode(fontNamed: "Optima-Bold")
        yourMovesLabel.text = "Your moves: \(levelResult.moveCount)"
        yourMovesLabel.horizontalAlignmentMode = .center
        yourMovesLabel.verticalAlignmentMode = .center
        yourMovesLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.52)
        yourMovesLabel.fontSize = min(size.width, size.height) * 0.05
        yourMovesLabel.fontColor = textColor
        addChild(yourMovesLabel)

        let level = ResourcesManager.getInstance().levelService!.getLevelById(id: levelResult.levelId)!
        let optimumLabel = SKLabelNode(fontNamed: "Optima-Bold")
        optimumLabel.text = "3-star target: \(level.minimumMovesToSolve!)"
        optimumLabel.horizontalAlignmentMode = .center
        optimumLabel.verticalAlignmentMode = .center
        optimumLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.46)
        optimumLabel.fontSize = min(size.width, size.height) * 0.045
        optimumLabel.fontColor = textColor
        addChild(optimumLabel)

        addStars()
    }

    private func addStars() {
        let starSide = min(size.width, size.height) * 0.22
        let starSize = CGSize(width: starSide, height: starSide)

        let star1 = SKSpriteNode(imageNamed: "star_score")
        star1.size = starSize
        star1.position = CGPoint(x: size.width * 0.23, y: size.height * 0.66)
        addChild(star1)

        let star2 = SKSpriteNode(imageNamed: levelResult.stars >= 2 ? "star_score": "starSW_score")
        star2.size = starSize
        star2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.62)
        addChild(star2)

        let star3 = SKSpriteNode(imageNamed: levelResult.stars == 3 ? "star_score": "starSW_score")
        star3.size = starSize
        star3.position = CGPoint(x: size.width * 0.77, y: size.height * 0.66)
        addChild(star3)
    }

    private func restartLevel() {
        ResourcesManager.getInstance().storyService?.reloadLevelModeGameScene(levelId: levelResult.levelId)
    }

    private func levelChoiceMenu() {
        ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
    }

    private func startNextLevel() {
        if ResourcesManager.getInstance().levelService?.getLevelCount() == levelResult.levelId {
            ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
        } else {
            ResourcesManager.getInstance().storyService?.loadNextLevelModeGameScene(levelId: levelResult.levelId + 1)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
