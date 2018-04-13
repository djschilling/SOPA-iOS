//
//  LevelService.swift
//  SOPA
//
//  Created by Raphael Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation
protocol LevelService {
    
    func getLevelCount() -> Int;
    
    func getLevelById(id: Int) -> Level?;
    
    func getLevelInfos() -> [LevelInfo];
    
    func getLastUnlocked() -> LevelInfo?;
    
    func updateLevelInfos();
    
    func calculateLevelResult(level: Level) -> LevelResult;
    
    func persistLevelResult(levelResult: LevelResult ) -> LevelInfo;
    
    func unlockLevel(levelId: Int);
}
