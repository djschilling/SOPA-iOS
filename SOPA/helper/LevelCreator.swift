


/**
 * @author  David Schilling - davejs92@gmail.com
 * @author  Raphael Schilling
 */
import Foundation

class LevelCreator {
    
    private let levelDestroyer: LevelDestroyer
    private let levelSolver: LevelSolver
    private let directionsX = [0, 1, 0, -1]
    private let directionsY = [1, 0, -1, 0]
    
    init() {
        levelDestroyer = LevelDestroyer()
        levelSolver = LevelSolver(gameFieldService: GameFieldService())
    }
    

    
    
    func generateSolvedField(width: Int, height: Int, minTubes: Int, maxTubes: Int) -> Level {
        while true {
            var number = 0
            let level = Level()
            let startX: Int
            let startY: Int
            var direction: Int
            
            let undefinedTile = Tile()
            var tiles = Array(repeating: Array(repeating:  undefinedTile, count: height), count: width)
            
            for i in 1..<width - 1 {
                for j in 1..<height - 1 {
                    tiles[i][j] = Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.UNDEFINED, shortcut: "o")
                }
            }
            
            
            for i in 0..<width {
                tiles[i][0] = Tile()
            }
            
            for i in 0..<width {
                tiles[i][height - 1] = Tile()
            }
            
            for i in 0..<height {
                tiles[0][i] = Tile()
            }
            
            for i in 0..<height {
                tiles[width - 1][i] = Tile()
            }
            
            var startTile: Tile
            
            switch Int.random(in: 0..<4) {
            case 0:
                startTile = Tile(top: false, bottom: true, left: false, right: false, tileType: TileType.START, shortcut: "s")
                startX = Int.random(in: 1..<width - 1)
                startY = 0
                direction = 0
                tiles[startX][0] = startTile
                
                
            case 1:
                startTile = Tile(top: true, bottom: false, left: false, right: false, tileType: TileType.START, shortcut: "s")
                startX = Int.random(in: 1..<width - 1)
                startY = height - 1
                direction = 2
                tiles[startX][height - 1] = startTile
                
                
            case 2:
                startTile = Tile(top: false, bottom: false, left: false, right: true, tileType: TileType.START, shortcut: "s")
                startX = 0
                startY = Int.random(in: 1..<height - 1)
                direction = 1
                tiles[startX][startY] = startTile
                
                
            case 3:
                startTile = Tile(top: false, bottom: false, left: true, right: false, tileType: TileType.START, shortcut: "s")
                startX = width - 1
                startY = Int.random(in: 1..<height - 1)
                direction = 3
                tiles[startX][startY] = startTile

            default:
                startTile = Tile(top: false, bottom: true, left: false, right: false, tileType: TileType.START, shortcut: "s")
                startX = 1
                startY = 0
                direction = 0
                tiles[startX][startY] = startTile
            }
            
            var x = startX
            var y = startY
            
            while (x != 0 && x != width - 1 && y != 0 && y != height - 1 || x == startX && y == startY) {
                number += 1
                
                if (Int.random(in: 0..<10) < 7 && !(startX == x && startY == y)) {
                    direction = Int.random(in: 0..<4)
                }
                
                var xNew = x + directionsX[direction]
                var yNew = y + directionsY[direction]
                var directions = [false, false, false, false]
                
                while (tiles[xNew][yNew].tileType != TileType.UNDEFINED && tiles[xNew][yNew].shortcut != "n") {
                    if (directions[0] && directions[1] && directions[2] && directions[3]) {
                        return generateSolvedField(width: width, height: height, minTubes: minTubes, maxTubes: maxTubes)
                    }
                    
                    directions[direction] = true
                    direction = Int.random(in: 0..<4)
                    xNew = x + directionsX[direction]
                    yNew = y + directionsY[direction]
                }
                
                switch direction {
                case 0:
                    tiles[x][y].bottom = true
                    tiles[xNew][yNew].top = true
                    
                    
                case 1:
                    tiles[x][y].right = true
                    tiles[xNew][yNew].left = true
                    
                    
                case 2:
                    tiles[x][y].top = true
                    tiles[xNew][yNew].bottom = true
                    
                case 3:
                    tiles[x][y].left = true
                    tiles[xNew][yNew].right = true

                default:
                    break
                }
                
                x = xNew
                y = yNew
                tiles[x][y].tileType = TileType.PUZZLE
            }
            
            for i in 1..<width - 1 {
                for j in 1..<height - 1 {
                    tiles[i][j].tileType = TileType.PUZZLE
                    tiles[i][j].shortcut = Character(TILE_CHARACTER_MAP[tiles[i][j]]!)
                }
            }
            
            tiles[x][y].tileType = TileType.FINISH
            tiles[x][y].shortcut = "f"
            level.startX = startX
            level.startY = startY
            level.tiles = tiles
            level.tilesCount = number - 1
            
            if number - 1 >= minTubes && maxTubes >= number - 1 {
                return level
            }
            
        }
        
        
        
    }
    
    func generateLevel(size: Int, moves: Int, minTubes: Int, maxTubes: Int)-> Level {
        
        var level: Level
        
        repeat {
            level = levelDestroyer.destroyField(level: generateSolvedField(width: size, height: size, minTubes: minTubes, maxTubes: maxTubes), minShiftCount: moves, maxShiftCount: moves)
        } while (!levelSolver.isOptimumRight(level: level, maxMoves: moves))
        
        return level
    }
    
    
    
}
