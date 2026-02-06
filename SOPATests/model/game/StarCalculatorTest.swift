import XCTest
@testable import SOPA

final class StarCalculatorTest: XCTestCase {
    private let sut = StarCalculator()

    func testReturnsThreeStarsWhenNeededMovesAtOrBelowMinimum() {
        XCTAssertEqual(sut.getStars(neededMoves: 8, minimumMoves: 8), 3)
        XCTAssertEqual(sut.getStars(neededMoves: 7, minimumMoves: 8), 3)
    }

    func testReturnsTwoStarsWhenRatioIsAboveSixtyPercent() {
        XCTAssertEqual(sut.getStars(neededMoves: 9, minimumMoves: 6), 2)
    }

    func testReturnsOneStarWhenRatioIsSixtyPercentOrBelow() {
        XCTAssertEqual(sut.getStars(neededMoves: 10, minimumMoves: 6), 1)
        XCTAssertEqual(sut.getStars(neededMoves: 12, minimumMoves: 6), 1)
    }
}
