//
//  GameFieldService.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class GameFieldService {
    private let gameEndService: GameEndService

    init(gameEndService: GameEndService) {
        self.gameEndService = gameEndService
    }
    
    func solvedPuzzle(level: Level) -> Bool {
        return gameEndService.solvedPuzzle(startX: level.startX!, startY: level.startY!, width: level.tiles.count, height: level.tiles[0].count, field: level.tiles, tilesCountForLevel: level.tilesCount!)
    }
}
