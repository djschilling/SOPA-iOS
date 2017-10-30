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
    
    let SOLVED_LEVEL_SMALL_STRINGS = [
        "5",
        "0",
        "2",
        "#",
        "nnfn",
        "sagn",
        "noon",
        "nnnn"
    ]
    let SOLVED_LEVEL_SMALL_STRINGS_HORIZONTALSHIFT = [
        "5",
        "0",
        "2",
        "#",
        "nnfn",
        "sgan",
        "noon",
        "nnnn"
    ]
    let SOLVED_LEVEL_SMALL_TILES = [
        [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : true,  tileType : TileType.START, shortcut : "s"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
        [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: true, right : true,  tileType : TileType.PUZZLE, shortcut : "a"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
        [Tile(top: false, bottom : true, left: false, right : false,  tileType : TileType.FINISH, shortcut : "f"), Tile(top: true, bottom : false, left: true, right : false,  tileType : TileType.PUZZLE, shortcut : "g"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.PUZZLE, shortcut : "o"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")],
        [Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n"), Tile(top: false, bottom : false, left: false, right : false,  tileType : TileType.NONE, shortcut : "n")]
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

    func testShiftLineBackAndForthVertical() {
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL_STINGS)
        assertFieldsEqual(tilesA : level.tiles, tilesB : SOLVED_LEVEL_TILES)

        var result = sut.shiftLine(level: level, horizontal: false, rowOrColumn: 2, steps: -1)
        XCTAssertTrue(result)
        result = sut.shiftLine(level: level, horizontal: false, rowOrColumn: 2, steps: 1)
        XCTAssertTrue(result)
        assertFieldsEqual(tilesA: level.tiles, tilesB: SOLVED_LEVEL_TILES)

    }
    func testShiftLineBackAndForthHorizontal() {
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL_STINGS)
        var _ = sut.shiftLine(level: level, horizontal: true, rowOrColumn: 2, steps: 1)
        var _ = sut.shiftLine(level: level, horizontal: true, rowOrColumn: 2, steps: -1)
        assertFieldsEqual(tilesA: level.tiles, tilesB: SOLVED_LEVEL_TILES)
        var _ = sut.shiftLine(level: level, horizontal: true, rowOrColumn: 2, steps: level.tiles.count-2)
        assertFieldsEqual(tilesA: level.tiles, tilesB: SOLVED_LEVEL_TILES)

    }
    
    func testShiftSmallRHorizontal() {
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL_SMALL_STRINGS)
        assertFieldsEqual(tilesA: level.tiles, tilesB: SOLVED_LEVEL_SMALL_TILES)
        let result = sut.shiftLine(level: level, horizontal: true, rowOrColumn: 0, steps: 1)
        let levelShifted = levelTranslator.fromString(levelLines: SOLVED_LEVEL_SMALL_STRINGS_HORIZONTALSHIFT)
        assertFieldsEqual(tilesA: level.tiles, tilesB: levelShifted.tiles)
        XCTAssertTrue(result)
        
    }
    
    func assertFieldsEqual(tilesA : [[Tile]], tilesB : [[Tile]]) {
        for column in 0...tilesA.count - 1 {
            for row in 0...tilesA[0].count - 1 {
                XCTAssertEqual(tilesA[column][row], tilesB[column][row])
            }
        }
    }
}
