//
//  GameServiceImpl.swift
//  SOPA
//
//  Created by David Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class GameServiceImpl: GameService {
    private var observers = [GameSceneObserver]()
    private let gameFieldService = GameFieldService()
    private var solvedCurrentPuzzle = false
    private let level: Level
    
    init(level: Level) {
        self.level = level
        self.solvedCurrentPuzzle = gameFieldService.solvedPuzzle(level: level)
        level.increaseMovesCounter()
    }

    func solvedPuzzle() -> Bool {
        return gameFieldService.solvedPuzzle(level: self.level)
    }

    func shiftLine(horizontal: Bool, row: Int, steps: Int) {
        if !solvedCurrentPuzzle {
            let _ = gameFieldService.shiftLine(level: level, horizontal: horizontal, rowOrColumn: row, steps: steps)
            solvedCurrentPuzzle = gameFieldService.solvedPuzzle(level: level)
        }
    }
    
    func getLevel() -> Level {
        return self.level
    }
}
