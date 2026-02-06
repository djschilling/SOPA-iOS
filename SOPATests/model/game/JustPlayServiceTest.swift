import XCTest
@testable import SOPA

final class JustPlayServiceTest: XCTestCase {
    func testScoreAndDifficultyProgressionAtBoundaries() {
        let service = JustPlayServiceImpl()

        // Level 1 -> difficulty 0 (maxScore 5)
        var result = service.calculateResult(
            justPlayLevelResult: JustPlayLevelResult(leftTime: 10, moves: 1, minLevelMoves: 1)
        )
        XCTAssertEqual(result.lastScore, 0)
        XCTAssertEqual(result.score, 5)
        XCTAssertEqual(result.extraTime, 5)
        XCTAssertEqual(result.levelCount, 1)

        // Level 2 -> difficulty 0 again
        result = service.calculateResult(
            justPlayLevelResult: JustPlayLevelResult(leftTime: 10, moves: 1, minLevelMoves: 1)
        )
        XCTAssertEqual(result.lastScore, 5)
        XCTAssertEqual(result.score, 10)
        XCTAssertEqual(result.levelCount, 2)

        // Level 3 -> difficulty 1 (maxScore 10)
        result = service.calculateResult(
            justPlayLevelResult: JustPlayLevelResult(leftTime: 10, moves: 1, minLevelMoves: 1)
        )
        XCTAssertEqual(result.lastScore, 10)
        XCTAssertEqual(result.score, 20)
        XCTAssertEqual(result.levelCount, 3)
    }

    func testLostRoundDoesNotIncreaseScore() {
        let service = JustPlayServiceImpl()

        _ = service.calculateResult(
            justPlayLevelResult: JustPlayLevelResult(leftTime: 10, moves: 1, minLevelMoves: 1)
        )
        let resultAfterLoss = service.calculateResult(
            justPlayLevelResult: JustPlayLevelResult(leftTime: -1, moves: 99, minLevelMoves: 1)
        )

        XCTAssertEqual(resultAfterLoss.lastScore, 5)
        XCTAssertEqual(resultAfterLoss.score, 5)
    }

    func testExtraTimeIsCappedAtThirtyFive() {
        let service = JustPlayServiceImpl()

        let result = service.calculateResult(
            justPlayLevelResult: JustPlayLevelResult(leftTime: 34, moves: 1, minLevelMoves: 1)
        )

        XCTAssertEqual(result.extraTime, 1)
        XCTAssertEqual(result.leftTime, 34)
    }
}
