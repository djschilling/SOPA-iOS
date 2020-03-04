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
    }
    init(level: Level) {
        copyTilesFrom(tiles: level.tiles)
        self.id = level.id
        if level.levelInfo == nil {
            levelInfo = nil;
        } else {
            levelInfo = LevelInfo(levelInfo: level.levelInfo!);
        }
        minimumMovesToSolve = level.minimumMovesToSolve;
        startX = level.startX;
        startY = level.startY;
        tilesCount = level.tilesCount;
    }
    
    func increaseMovesCounter()  {
        movesCounter += 1;
    }
    
    private func copyTilesFrom(tiles: [[Tile]]) {
        self.tiles = Array(repeating: Array(repeating: Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.UNDEFINED, shortcut: "u"), count: tiles[0].count), count: tiles.count)
        for i in [0...tiles.count - 1] {
            for j in [0...tiles[0].count - 1 ] {
                self.tiles[i][j] = tiles[i][j]
            }
        }
    }
    public var description: String {
        var s = id!.description
        s += "\n"
        s += self.minimumMovesToSolve!.description
        s += "\n"
        s += self.tilesCount!.description
        s += "\n#\n"
        for row in 0..<tiles.count {
            for column in 0..<tiles[row].count {
                s += tiles[column][row].shortcut.description
            }
            s += "\n"
        }
        return s
    }
}
