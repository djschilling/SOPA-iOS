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
    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        super.init(size: size)
        let levelButton = LevelSelectButton(levelInfo: LevelInfo(levelId: 1, locked: true, fewestMoves: 2, stars: 2))
        levelButton.position = CGPoint(x: 200, y: 200)
        addChild(levelButton)


 
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
