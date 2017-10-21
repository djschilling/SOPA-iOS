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
    
    init(size: CGSize, level: Level) {
        self.level = level
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        let columns = level.tiles.count
        let rows = level.tiles[0].count
        let tileSize = size.width / CGFloat(level.tiles.count - 2)
        
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                let tile = level.tiles[column][row]
                let shortcut = tile.shortcut
                let tileType = tile.tileType

                if (shortcut != "n") {
                    let tileNode = SKSpriteNode(imageNamed: TILE_TEXTURES[String(shortcut)]!)
                    tileNode.size.width = tileSize
                    tileNode.size.height = tileSize
                    
                    tileNode.position = CGPoint(x: tileSize * CGFloat(max(column - 1, 0)) + (tileSize / 2.0), y: size.height - tileSize * CGFloat(max(row - 1, 0)) + (tileSize / 2.0))
                    
                    if (tileType == TileType.START || tileType == TileType.FINISH) {
                        rotateStartAndFinishTile(tile: tileNode, column: column, row: row, columns: columns, rows: rows)
                    }
                    
                    addChild(tileNode)
                }
            }
        }
    }
    
    func rotateStartAndFinishTile(tile: SKSpriteNode, column: Int, row: Int, columns: Int, rows: Int) {
        if (row == 0) {
            // TOP
            tile.zRotation = CGFloat(Double.pi) / 2
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y + tile.size.height)
            
        } else if (column == 0) {
            // LEFT
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y)
            
        } else if (row == rows - 1) {
            // BOTTOM
            tile.zRotation = (CGFloat(Double.pi) / 2) * 3
            tile.position = CGPoint(x: tile.position.x, y: tile.position.y - tile.size.height)
            
        } else if (column == columns - 1) {
            // RIGHT
            tile.zRotation = CGFloat(Double.pi)
            tile.position = CGPoint(x: tile.position.x - tile.size.width, y: tile.position.y)
            
        }
    }
}

