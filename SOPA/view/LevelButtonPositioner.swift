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
    func getLevelPosition(id: Int) -> CGPoint {
        return CGPoint(x: 200, y: 400)
    }
    
    func getLevelSize() -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
