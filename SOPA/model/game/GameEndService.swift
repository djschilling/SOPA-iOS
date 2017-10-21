//
//  GameEndService.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class GameEndService {
    
    private var pathState: [[PathState]]?;
    private var field: [[Tile]]?;
    private let directionsX = [0, 1, 0, -1]
    private let directionsY = [1, 0, -1, 0]
    
    func solvedPuzzle(startX: Int, startY: Int, width: Int, height: Int, field: [[Tile]], tilesCountForLevel: Int) -> Bool {
        self.field = field
        initializePathState(width: width, height: height)
        return searchFinish(x: startX, y: startY, numberMissingTiles: tilesCountForLevel)
    }

    private func initializePathState(width: Int, height: Int) {
        pathState = [[PathState]](repeating: [PathState](repeating: PathState.UNDEFINED, count: height), count: width)
    }
    
    private func searchFinish(x: Int, y: Int, numberMissingTiles: Int) -> Bool {
        
        for directionCount in 0...3 {
            let xNew = x + directionsX[directionCount]
            let yNew = y + directionsY[directionCount]
            if (possibleTile(x: x, y: y, xNew: xNew, yNew: yNew, directionCount: directionCount)) {
                extendSolution(x: xNew, y: yNew)
                
                if(!foundFinish(x: xNew, y: yNew)) {
                    if(searchFinish(x: xNew, y: yNew, numberMissingTiles: numberMissingTiles - 1)) {
                        return true
                    } else {
                        markAsImpossible(x: xNew, y: yNew)
                    }
                } else {
                    return numberMissingTiles <= 0
                }
            }
        }
        return false
    }

    private func possibleTile(x: Int, y: Int, xNew: Int, yNew: Int, directionCount: Int) -> Bool {
        
        if (xNew >= 0 && xNew < field!.count && yNew >= 0 && yNew < field![0].count) {
            let tileNew: Tile = field![xNew][yNew]
            let tile: Tile = field![x][y]
            
            if (tileNew.tileType != TileType.NONE && pathState![xNew][yNew] == PathState.UNDEFINED) {
                switch directionCount {
                case 0:
                    if (tile.bottom && tileNew.top) {
                        return true
                    }
                case 1:
                    if (tile.right && tileNew.left) {
                        return true
                    }
                case 2:
                    if (tile.top && tileNew.bottom) {
                        return true
                    }
                case 3:
                    if (tile.left && tileNew.right) {
                        return true
                    }
                default:
                    return false
                }
            }
        }
        return false
    }
    
    private func extendSolution(x: Int, y: Int) {
        pathState![x][y] = PathState.POSIBLE
    }
    
    private func foundFinish(x: Int, y: Int) -> Bool {
        return field![x][y].tileType == TileType.FINISH
    }
    
    private func markAsImpossible(x: Int, y: Int) {
        pathState![x][y] = PathState.IMPOSSIBLE
    }

}
