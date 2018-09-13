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
    var time: Double
    
    init(levelId: Int, locked: Bool, fewestMoves: Int, stars: Int, time: Double) {
        self.levelId = levelId
        self.locked = locked
        self.fewestMoves = fewestMoves
        self.stars = stars
        self.time = time
    }
    
    init(levelInfo: LevelInfo) {
        self.levelId = levelInfo.levelId
        self.locked = levelInfo.locked
        self.fewestMoves = levelInfo.fewestMoves
        self.stars = levelInfo.stars
        self.time = levelInfo.time
    }
    
    init(levelInfoMO: LevelInfoMO) {
        self.levelId = Int(levelInfoMO.id)
        self.fewestMoves = Int(levelInfoMO.fewest_moves)
        self.locked = levelInfoMO.locked
        self.stars = Int(levelInfoMO.stars)
        self.time = Double(levelInfoMO.time)
    }
    
    public func description() -> String {
        return "\(levelId);\(fewestMoves);\(locked);\(stars);\(time))"
        
    }
}
