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
    var start: NSDate?

    override init(size: CGSize, proportionSet: ProportionSet, level: Level) {
        super.init(size: size, proportionSet: proportionSet, level: level)
        backgroundColor = .black
        startCounter()
    }
    
    private func startCounter() {
        start = NSDate()
    }
    
    private func stopCounter() -> Double {
        let end = NSDate()
        let difference: Double = end.timeIntervalSince(start! as Date)
        print(difference)
        return difference
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addButtons() {
        let backSide = min(size.width, size.height) * 0.09
        levelChoiceButton = SpriteButton(texture: makeMinimalBackTexture(side: backSide), onClick: loadLevelChoiceScene)
        levelChoiceButton!.position = CGPoint(x: size.width * 0.08, y: size.height * 0.95)
        addChild(levelChoiceButton!)

        let restartSide = min(size.width, size.height) * 0.18
        restartButton = SpriteButton(texture: makeGameplayCircleButtonTexture(symbolName: "arrow.counterclockwise", side: restartSide), onClick: restartLevel)
        restartButton!.position = CGPoint(x: size.width * 0.86, y: size.height * 0.12)
        addChild(restartButton!)
    }

    override func addStaticLabels() {
        addChild(movesLabels)

        let headingColor = UIColor(white: 0.90, alpha: 1.0)
        let valueColor = UIColor(white: 0.96, alpha: 1.0)
        let titleFont = "Impact"

        let minTitle = SKLabelNode(fontNamed: titleFont)
        minTitle.text = "Min. Moves"
        minTitle.horizontalAlignmentMode = .center
        minTitle.verticalAlignmentMode = .center
        minTitle.fontSize = min(size.width, size.height) * 0.055
        minTitle.fontColor = headingColor
        minTitle.position = CGPoint(x: size.width * 0.14, y: size.height * 0.90)
        movesLabels.addChild(minTitle)

        let minValue = SKLabelNode(fontNamed: titleFont)
        minValue.text = String(gameService.getLevel().minimumMovesToSolve ?? 0)
        minValue.horizontalAlignmentMode = .center
        minValue.verticalAlignmentMode = .center
        minValue.fontSize = min(size.width, size.height) * 0.15
        minValue.fontColor = valueColor
        minValue.position = CGPoint(x: size.width * 0.04, y: size.height * 0.84)
        movesLabels.addChild(minValue)

        let currentTitle = SKLabelNode(fontNamed: titleFont)
        currentTitle.text = "Current Moves"
        currentTitle.horizontalAlignmentMode = .center
        currentTitle.verticalAlignmentMode = .center
        currentTitle.fontSize = min(size.width, size.height) * 0.055
        currentTitle.fontColor = headingColor
        currentTitle.position = CGPoint(x: size.width * 0.84, y: size.height * 0.90)
        movesLabels.addChild(currentTitle)

        let levelNumber = SKLabelNode(fontNamed: titleFont)
        levelNumber.horizontalAlignmentMode = .left
        levelNumber.verticalAlignmentMode = .center
        levelNumber.position = CGPoint(x: size.width * 0.04, y: size.height * 0.11)
        levelNumber.fontSize = min(size.width, size.height) * 0.15
        levelNumber.text = String(gameService.getLevel().id!)
        levelNumber.fontColor = valueColor
        addChild(levelNumber)

        let levelLabel = SKLabelNode(fontNamed: titleFont)
        levelLabel.text = "Level"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.verticalAlignmentMode = .center
        levelLabel.fontSize = min(size.width, size.height) * 0.06
        levelLabel.fontColor = headingColor
        levelLabel.position = CGPoint(x: size.width * 0.04, y: size.height * 0.045)
        addChild(levelLabel)
    }

    override func addDynamicLabels() {
        currentMovesNode.text = String(gameService.getLevel().movesCounter)
        currentMovesNode.horizontalAlignmentMode = .center
        currentMovesNode.verticalAlignmentMode = .center
        currentMovesNode.fontSize = min(size.width, size.height) * 0.15
        currentMovesNode.position = CGPoint(x: size.width * 0.80, y: size.height * 0.84)
        currentMovesNode.fontColor = UIColor(white: 0.96, alpha: 1.0)
        movesLabels.addChild(currentMovesNode)
    }

    private func makeGameplayCircleButtonTexture(symbolName: String, side: CGFloat) -> SKTexture {
        let textureSize = CGSize(width: side, height: side)
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            UIColor(white: 0.96, alpha: 1.0).setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: textureSize)).fill()

            let config = UIImage.SymbolConfiguration(pointSize: side * 0.52, weight: .bold)
            if let symbol = UIImage(systemName: symbolName, withConfiguration: config)?
                .withTintColor(UIColor(white: 0.05, alpha: 1.0), renderingMode: .alwaysOriginal) {
                let symbolRect = CGRect(
                    x: (side - symbol.size.width) / 2.0,
                    y: (side - symbol.size.height) / 2.0,
                    width: symbol.size.width,
                    height: symbol.size.height
                )
                symbol.draw(in: symbolRect)
            }
        }
        return SKTexture(image: image)

    }

    private func makeMinimalBackTexture(side: CGFloat) -> SKTexture {
        let textureSize = CGSize(width: side, height: side)
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            let config = UIImage.SymbolConfiguration(pointSize: side * 0.72, weight: .semibold)
            if let symbol = UIImage(systemName: "chevron.left", withConfiguration: config)?
                .withTintColor(UIColor(white: 0.86, alpha: 0.92), renderingMode: .alwaysOriginal) {
                let symbolRect = CGRect(
                    x: (side - symbol.size.width) / 2.0,
                    y: (side - symbol.size.height) / 2.0,
                    width: symbol.size.width,
                    height: symbol.size.height
                )
                symbol.draw(in: symbolRect)
            }
        }
        return SKTexture(image: image)
    }
    
    func restartLevel() {
      ResourcesManager.getInstance().storyService?.reloadLevelModeGameScene(levelId: gameService.getLevel().id!)
    }

    private func loadLevelChoiceScene() {
        ResourcesManager.getInstance().storyService?.loadLevelCoiceSceneFromLevelModeScene()
    }

    override func onSolvedGame() {
        let time = stopCounter()
        let level = gameService.getLevel()
        let levelService = ResourcesManager.getInstance().levelService
        let levelResult = levelService!.calculateLevelResult(level: level)
        levelResult.time = time
        _ = levelService?.persistLevelResult(levelResult: levelResult)
        levelService?.unlockLevel(levelId: level.id! + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
            ResourcesManager.getInstance().storyService?.loadLevelModeScoreSceneFromLevelModeScene(levelResult: levelResult)
        })
    }
}
