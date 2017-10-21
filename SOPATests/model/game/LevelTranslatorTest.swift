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
    var SOLVED_LEVEL = [
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

    func testExample() {
        let levelTranslator = LevelTranslator()
        let level = levelTranslator.fromString(levelLines: SOLVED_LEVEL)
        XCTAssert(level.minimumMovesToSolve == 4)
    }
}
