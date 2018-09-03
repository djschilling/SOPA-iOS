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
    let orange = UIColor(red: 202.0 / 255.0, green: 84.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
    let grey = UIColor(red: 0.5 , green: 0.5, blue: 0.5, alpha: 1.0)
    let levelInfo: LevelInfo
    init(levelInfo: LevelInfo, levelButtonPositioner: LevelButtonPositioner) {
        self.levelInfo = levelInfo
        if !levelInfo.locked {
            let texture = SKTexture(imageNamed: "Level")
            super.init(texture: texture, color: UIColor.clear, size: levelButtonPositioner.getLevelSize())
            isUserInteractionEnabled = true
            position = levelButtonPositioner.getLevelPosition(id: levelInfo.levelId)
            addStars(stars: levelInfo.stars)
            addLable(id: levelInfo.levelId, color: orange)

        } else {
            let texture = SKTexture(imageNamed: "LevelSW")
            super.init(texture: texture, color: UIColor.clear, size: levelButtonPositioner.getLevelSize())
            position = levelButtonPositioner.getLevelPosition(id: levelInfo.levelId)
            addLable(id: levelInfo.levelId, color: grey)

        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ResourcesManager.getInstance().levelService?.getLevelById(id: 1)
    }
    
    func addStars(stars: Int) {
        let star1: SKSpriteNode = generateStar(achieved: stars >= 1)
        let star2: SKSpriteNode = generateStar(achieved: stars >= 2)
        let star3: SKSpriteNode = generateStar(achieved: stars >= 3)
        star1.position = CGPoint(x: -size.width * 0.25, y: -size.height * 0.2)
        star2.position = CGPoint(x: 0, y: -size.height * 0.27    )
        star3.position = CGPoint(x: size.width * 0.25, y: -size.height * 0.2)

        addChild(star1)
        addChild(star2)
        addChild(star3)

    }
    
    func addLable(id: Int, color: UIColor) {
        let idLable = SKLabelNode(fontNamed: "Impact")
        idLable.text = String(id)
        idLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        idLable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        idLable.fontSize = size.height * 0.34
        idLable.fontColor = color
        idLable.zPosition = zPosition + 1
        addChild(idLable)
        
    }
    
    func generateStar(achieved: Bool) -> SKSpriteNode {
        var star = SKSpriteNode(imageNamed: "starSW")
        if achieved {
            star = SKSpriteNode(imageNamed: "star")
        }
        star.size = CGSize(width: size.width/3, height: size.height/3)
        star.zPosition = zPosition + 1
        return star
    }
}
