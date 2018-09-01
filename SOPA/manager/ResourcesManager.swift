//
//  ResourceManager.swift
//  SOPA
//
//  Created by Raphael Schilling on 01.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
class ResourcesManager {
    static let INSTANCE = ResourcesManager()
    var levelService: LevelService?
    
    static func getInstance() -> ResourcesManager {
        return INSTANCE;
    }
    
    static func prepareManager(appDelegate: AppDelegate) {
        getInstance().levelService = LevelServiceImpl(appDelegate: appDelegate)
        
    }
}
