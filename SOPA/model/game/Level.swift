//
//  Level.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class Level {
    var id: Int?
    var tiles: [[Tile]] = []
    var startX: Int?
    var startY: Int?
    var movesCounter = 0
    var minimumMovesToSolve: Int?
    var tilesCount: Int?
    var levelInfo: LevelInfo?
    
    init() {
        //TODO: Has implemented yet
    }
    
    func increaseMovesCounter()  {
        movesCounter += 1;
    }
}
