//
//  LevelTranslator.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation


class LevelTranslator {
    
    func fromString(levelLines: [String]) -> Level {
        var indexOfProperties = 0

        let level = Level()
        
        while !levelLines[indexOfProperties].hasPrefix("#") {
            switch indexOfProperties {
            case 0:
                level.id = Int(levelLines[indexOfProperties])
            case 1:
                level.minimumMovesToSolve = Int(levelLines[indexOfProperties])
            case 2:
                level.tilesCount = Int(levelLines[indexOfProperties])
            default:
                break
            }
            indexOfProperties += 1
        }
        
        let fieldLines = Array(levelLines[(indexOfProperties + 1)...])
        let tiles = getTiles(fieldLines: fieldLines, level: level)
        level.tiles = tiles;
        return level
    }
    
    private func getTiles(fieldLines: [String], level: Level) -> [[Tile]] {
        
        let columns = fieldLines[0].count
        var rows = fieldLines.count
        if(fieldLines[fieldLines.count - 1] == "") {
            rows = fieldLines.count - 1
        }
        let dummyTile = Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.NONE, shortcut: "a")
        var tiles = [[Tile]](repeating: [Tile](repeating: dummyTile, count: rows), count: columns)

        
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                var currentTile = CHARACTER_TILE_MAP[String(Array(fieldLines[row])[column])];

                // Set direction for start end end
                if (currentTile?.tileType != TileType.NONE) {
                    if (row == 0) {
                        checkInvalidTile(tile: currentTile!);
                        currentTile?.bottom = true
                    }
                    if (row == rows - 1) {
                        checkInvalidTile(tile: currentTile!);
                        currentTile?.top = true
                    }
                    if (column == 0) {
                        checkInvalidTile(tile: currentTile!);
                        currentTile?.right = true
                    }
                    if (column == columns - 1) {
                        checkInvalidTile(tile: currentTile!);
                        currentTile?.left = true
                    }
                }
                tiles[column][row] = currentTile!;
                
                if (currentTile?.tileType == TileType.START) {
                    level.startX = column
                    level.startY = row
                }
            }
        }
        return tiles;
    }
    
    private func checkInvalidTile(tile: Tile) {
        if (tile.tileType == TileType.PUZZLE) {
            print("Just Finish, Start and None allowed in the borders")
        }
    }
}

