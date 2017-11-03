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

    func shiftLine(horizontal: Bool, row: Int, steps: Int, silent: Bool) {
        if !solvedCurrentPuzzle {
            let _ = gameFieldService.shiftLine(level: level, horizontal: horizontal, rowOrColumn: row, steps: steps)
            solvedCurrentPuzzle = gameFieldService.solvedPuzzle(level: level)
            
            if !silent {
                notifyAllObserver()
            }
        }
    }
    
    func getLevel() -> Level {
        return self.level
    }
    
    func attach(observer: GameSceneObserver) {
        observers.append(observer)
    }

    func detatch(observer: GameSceneObserver) {
        observers = observers.filter{ $0.id != observer.id }
    }
    
    func notifyAllObserver() {
        observers.forEach{ $0.updateGameScene() }
    }
    
}
