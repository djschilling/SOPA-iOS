//
//  LevelButtonPositioner.swift
//  SOPA
//
//  Created by Raphael Schilling on 03.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

class LevelButtonPositioner {
    let size: CGSize
    let buttonSize: CGSize
    let drawingHeight: CGFloat
    
    init(size: CGSize) {
        self.size = size
        self.buttonSize = CGSize(width: size.width * 0.3, height: size.width * 0.3)
        self.drawingHeight = size.height
    }
    
    func getLevelPosition(id: Int) -> CGPoint {
        let page = (id - 1) / 12
        let idOnPage = (id - 1) % 12
        let column = idOnPage % 3
        let row = idOnPage / 3
        let xPos: CGFloat = size.width / 4.0 * CGFloat(1 + column) + (size.width * CGFloat(page))
        let yPos: CGFloat = size.height - (drawingHeight / 5.0 * CGFloat(row + 1))
        let position = CGPoint(x: xPos, y: yPos)
        
        return position
    }
    
    func getLevelSize() -> CGSize {
        return buttonSize
    }
}
