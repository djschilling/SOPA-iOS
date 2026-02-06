import XCTest
@testable import SOPA

final class LevelServiceImplUnlockingTest: XCTestCase {
    func testFreshStateOnlyLevelOneUnlockedLimit() {
        let availableIds = Array(1...100)
        let levelInfos = availableIds.map {
            LevelInfo(levelId: $0, locked: ($0 != 1), fewestMoves: -1, stars: 0, time: .nan)
        }
        let unlockedLimit = LevelServiceImpl.computeUnlockedLimit(availableIds: availableIds, levelInfos: levelInfos)

        XCTAssertEqual(unlockedLimit, 1)
    }

    func testUnlockedLimitIsHighestSolvedPlusOne() {
        let availableIds = Array(1...100)
        let levelInfos = availableIds.map {
            LevelInfo(levelId: $0, locked: false, fewestMoves: ($0 <= 3 ? 10 : -1), stars: 0, time: .nan)
        }
        let unlockedLimit = LevelServiceImpl.computeUnlockedLimit(availableIds: availableIds, levelInfos: levelInfos)

        XCTAssertEqual(unlockedLimit, 4)
    }

    func testUnlockedLimitDoesNotExceedMaxAvailableLevel() {
        let availableIds = Array(1...100)
        let levelInfos = availableIds.map {
            LevelInfo(levelId: $0, locked: false, fewestMoves: 1, stars: 3, time: 1.0)
        }
        let unlockedLimit = LevelServiceImpl.computeUnlockedLimit(availableIds: availableIds, levelInfos: levelInfos)

        XCTAssertEqual(unlockedLimit, 100)
    }
}
