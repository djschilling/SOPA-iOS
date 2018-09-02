//
//  LevelButton.swift
//  SOPA
//
//  Created by Raphael Schilling on 01.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSelectButton: SKSpriteNode {
    let levelInfo: LevelInfo
    init(levelInfo: LevelInfo) {
        self.levelInfo = levelInfo
        if locked {
            let texture = SKTexture(imageNamed: "Level")
            super.init(texture: texture, color: UIColor.clear, size: texture.size())
            isUserInteractionEnabled = true
            addStars(stars: (levelInfo?.levelId)!)
        } else {
            let texture = SKTexture(imageNamed: "LevelSW")
            super.init(texture: texture, color: UIColor.clear, size: texture.size())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ResourcesManager.getInstance().levelService?.getLevelById(id: 1)
    }
    
    func addStars(stars: Int) {
        addChild(<#T##node: SKNode##SKNode#>)
    }
}
