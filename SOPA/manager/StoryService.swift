//
//  StoryService.swift
//  SOPA
//
//  Created by Raphael Schilling on 05.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit

protocol StoryService {
    func loadLevelCoiceScene()
    func loadLevelCoiceSceneFromLevelModeScene()
    
    func loadJustPlaySceneFromMenuScene()
    func reloadJustPlayGameScene(level: Level)
    func loadNextJustPlayGameScene()
    
    func loadLevelModeGameSceneFromChoiceScene(levelId: Int)
    func reloadLevelModeGameScene(levelId: Int)
    func loadNextLevelModeGameScene(levelId: Int)
    
    
}
