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
    let numberActive = UIColor(red: 223.0 / 255.0, green: 106.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0)
    let numberUnlocked = UIColor(red: 98.0 / 255.0, green: 100.0 / 255.0, blue: 106.0 / 255.0, alpha: 1.0)
    let numberLocked = UIColor(red: 110.0 / 255.0, green: 112.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
    let levelInfo: LevelInfo

    init(levelInfo: LevelInfo, levelButtonPositioner: LevelButtonPositioner) {
        self.levelInfo = levelInfo
        super.init(texture: nil, color: .clear, size: levelButtonPositioner.getLevelSize())
        position = levelButtonPositioner.getLevelPosition(id: levelInfo.levelId)

        let isCurrentTarget = !levelInfo.locked && levelInfo.fewestMoves < 0
        addFrame(locked: levelInfo.locked, highlighted: isCurrentTarget)
        addLable(id: levelInfo.levelId, color: labelColor(locked: levelInfo.locked, highlighted: isCurrentTarget))
        if !levelInfo.locked {
            addStars(stars: levelInfo.stars)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addFrame(locked: Bool, highlighted: Bool) {
        let inset = size.width * 0.04
        let frameRect = CGRect(
            x: -size.width / 2.0 + inset,
            y: -size.height / 2.0 + inset,
            width: size.width - 2.0 * inset,
            height: size.height - 2.0 * inset
        )
        let cornerRadius = size.width * 0.20

        let glowNode = SKShapeNode(rect: frameRect, cornerRadius: cornerRadius)
        glowNode.fillColor = .clear
        glowNode.lineWidth = size.width * 0.040
        glowNode.strokeColor = highlighted
            ? UIColor(red: 245.0 / 255.0, green: 102.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.70)
            : UIColor(white: 1.0, alpha: locked ? 0.12 : 0.30)
        glowNode.glowWidth = size.width * 0.10
        glowNode.blendMode = .add
        glowNode.zPosition = zPosition
        addChild(glowNode)

        let frameNode = SKShapeNode(rect: frameRect, cornerRadius: cornerRadius)
        frameNode.fillColor = .clear
        frameNode.lineWidth = size.width * 0.030
        frameNode.strokeColor = highlighted
            ? UIColor(red: 250.0 / 255.0, green: 192.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
            : UIColor(white: locked ? 0.55 : 0.90, alpha: 0.95)
        frameNode.lineJoin = .round
        frameNode.zPosition = zPosition + 1
        addChild(frameNode)
    }

    private func labelColor(locked: Bool, highlighted: Bool) -> UIColor {
        if highlighted {
            return numberActive
        }
        if locked {
            return numberLocked
        }
        return numberUnlocked
    }


    func addStars(stars: Int) {
        let star1: SKSpriteNode = generateStar(achieved: stars >= 1)
        let star2: SKSpriteNode = generateStar(achieved: stars >= 2)
        let star3: SKSpriteNode = generateStar(achieved: stars >= 3)
        star1.position = CGPoint(x: -size.width * 0.25, y: -size.height * 0.50)
        star2.position = CGPoint(x: 0, y: -size.height * 0.56)
        star3.position = CGPoint(x: size.width * 0.25, y: -size.height * 0.50)

        addChild(star1)
        addChild(star2)
        addChild(star3)

    }
    
    func addLable(id: Int, color: UIColor) {
        let idLable = SKLabelNode(fontNamed: "Impact")
        idLable.text = String(id)
        idLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        idLable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        idLable.fontSize = size.height * 0.32
        idLable.fontColor = color
        idLable.zPosition = zPosition + 1
        addChild(idLable)
        
    }
    
    func generateStar(achieved: Bool) -> SKSpriteNode {
        var star = SKSpriteNode(imageNamed: "starSW")
        if achieved {
            star = SKSpriteNode(imageNamed: "star")
        }
        star.size = CGSize(width: size.width/3.4, height: size.height/3.4)
        star.zPosition = zPosition + 1
        return star
    }
    
}
