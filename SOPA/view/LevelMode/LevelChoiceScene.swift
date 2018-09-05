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
    let levelInfos: [LevelInfo]
    let levelButtonArea: LevelButtonArea
    
    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        levelButtonArea = LevelButtonArea(size: size, levelInfos: levelInfos)
        super.init(size: size)
        addChild(levelButtonArea)
    }

 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
