//
//  LevelSolver.swift
//  SOPA
//
//  Created by Raphael Schilling on 03.03.20.
//  Copyright © 2020 David Schilling. All rights reserved.
//

import Foundation

class LevelSolver {

    var highestHit = -1

    var columns = -1
    var rows = -1
    let gameFieldService:GameFieldService
    
    init(gameFieldService: GameFieldService) {
        self.gameFieldService = gameFieldService
    }

    func solve(level: Level, maxDepth: Int)-> Level? {

        var possibleSolutions = [Level]()
        let levelToSolve = Level(level: level)
        levelToSolve.minimumMovesToSolve = maxDepth + 1
        highestHit = maxDepth + 1

        let tiles = level.tiles
        columns = tiles.count
        rows = tiles[0].count
        _ = solve(level: levelToSolve, maxDepth: maxDepth, currentDepth: 0, possibleSolutions: &possibleSolutions)

        var best = Level()
        best.minimumMovesToSolve = maxDepth + 1

        for possibleSolution in possibleSolutions {
            if (possibleSolution.minimumMovesToSolve! < best.minimumMovesToSolve!) {
                best = possibleSolution
            }
        }

        if best.minimumMovesToSolve == maxDepth + 1 {
            return nil
        } else {
            return best
        }
    }


    func solve(level: Level, maxDepth: Int, currentDepth: Int, possibleSolutions: inout [Level]) -> Bool {

        if (gameFieldService.solvedPuzzle(level: level)) {
            addPossibleSolutions(level: Level(level: level), moveCount: currentDepth, possibleSolutions: &possibleSolutions)

            if (currentDepth < highestHit) {
                highestHit = currentDepth
            }

            return true
        }

        if currentDepth < maxDepth {
            for column in 0..<columns - 2 {
                _ = gameFieldService.shiftLine(level: level, horizontal: false, rowOrColumn: column, steps: 1)

                if (currentDepth + 1 < highestHit && solve(level: level, maxDepth: maxDepth, currentDepth: currentDepth + 1, possibleSolutions: &possibleSolutions)) {
                    if (currentDepth + 1 < highestHit) {
                        return true
                    }
                }

                _ = gameFieldService.shiftLine(level: level, horizontal: false, rowOrColumn: column, steps: -2)

                if (currentDepth + 1 < highestHit && solve(level: level, maxDepth: maxDepth, currentDepth: currentDepth + 1, possibleSolutions: &possibleSolutions)) {
                    if (currentDepth + 1 < highestHit) {
                        return true
                    }
                }

                // restore state
                _ = gameFieldService.shiftLine(level: level, horizontal: false, rowOrColumn: column, steps: 1)
            }

            for row in 0..<rows - 2 {
                _ = gameFieldService.shiftLine(level: level, horizontal: true, rowOrColumn: row, steps: 1)

                if (currentDepth + 1 < highestHit && solve(level: level, maxDepth: maxDepth, currentDepth: currentDepth + 1, possibleSolutions: &possibleSolutions)) {
                    if (currentDepth + 1 < highestHit) {
                        return true
                    }
                }

                _ = gameFieldService.shiftLine(level: level, horizontal: true, rowOrColumn: row, steps: -2)

                if (currentDepth + 1 < highestHit && solve(level: level, maxDepth: maxDepth, currentDepth: currentDepth + 1, possibleSolutions: &possibleSolutions)) {
                    if (currentDepth + 1 < highestHit) {
                        return true
                    }
                }

                // restore state
                _ = gameFieldService.shiftLine(level: level, horizontal: true, rowOrColumn: row, steps: 1)
            }
        }

        return false
    }


    func addPossibleSolutions(level: Level, moveCount: Int, possibleSolutions: inout [Level]) {

        if (level.minimumMovesToSolve! > moveCount) {
            level.minimumMovesToSolve = moveCount
            possibleSolutions.append(level)
        }
        return
    }
}
