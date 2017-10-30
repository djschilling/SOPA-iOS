//
//  GameFieldServiceTest.swift
//  SOPATests
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import XCTest
@testable import SOPA

class GameFieldServiceTest: XCTestCase {
    
    let sut = GameFieldService(gameEndService: GameEndService())
    let levelTranslator = LevelTranslator()

    let SOLVED_LEVEL_STINGS = [
        "21",
        "4",
        "4",
        "#",
        "nnnnnn",
        "noooon",
        "saaaaf",
        "noooon",
        "noooon",
        "nnnnnn"
    ]
    let SOLVED_LEVEL_TILES = [
        [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : true,  tileType : TileType.START, shortcut : "s"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
        [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: true, right : true,  tileType : TileType.PUZZLE, shortcut : "a"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
    [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: true, right : true,  tileType : TileType.PUZZLE, shortcut : "a"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
    [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: true, right : true,  tileType : TileType.PUZZLE, shortcut : "a"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
    [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: true, right : true,  tileType : TileType.PUZZLE, shortcut : "a"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
    [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: true, right : false,  tileType : TileType.FINISH, shortcut : "f"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")]
    ]

    func testSolvePuzzleCheck() {
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL_STINGS)
        XCTAssertTrue(sut.solvedPuzzle(level: level))
    }

    func testShiftLine() {
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL_STINGS)
        XCTAssertTrue(fieldsEqual(tilesA : level.tiles, tilesB : SOLVED_LEVEL_TILES))

        var result = sut.shiftLine(level: level, horizontal: false, rowOrColumn: 2, steps: 0)
        XCTAssertTrue(result)
        result = sut.shiftLine(level: level, horizontal: false, rowOrColumn: 2, steps: 0)
        XCTAssertTrue(result)
        XCTAssertTrue(fieldsEqual(tilesA: level.tiles, tilesB: SOLVED_LEVEL_TILES))

    }
    
    func fieldsEqual(tilesA : [[Tile]], tilesB : [[Tile]]) -> Bool {
        for column in 0...tilesA.count - 1 {
            for row in 0...tilesA[0].count - 1 {
                if(!(tilesA[column][row] == tilesB[column][row])) {
                    return false
                }
            }
        }
        return true
    }
}
