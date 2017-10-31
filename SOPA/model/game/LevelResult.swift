//
//  LevelResult.swift
//  SOPA
//
//  Created by Raphael Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class LevelResult {
    let levelId: Int
    let moveCount: Int
    let stars: Int
    
    init(levelId: Int, moveCount: Int, stars: Int) {
        self.levelId = levelId
        self.moveCount = moveCount
        self.stars = stars
    }
    
}
