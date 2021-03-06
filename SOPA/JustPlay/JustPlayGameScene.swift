//
//  LevelModeGameScene.swift
//  SOPA
//
//  Created by Raphael Schilling on 23.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
class JustPlayGameScene: GameScene {
    var restartButton: SpriteButton?
    var levelChoiceButton: SpriteButton?
    var start: NSDate?
    var storeLevelButton: SpriteButton?
    let levelBackup: Level
    override init(size: CGSize, proportionSet: ProportionSet, level: Level) {
        levelBackup = Level(level: level)
        super.init(size: size, proportionSet: proportionSet, level: level)
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
        restartButton = SpriteButton(imageNamed: "restart", onClick: restartLevel)
        restartButton!.size.height = proportionSet.buttonSize()
        restartButton!.size.width = proportionSet.buttonSize()
        restartButton!.position = proportionSet.restartButtonPos()
        addChild(restartButton!)
        
        levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: loadLevelChoiceScene)
        levelChoiceButton!.size.height = proportionSet.levelChoiceSize()
        levelChoiceButton!.size.width = proportionSet.levelChoiceSize()
        levelChoiceButton!.position = proportionSet.levelChoicePos()
        addChild(levelChoiceButton!)
        
        storeLevelButton = SpriteButton(imageNamed: "restart", onClick: saveLevel)
        storeLevelButton!.size.height = proportionSet.buttonSize()
        storeLevelButton!.size.width = proportionSet.buttonSize()
        storeLevelButton!.position = CGPoint(x: size.width - proportionSet.levelChoiceSize(), y: size.height - proportionSet.levelChoiceSize())
        addChild(storeLevelButton!)

    }
    
    func saveLevel() {
        storeLevelButton!.position = CGPoint(x:-100,y:0)
        ResourcesManager.getInstance().levelService!.saveLevel(level: levelBackup)
    }
    
    func restartLevel() {
        //LogFileHandler.logger.write("LevelMode; restart; \(gameService.getLevel().id!); \(super.gameService.getLevel().movesCounter); -1; \(stopCounter()); \(NSDate())\n")
        ResourcesManager.getInstance().storyService?.reloadJustPlayGameScene(level: levelBackup)
    }
    
    func loadLevelChoiceScene() {
        //LogFileHandler.logger.write("LevelMode; end; \(gameService.getLevel().id!); \(super.gameService.getLevel().movesCounter); -1; \(stopCounter()); \(NSDate())\n")
        ResourcesManager.getInstance().storyService?.loadLevelCoiceSceneFromLevelModeScene()
    }
    
    override func onSolvedGame() {
        let time = stopCounter()
        let level = gameService.getLevel()
        let levelService = ResourcesManager.getInstance().levelService
        let levelResult = levelService!.calculateLevelResult(level: level)
        levelResult.time = time
        //LogFileHandler.logger.write("LevelMode; solved; \(levelResult.levelId); \(levelResult.moveCount); \(levelResult.stars); \(time); \(NSDate())\n")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.animateLevelSolved(levelResult: levelResult)
            })
    }
    
    private func animateLevelSolved(levelResult: LevelResult) {
        let fadeOutGameField: SKAction = SKAction.fadeAlpha(to: 0.0, duration: 0.3)
        let moveActionLabels = SKAction.move(to: proportionSet.moveLabelsPos2(), duration: 0.5)
        moveActionLabels.timingMode = SKActionTimingMode.easeInEaseOut
        
        gameFieldNode?.run(fadeOutGameField)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {self.movesLabels.run(moveActionLabels)})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.addStars(levelResult: levelResult)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.addNextLevelButton()
        }
    }
    
    private func addNextLevelButton() {
        let nextLevelButton = SpriteButton(imageNamed: "NextLevel") {
            
            ResourcesManager.getInstance().storyService?.loadNextJustPlayGameScene()
        }
        nextLevelButton.size = CGSize(width: proportionSet.buttonSize(), height: proportionSet.buttonSize())
        
        nextLevelButton.alpha = 0.0
        nextLevelButton.position.y = proportionSet.restartButtonPos().y
        nextLevelButton.position.x = size.width - proportionSet.restartButtonPos().x

        addChild(nextLevelButton)
        nextLevelButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.2))
        
    }
    
    private func addStars(levelResult: LevelResult) {

        
        let starSizeHidden = CGSize(width: 0, height: 0)
        
        let star1 = SKSpriteNode(imageNamed: "star_score" )
        star1.size = starSizeHidden
        star1.position = CGPoint(x: proportionSet.starSize().width * proportionSet.starLRX(), y:  proportionSet.starLRY())
        addChild(star1)
        
        let star2 = SKSpriteNode(imageNamed: levelResult.stars >= 2 ? "star_score": "starSW_score")
        star2.size = starSizeHidden
        star2.position = CGPoint(x: size.width / 2, y: proportionSet.starMY())
        addChild(star2)
        
        let star3 = SKSpriteNode(imageNamed: levelResult.stars == 3 ? "star_score": "starSW_score")
        star3.size = starSizeHidden
        star3.position = CGPoint(x: size.width - proportionSet.starSize().width * proportionSet.starLRX(), y: proportionSet.starLRY())
        addChild(star3)
        
        let appearStar = SKAction.resize(toWidth: proportionSet.starSize().width, height: proportionSet.starSize().height, duration: 0.1)
        star1.run(appearStar)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            star2.run(appearStar)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            star3.run(appearStar)
        }
    }

    private func hideButtons() {
        restartButton!.isUserInteractionEnabled = false
        restartButton!.isHidden = true
        levelChoiceButton!.isUserInteractionEnabled = false
        levelChoiceButton!.isHidden = true
    }
}
