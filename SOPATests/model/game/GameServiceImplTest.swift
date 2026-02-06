import XCTest
@testable import SOPA

final class GameServiceImplTest: XCTestCase {
    private let levelTranslator = LevelTranslator()

    private let solvedLevelStrings = [
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

    func testShiftLineDoesNothingWhenPuzzleIsAlreadySolved() {
        let level = levelTranslator.fromString(levelLines: solvedLevelStrings)
        let sut = GameServiceImpl(level: level)

        let beforeMoveCount = level.movesCounter
        let beforeRow = level.tiles.map { $0[2].shortcut }

        sut.shiftLine(horizontal: true, row: 1, steps: 1)

        let afterRow = level.tiles.map { $0[2].shortcut }
        XCTAssertEqual(level.movesCounter, beforeMoveCount)
        XCTAssertEqual(afterRow, beforeRow)
        XCTAssertTrue(sut.solvedPuzzle())
    }
}
