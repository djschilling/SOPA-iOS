import XCTest
@testable import SOPA

final class JustPlayHighscorePersistenceTest: XCTestCase {
    private var sut: LevelServiceImpl!

    override func setUp() {
        super.setUp()
        let appDelegate = AppDelegate()
        sut = LevelServiceImpl(appDelegate: appDelegate)
    }

    func testHighscoreOnlyIncreases() {
        let currentBest = sut.getBestJustPlayScore()?.points ?? 0
        let base = max(currentBest + 1000, 1_000_000)

        sut.submitJustPlayScore(score: JustPlayScore(points: base, solvedLevels: 4))
        XCTAssertEqual(sut.getBestJustPlayScore()?.points, base)

        sut.submitJustPlayScore(score: JustPlayScore(points: base - 200, solvedLevels: 2))
        XCTAssertEqual(sut.getBestJustPlayScore()?.points, base)

        sut.submitJustPlayScore(score: JustPlayScore(points: base + 350, solvedLevels: 9))
        XCTAssertEqual(sut.getBestJustPlayScore()?.points, base + 350)
        XCTAssertEqual(sut.getBestJustPlayScore()?.solvedLevels, 9)
    }
}
