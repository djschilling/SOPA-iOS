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

    }
    
    private func addButtons() {
        let buttonSize = size.height * 0.18

        leftButton = EffectSpriteButton(imageNamed: "ArrowLeft", onClick: levelButtonArea!.swipeLeft, size: CGSize(width: buttonSize, height: buttonSize))
        leftButton?.position.y = buttonSize
        leftButton?.position.x = buttonSize
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage > 0)
        addChild(leftButton!)
        
        rightButton = EffectSpriteButton(imageNamed: "ArrowRight", onClick: levelButtonArea!.swipeRight, size: CGSize(width: buttonSize, height: buttonSize))
        rightButton?.position.y = buttonSize
        rightButton?.position.x = size.width - buttonSize
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage < levelButtonArea!.pageCount - 1)
        addChild(rightButton!)
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
