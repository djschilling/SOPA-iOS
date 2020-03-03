//
//  LevelDestroyer.swift
//  SOPA
//
//  Created by Raphael Schilling on 03.03.20.
//  Copyright © 2020 David Schilling. All rights reserved.
//

import Foundation

class LevelDestroyer {
    
    func destroyField(level: Level, minShiftCount: Int, maxShiftCount: Int) -> Level {
        
        let gameFieldService = GameFieldService()
        let shiftCount = Int.random(in: minShiftCount...maxShiftCount)
        
        for _ in 0..<shiftCount {
            var row: Int
            var value: Int
            var horizontal: Bool
            
            repeat {
                horizontal = Bool.random()
                
                if (horizontal) {
                    row = Int.random(in: 0..<level.tiles[0].count - 2)
                } else {
                    row = Int.random(in: 0..<level.tiles.count - 2)
                }
                
                if Bool.random() {
                    value = 1
                } else {
                    value = -1
                }
            } while (!gameFieldService.shiftLine(level: level, horizontal: horizontal, rowOrColumn: row, steps: value))
        }
        
        level.minimumMovesToSolve = shiftCount
        
        return level
    }
}
