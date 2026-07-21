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
    let pageSize: CGSize
    let pageCount: Int
    var currentLevelPage: Int
    let updateLevelChoiceArrows: () -> Void
    
    init(size: CGSize, levelInfos: [LevelInfo], update: @escaping () -> Void) {
        updateLevelChoiceArrows = update
        pageSize = size
        currentLevelPage = 0
        pageCount = 1 + (levelInfos.count - 1) / 12

        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: size.width * CGFloat(pageCount), height: size.height))
        for levelInfo in levelInfos{
            let levelButton = LevelSelectButton(levelInfo: levelInfo, levelButtonPositioner: LevelButtonPositioner(size: size))
            levelButtons.append(levelButton)
            addChild(levelButton)
        }
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
        // Resolve the tapped node to its enclosing level button. The button's visuals are a mix
        // of shape (neon frame), label (number) and sprite (stars) children, so walk up the
        // parent chain instead of special-casing individual node types.
        var node: SKNode? = atPoint(location)
        while node != nil && !(node is LevelSelectButton) {
            node = node?.parent
        }

        if let levelButton = node as? LevelSelectButton, !levelButton.levelInfo.locked {
            ResourcesManager.getInstance().storyService?.loadLevelModeGameSceneFromChoiceScene(levelId: levelButton.levelInfo.levelId)
        }
    }
    
    func swipeLeft() {
        if currentLevelPage > 0 {
            currentLevelPage = currentLevelPage - 1
            let moveAction = SKAction.moveBy(x: pageSize.width, y: 0, duration: 0.28)
            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
            
            run(moveAction, completion: {self.update()})
            updateLevelChoiceArrows()
        }
       
    }
    func update() {
    }
    
    func swipeRight() {
        if currentLevelPage < pageCount - 1 {
            currentLevelPage = currentLevelPage + 1
            let moveAction = SKAction.moveBy(x: -pageSize.width, y: 0, duration: 0.28)
            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
            run(moveAction, completion: {self.update()})
            updateLevelChoiceArrows()
        }
    }
    
}
