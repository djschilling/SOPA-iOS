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
    let SOLVED_LEVEL = [
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

    func testExample() {
        let levelTranslator = LevelTranslator()
        let gameFieldService = GameFieldService(gameEndService: GameEndService())
        
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL)
        XCTAssertTrue(gameFieldService.solvedPuzzle(level: level))
        
    }
}
