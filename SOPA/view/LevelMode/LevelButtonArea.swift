//
//  LevelButtonArea.swift
//  SOPA
//
//  Created by Raphael Schilling on 04.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

class LevelButtonArea: SKSpriteNode {
    var currentTouch: UITouch?
    var startPoint: CGPoint?
    let MIN_DELTA_SWIPE = CGFloat(100)
    let MAX_DELTA_TAB = CGFloat(50)
    var levelButtons: [LevelSelectButton] = []
    
    init(size: CGSize, levelInfos: [LevelInfo]) {
        let pageCount = 1 + (levelInfos.count - 1) / 12

        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: size.width * CGFloat(pageCount), height: size.height))
        for levelInfo in levelInfos{
            let levelButton = LevelSelectButton(levelInfo: levelInfo, levelButtonPositioner: LevelButtonPositioner(size: size))
            levelButtons.append(levelButton)
            addChild(levelButton)
        }
        //position.x = -size.width
        isUserInteractionEnabled = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(currentTouch == nil) {
            currentTouch = touches.first
            startPoint = currentTouch?.location(in: self)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.contains(currentTouch!)) {
            currentTouch = nil
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.contains(currentTouch!) {
            let newPos = currentTouch?.location(in: self)
            let deltaX = newPos!.x - startPoint!.x
            let deltaY = newPos!.y - startPoint!.y
            if(abs(deltaX) < MAX_DELTA_TAB && abs(deltaY) < MAX_DELTA_TAB) {
                tabOn(location: (currentTouch?.location(in: self))!)
            } else if deltaX > MIN_DELTA_SWIPE {
                swipeLeft()
            } else if -deltaX > MIN_DELTA_SWIPE {
                swipeRight()
            }
            currentTouch = nil
        }
    }
    
    func tabOn(location: CGPoint) {
        var node: SKNode? = atPoint(location)

        if node is LevelSelectButton {
            ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: (node as! LevelSelectButton).levelInfo.levelId)
            return
        }

        if node is SKLabelNode || node is SKSpriteNode {
            node = node?.parent

            if node is LevelSelectButton {
                ResourcesManager.getInstance().storyService?.loadLevelModeGameScene(levelId: (node as! LevelSelectButton).levelInfo.levelId)
            }

        } else {
            return
        }

    
    }
    
    func swipeLeft() {
        print("swipeLeft()")

    }
    
    func swipeRight() {
        print("swipeRight()")

    }
    
}
