//
//  GameFieldService.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class GameFieldService {
    private let gameEndService = GameEndService()
    
    func solvedPuzzle(level: Level) -> Bool {
        return gameEndService.solvedPuzzle(startX: level.startX!, startY: level.startY!, width: level.tiles.count, height: level.tiles[0].count, field: level.tiles, tilesCountForLevel: level.tilesCount!)
    }
    
    func shiftLine(level: Level, horizontal: Bool, rowOrColumn: Int, steps: Int) -> Bool {
        if (rowOrColumn < 0) {
            return false
        }
        if((horizontal && rowOrColumn + 2 >= level.tiles[0].count) || (!horizontal && rowOrColumn + 2 >= level.tiles.count)) {
            return false
        }

        if (horizontal) {
            let playableRows = level.tiles.count - 2;
            if (rowOrColumn < playableRows) {
                var shiftRelevant = false;
                let dummyTile = Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.NONE, shortcut: "a")
                var tileLine = [Tile](repeating: dummyTile, count: playableRows)
                
                for row in 0...playableRows - 1 {
                    if (level.tiles[row + 1][rowOrColumn + 1].shortcut != "o") {
                       shiftRelevant = true
                    }
                    
                    tileLine[row] = level.tiles[row + 1][rowOrColumn + 1]
                    //level.tiles[row + 1][rowOrColumn + 1] = nil TODO ist das nötig?
                }
                for row in 0...playableRows - 1 {
                    var newPosition = row + steps
                    newPosition = shiftToPositive(number: newPosition, steps: playableRows)
                    newPosition = newPosition % playableRows
                    level.tiles[newPosition + 1][rowOrColumn + 1] = tileLine[row]
                }
                
                if (shiftRelevant) {
                    level.increaseMovesCounter()
                    return true
                } else {
                    return false
                }
            }
        } else {
            let playableColumns = level.tiles[0].count - 2;
            if (rowOrColumn < playableColumns) {
                var shiftRelevant = false
                let dummyTile = Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.NONE, shortcut: "ä")
                var tileLine = [Tile](repeating: dummyTile, count: playableColumns)
                
                for column in 0...playableColumns - 1 {
                    tileLine[column] = level.tiles[rowOrColumn + 1][column + 1]
                    //level.tiles[rowOrColumn + 1][column] = nil TODO: wirklich nötig?
                    
                    if (tileLine[column].shortcut != "o") {
                        shiftRelevant = true
                    }
                }
                
                for column in 0...playableColumns - 1 {
                    var newPosition = column + steps
                    newPosition = shiftToPositive(number: newPosition, steps: playableColumns)
                    newPosition = newPosition % playableColumns
                    level.tiles[rowOrColumn + 1][newPosition + 1] = tileLine[column]
                }
                
                if (shiftRelevant) {
                    level.increaseMovesCounter()
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    private func shiftToPositive(number: Int, steps: Int) -> Int {
        var shifted = number
        while(shifted < 0) {
            shifted = shifted + steps
        }
        return shifted
    }

}
