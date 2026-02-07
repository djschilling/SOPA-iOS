//
//  LevelServiceImp.swift
//  SOPA
//
//  Created by Raphael Schilling on 12.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import OSLog
class LevelServiceImpl: LevelService {
    private let logger = Logger(subsystem: "SOPA", category: "LevelService")
    func getLevelById(id: Int) -> Level? {
        let level: Level = levelFileService.getLevel(id: id)
        guard let levelId = level.id else {
            logger.error("Loaded level without id for requested id \(id)")
            return nil
        }
        level.levelInfo = levelInfoDataSource.getLevelInfoById(id: levelId)
        return level
    }
    
    let levelInfoDataSource: LevelInfoDataSource
    let levelFileService: LevelFileService
    let starCalculator: StarCalculator
    init(appDelegate: AppDelegate) {
        levelInfoDataSource = LevelInfoDataSource(appDelegate: appDelegate)
        levelFileService = LevelFileService()
        starCalculator = StarCalculator()
    }
    func getLevelCount() -> Int {
        return levelInfoDataSource.getLevelCount()
    }
    func getLevelInfos() -> [LevelInfo] {
        return levelInfoDataSource.getAllLevelInfos()
    }
    
    func getLastUnlocked() -> LevelInfo? {
        return levelInfoDataSource.getLastUnlocked()
    }
    
    func updateLevelInfos() {
        let availableIds = levelFileService.getAvailableLevelIds()
        let storedLevelInfos = levelInfoDataSource.getAllLevelInfos()
        for currentId in availableIds {
            var found = false
            for currentLevelInfo in storedLevelInfos {
                if currentId == currentLevelInfo.levelId {
                    found = true
                    break
                }
            }
            if !found {
                _ = levelInfoDataSource.createLevelInfo(levelInfo: LevelInfo(levelId: currentId, locked: (currentId != 1), fewestMoves: -1, stars: 0, time: Double.nan))
            }
        }
        normalizeUnlockState(availableIds: availableIds)
    }
    
    private func normalizeUnlockState(availableIds: [Int]) {
        let levelInfos = levelInfoDataSource.getAllLevelInfos()
        guard let unlockedLimit = LevelServiceImpl.computeUnlockedLimit(availableIds: availableIds, levelInfos: levelInfos) else {
            return
        }
        
        for levelInfo in levelInfos {
            let shouldBeLocked = levelInfo.levelId > unlockedLimit
            if levelInfo.locked != shouldBeLocked {
                levelInfo.locked = shouldBeLocked
                _ = levelInfoDataSource.updateLevelInfo(levelInfo: levelInfo)
            }
        }
    }

    static func computeUnlockedLimit(availableIds: [Int], levelInfos: [LevelInfo]) -> Int? {
        guard let maxLevelId = availableIds.max() else {
            return nil
        }
        let highestSolvedLevel = levelInfos.filter { $0.fewestMoves >= 0 }.map { $0.levelId }.max() ?? 0
        return min(max(1, highestSolvedLevel + 1), maxLevelId)
    }
    
    func calculateLevelResult(level: Level) -> LevelResult {
        guard let minimumMoves = level.minimumMovesToSolve else {
            logger.error("Missing minimum moves for level \(level.id ?? -1)")
            return LevelResult(levelId: level.id ?? 0, moveCount: level.movesCounter, stars: 0, time: Double.nan)
        }
        guard let levelId = level.id else {
            logger.error("Missing level id when calculating result")
            return LevelResult(levelId: 0, moveCount: level.movesCounter, stars: 0, time: Double.nan)
        }
        let stars = starCalculator.getStars(neededMoves: level.movesCounter, minimumMoves: minimumMoves)
        return LevelResult(levelId: levelId, moveCount: level.movesCounter, stars: stars, time: Double.nan)
    }
    
    func persistLevelResult(levelResult: LevelResult) -> LevelInfo {
        guard let levelInfo = levelInfoDataSource.getLevelInfoById(id: levelResult.levelId) else {
            logger.error("Missing LevelInfo for level \(levelResult.levelId); creating fallback entry")
            let newLevelInfo = LevelInfo(levelId: levelResult.levelId, locked: false, fewestMoves: levelResult.moveCount, stars: levelResult.stars, time: levelResult.time)
            return levelInfoDataSource.createLevelInfo(levelInfo: newLevelInfo)
        }

        if levelInfo.fewestMoves == -1 || levelInfo.fewestMoves > levelResult.moveCount {
            levelInfo.fewestMoves = levelResult.moveCount
            levelInfo.stars = levelResult.stars
        }
        levelInfo.time = levelResult.time

        return levelInfoDataSource.updateLevelInfo(levelInfo: levelInfo)
    }
    
    func unlockLevel(levelId: Int) {
        guard let levelInfo = levelInfoDataSource.getLevelInfoById(id: levelId) else {
            logger.error("Missing LevelInfo when unlocking level \(levelId)")
            return
        }
        levelInfo.locked = false
        _ = levelInfoDataSource.updateLevelInfo(levelInfo: levelInfo)
    }
    
    func deleteAllLevelInfos() {
        levelInfoDataSource.deleteAllLevelInfos()
    }
    
    func saveLevel(level: Level) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        levelFileService.fileHandler.writeIntoDocumentDirectory(fileName: "\(hour):\(minutes):\(seconds).lv", conten: level.description)
    }
    
    func submitJustPlayScore(score: JustPlayScore) {
        levelInfoDataSource.saveJustPlayScore(score: score)
    }
    
    func getBestJustPlayScore() -> JustPlayScore? {
        return levelInfoDataSource.getBestJustPlayScore()
    }
}
