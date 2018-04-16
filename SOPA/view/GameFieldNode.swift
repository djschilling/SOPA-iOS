//
//  GamieFieldNode.swift
//  SOPA
//
//  Created by Raphael Schilling on 16.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
class GameFieldNode : SKNode {
    let startEndNode = SKNode()
    let puzzlesNode = SKNode()
    let level: Level
    let gameScene: GameScene
    var tileSize: CGFloat
    let MIN_MOVE = CGFloat(30)
    var puzzleTiles: [[TileSpriteNode]]
    
    init(level: Level, gameScene: GameScene) {
        self.level = level
        self.gameScene = gameScene
        tileSize = gameScene.size.width / CGFloat(level.tiles.count - 2)
        puzzleTiles = Array(repeating: Array(repeating: TileSpriteNode(), count: level.tiles[0].count - 2), count: level.tiles.count - 2)
        super.init()
        addChild(startEndNode)
        addChild(puzzlesNode)
        puzzlesNode.zPosition = -1
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        puzzlesNode.removeAllChildren()
        startEndNode.removeAllChildren()
        let columns = level.tiles.count
        let rows = level.tiles[0].count
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                addTile(column: column, row: row, columns: columns, rows: rows, levelSolved: gameScene.levelSolved)
            }
        }
    }
    
    func addTile(column: Int, row: Int, columns: Int, rows: Int, levelSolved: Bool) {
        let tile = level.tiles[column][row]
        let shortcut = tile.shortcut
        let tileType = tile.tileType
        if (shortcut != "n") {
            let tileNode: TileSpriteNode
            if(levelSolved) {
                tileNode = TileSpriteNode(imageNamed: TILE_TEXTURES[String(tile.shortcut).uppercased()]!)
            } else {
                tileNode = TileSpriteNode(imageNamed: TILE_TEXTURES[String(tile.shortcut)]!)
            }
            tileNode.size.width = tileSize
            tileNode.size.height = tileSize
            
            tileNode.position = CGPoint(x: tileSize * CGFloat(toBorders(value: column - 1, from: 0, to: columns - 3)) + (tileSize / 2.0), y: gameScene.size.height - tileSize * CGFloat(toBorders(value: row - 1, from: 0, to: rows-3)) + (tileSize / 2.0) - tileSize)
            
            if (tileType == TileType.START || tileType == TileType.FINISH) {
                rotateStartAndFinishTile(tile: tileNode, column: column, row: row, columns: columns, rows: rows)
                startEndNode.addChild(tileNode)
            }
            if (tileType == TileType.PUZZLE) {
                puzzlesNode.addChild(tileNode)
                puzzleTiles[column - 1][row - 1] = tileNode
            }
        }
    }
    
    func toBorders(value: Int, from: Int, to: Int) -> Int {
        if value < from {
            return from
        }
        if value > to {
            return to
        }
        return value
    }
    
    func rotateStartAndFinishTile(tile: SKSpriteNode, column: Int, row: Int, columns: Int, rows: Int) {
        if (row == 0) {
            // TOP
            tile.zRotation = -CGFloat(Double.pi) / 2
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y)
            
        } else if (column == 0) {
            // LEFT
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y)
            
        } else if (row == rows - 1) {
            // BOTTOM
            tile.zRotation = -(CGFloat(Double.pi) / 2) * 3
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y)
            
        } else if (column == columns - 1) {
            // RIGHT
            tile.zRotation = CGFloat(Double.pi)
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y)
        }
    }
    
    var currentTouch : UITouch? = nil
    var startPoint: CGPoint? = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(currentTouch == nil) {
            currentTouch = touches.first
            startPoint = currentTouch?.location(in: self)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.contains(currentTouch!)) {
            currentTouch = nil
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.contains(currentTouch!) && !gameScene.levelSolved) {
            let newPos = currentTouch?.location(in: self)
            let deltaX = newPos!.x - startPoint!.x
            let deltaY = newPos!.y - startPoint!.y
            if(abs(deltaX) > abs(deltaY)) {
                if(deltaX > MIN_MOVE) {
                    let row = yToRow(startPoint!.y)
                    animateTileSwipe(horizontal: true, rowOrColumn: row, steps: 1)
                    gameScene.moveLine(horizontal: true, rowOrColumn:  row, steps: 1)
                }
                if(deltaX < -MIN_MOVE) {
                    let row = yToRow(startPoint!.y)
                    animateTileSwipe(horizontal: true, rowOrColumn: row, steps: -1)
                    gameScene.moveLine(horizontal: true, rowOrColumn:  row, steps: -1)
                }
            } else {
                if(deltaY > MIN_MOVE) {
                    let column = xToColumn(startPoint!.x)
                    animateTileSwipe(horizontal: false, rowOrColumn: column, steps: -1)
                    gameScene.moveLine(horizontal: false, rowOrColumn:  column, steps: -1)
                }
                if(deltaY < -MIN_MOVE) {
                    let column = xToColumn(startPoint!.x)
                    animateTileSwipe(horizontal: false, rowOrColumn: column, steps: 1)
                    gameScene.moveLine(horizontal: false, rowOrColumn:  column, steps: 1)
                }
            }
            currentTouch = nil
        }
    }
    
    func animateTileSwipe(horizontal: Bool, rowOrColumn: Int, steps: Int) {
        update()
        if(horizontal) {
            let moveAction = SKAction.moveBy(x: tileSize * CGFloat(steps), y: 0, duration: 3)
            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
            for column in 0..<puzzleTiles.count {
                puzzleTiles[column][rowOrColumn].run(moveAction, completion: {self.update()})
            }
        } else {
            let moveAction = SKAction.moveBy(x: 0, y: -tileSize * CGFloat(steps), duration: 0.28)
            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
            for row in 0..<puzzleTiles[rowOrColumn].count {
                puzzleTiles[rowOrColumn][row].run(moveAction, completion: {self.update()})
            }
        }
    }
    func yToRow(_ y: CGFloat) -> Int {
        return Int((gameScene.size.height - y) / tileSize)
    }
    
    func xToColumn(_ x : CGFloat) -> Int {
        return Int(x / tileSize)
    }
}
