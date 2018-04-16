//
//  GameScene.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var level: Level
    let gameFieldNode = SKNode()
    let startEndNode = SKNode()
    let puzzlesNode = SKNode()
    let gameFieldService = GameFieldService()
    let MIN_MOVE = CGFloat(30)
    var tileSize: CGFloat?
    var levelSolved = false
    
    init(size: CGSize, level: Level) {
        self.level = level
        super.init(size: size)
        initNodes()
    }
    
    func initNodes() {
        gameFieldNode.addChild(startEndNode)
        gameFieldNode.addChild(puzzlesNode)
        puzzlesNode.zPosition = -1
        addChild(gameFieldNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        updateGameField()
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
    func toBorders(value: Int, from: Int, to: Int) -> Int {
        if value < from {
            return from
        }
        if value > to {
            return to
        }
        return value
    }
    
    func updateGameField() {
        puzzlesNode.removeAllChildren()
        startEndNode.removeAllChildren()
        let columns = level.tiles.count
        let rows = level.tiles[0].count
        tileSize = size.width / CGFloat(level.tiles.count - 2)
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                addTile(column: column, row: row, columns: columns, rows: rows)
            }
        }
        if(gameFieldService.solvedPuzzle(level: level)) {
            levelSolved = true
            print("Level Solved")
        }
    }
    func addTile(column: Int, row: Int, columns: Int, rows: Int) {
        let tile = level.tiles[column][row]
        let shortcut = tile.shortcut
        let tileType = tile.tileType
        
        if (shortcut != "n") {
            let tileNode = TileSpriteNode(imageNamed: TILE_TEXTURES[String(tile.shortcut)]!)
            tileNode.size.width = tileSize!
            tileNode.size.height = tileSize!
            
            tileNode.position = CGPoint(x: tileSize! * CGFloat(toBorders(value: column - 1, from: 0, to: columns - 3)) + (tileSize! / 2.0), y: size.height - tileSize! * CGFloat(toBorders(value: row - 1, from: 0, to: rows-3)) + (tileSize! / 2.0) - tileSize!)
            
            if (tileType == TileType.START || tileType == TileType.FINISH) {
                rotateStartAndFinishTile(tile: tileNode, column: column, row: row, columns: columns, rows: rows)
                startEndNode.addChild(tileNode)
            }
            if (tileType == TileType.PUZZLE) {
                puzzlesNode.addChild(tileNode)
            }
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
        if(touches.contains(currentTouch!) && !levelSolved) {
            let newPos = currentTouch?.location(in: self)
            let deltaX = newPos!.x - startPoint!.x
            let deltaY = newPos!.y - startPoint!.y
            if(abs(deltaX) > abs(deltaY)) {
                if(deltaX > MIN_MOVE) {
                    _ = gameFieldService.shiftLine(level: level, horizontal: true, rowOrColumn: yToRow(startPoint!.y), steps: 1)
                    updateGameField()
                }
                if(deltaX < -MIN_MOVE) {
                    _ = gameFieldService.shiftLine(level: level, horizontal: true, rowOrColumn: yToRow(startPoint!.y), steps: -1)
                    updateGameField()
                }
            } else {
                if(deltaY > MIN_MOVE) {
                    _ = gameFieldService.shiftLine(level: level, horizontal: false, rowOrColumn: xToColumn(startPoint!.x), steps: -1)
                    updateGameField()
                }
                if(deltaY < -MIN_MOVE) {
                    _ = gameFieldService.shiftLine(level: level, horizontal: false, rowOrColumn: xToColumn(startPoint!.x), steps: 1)
                    updateGameField()
                }
            }
            currentTouch = nil
        }
    }
    func yToRow(_ y: CGFloat) -> Int {
        return Int((size.height - y) / tileSize!)
    }
    
    func xToColumn(_ x : CGFloat) -> Int {
        return Int(x / tileSize!)
    }
}

