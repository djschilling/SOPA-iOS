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
    private let levelButtonArea: LevelButtonArea
    private var leftButton: SpriteButton?
    private var rightButton: SpriteButton?

    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        levelButtonArea = LevelButtonArea(size: size, levelInfos: levelInfos)
        super.init(size: size)
        addChild(levelButtonArea)
        addButtons()

    }
    
    private func addButtons() {
        leftButton = SpriteButton(imageNamed: "ArrowLeft", onClick: levelButtonArea.swipeLeft)
        let buttonSize = size.height * 0.18
        leftButton?.size.height = buttonSize
        leftButton?.size.width = buttonSize
        leftButton?.position.y = buttonSize
        leftButton?.position.x = buttonSize
        addChild(leftButton!)
        
        rightButton = SpriteButton(imageNamed: "ArrowRight", onClick: levelButtonArea.swipeRight)
        rightButton?.size.height = buttonSize
        rightButton?.size.width = buttonSize
        rightButton?.position.y = buttonSize
        rightButton?.position.x = size.width - buttonSize
        addChild(rightButton!)
    }
    
    

 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
