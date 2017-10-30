//
//  LevelTranslatorTest.swift
//  SOPATests
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import XCTest

@testable import SOPA

class LevelTranslatorTest: XCTestCase {
    var SOLVED_LEVEL_2 = [
        "1",
        "2",
        "2",
        "#",
        "nnnn",
        "saaf",
        "noon",
        "nnnn"
    ]

    func testLevelFromString() {
        let levelTranslator = LevelTranslator()
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL_2)
        let tiles = level.tiles
        XCTAssert(level.minimumMovesToSolve == 2)
        
        XCTAssertTrue(tiles[3][2].tileType == TileType.PUZZLE)
        XCTAssertTrue(tiles[3][1].tileType == TileType.NONE)

    }
}
