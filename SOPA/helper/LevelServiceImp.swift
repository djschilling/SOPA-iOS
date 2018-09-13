//
//  LevelServiceImp.swift
//  SOPA
//
//  Created by Raphael Schilling on 12.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
class LevelServiceImpl: LevelService {
    func getLevelById(id: Int) -> Level? {
        let level: Level = levelFileService.getLevel(id: id)
        level.levelInfo = levelInfoDataSource.getLevelInfoById(id: level.id!)
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
    }
    
    func calculateLevelResult(level: Level) -> LevelResult {
        let stars = starCalculator.getStars(neededMoves: level.movesCounter, minimumMoves: level.minimumMovesToSolve!)
        return LevelResult(levelId: level.id!, moveCount: level.movesCounter, stars: stars, time: Double.nan)
    }
    
    func persistLevelResult(levelResult: LevelResult) -> LevelInfo {
        let levelInfo = levelInfoDataSource.getLevelInfoById(id: levelResult.levelId)
        
        if levelInfo!.fewestMoves == -1 || levelInfo!.fewestMoves > levelResult.moveCount {
            levelInfo?.fewestMoves = levelResult.moveCount
            levelInfo?.stars = levelResult.stars
        }
        levelInfo?.time = levelResult.time

        return levelInfoDataSource.updateLevelInfo(levelInfo: levelInfo!)
    }
    
    func unlockLevel(levelId: Int) {
        let levelInfo = levelInfoDataSource.getLevelInfoById(id: levelId)
        levelInfo?.locked = false
        _ = levelInfoDataSource.updateLevelInfo(levelInfo: levelInfo!)
    }
    
    func deleteAllLevelInfos() {
        levelInfoDataSource.deleteAllLevelInfos()
    }
}
