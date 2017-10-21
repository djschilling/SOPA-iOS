//
//  Level.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class Level {
    var id: Int
    var tiles: [[TileType]] = []
    var startX: Int
    var startY: Int
    var movesCounter = 0
    var minimumMovesToSolve: Int
    var tilesCount: Int

    init(id: Int, tiles: [[TileType]], startX: Int, startY: Int, minimumMovesToSolve: Int, tilesCount: Int) {
        self.id = id
        self.tiles = tiles
        self.startX = startX
        self.startY = startY
        self.minimumMovesToSolve = minimumMovesToSolve
        self.tilesCount = tilesCount
    }
}
