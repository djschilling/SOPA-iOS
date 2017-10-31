//
//  LevelInfo.swift
//  SOPA
//
//  Created by Raphael Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class LevelInfo {
    let levelId: Int
    var locked: Bool
    var fewestMoves: Int
    var stars: Int
    
    init(levelId: Int, locked: Bool, fewestMoves: Int, stars: Int) {
        self.levelId = levelId
        self.locked = locked
        self.fewestMoves = fewestMoves
        self.stars = stars
    }
    init(levelInfo: LevelInfo) {
        self.levelId = levelInfo.levelId
        self.locked = levelInfo.locked
        self.fewestMoves = levelInfo.fewestMoves
        self.stars = levelInfo.stars
    }
}
