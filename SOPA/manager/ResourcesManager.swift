//
//  ResourceManager.swift
//  SOPA
//
//  Created by Raphael Schilling on 01.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
class ResourcesManager {
    static let INSTANCE = ResourcesManager()
    var levelService: LevelService?
    var storyService: StoryService?
    
    static func getInstance() -> ResourcesManager {
        return INSTANCE;
    }
    
    static func prepareManager(appDelegate: AppDelegate, size: CGSize, skView: SKView) {
        getInstance().levelService = LevelServiceImpl(appDelegate: appDelegate)
        getInstance().storyService = StoryServiceImpl(size: size, levelService: getInstance().levelService!, skView: skView)
    }
}
