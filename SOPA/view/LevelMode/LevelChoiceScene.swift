//
//  LevelChoiceScene.swift
//  SOPA
//
//  Created by Raphael Schilling on 22.05.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit


class LevelChoiceScene: SKScene {
    private let levelInfos: [LevelInfo]
    private var levelButtonArea: LevelButtonArea?
    private var leftButton: EffectSpriteButton?
    private var rightButton: EffectSpriteButton?

    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        super.init(size: size)
        levelButtonArea = LevelButtonArea(size: size, levelInfos: levelInfos, update: update)
        addChild(levelButtonArea!)
        addButtons()
        //addStatisticsShareButton()
        self.backgroundColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)


    }
    
    private func addStatisticsShareButton() {
        let statisticsShareButton = SpriteButton(imageNamed: "StatisticsShare", onClick: shareStatistics)
        statisticsShareButton.size = CGSize(width: size.height * 0.1, height: size.height * 0.1)
        statisticsShareButton.position.x = size.width * 0.5
        statisticsShareButton.position.y = statisticsShareButton.size.height * 0.5
        addChild(statisticsShareButton)
    }
    
    private func shareStatistics() {
        let shareString = LogFileHandler.logger.readLog()
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil);
        let currentViewController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        currentViewController.present(activityViewController, animated: true, completion: nil);
    }
    
    func startRandom() {
        ResourcesManager.getInstance().storyService?.loadJustPlaySceneFromMenuScene()
    }
    
    private func addButtons() {
        let buttonSize = size.height * 0.18
        if(Configurations.DEVELOPER_MODE) {
            let randomButton = EffectSpriteButton(imageNamed: "ArrowLeft", onClick: startRandom
                , size: CGSize(width: buttonSize, height: buttonSize))
            randomButton.position.y = buttonSize
            randomButton.position.x = size.width / 2
            randomButton.setEnabled(true)
            addChild(randomButton)
        }
        
        leftButton = EffectSpriteButton(imageNamed: "ArrowLeft", onClick: levelButtonArea!.swipeLeft, size: CGSize(width: buttonSize, height: buttonSize))
        leftButton?.position.y = buttonSize
        leftButton?.position.x = buttonSize
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage > 0)
       // addChild(leftButton!)
        
        rightButton = EffectSpriteButton(imageNamed: "ArrowRight", onClick: levelButtonArea!.swipeRight, size: CGSize(width: buttonSize, height: buttonSize))
        rightButton?.position.y = buttonSize
        rightButton?.position.x = size.width - buttonSize
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage < levelButtonArea!.pageCount - 1)
      //  addChild(rightButton!)
        update()
    }
    
    func update() {
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage > 0)
        rightButton?.setEnabled(levelButtonArea!.currentLevelPage < levelButtonArea!.pageCount - 1)
    }
    
    

 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
