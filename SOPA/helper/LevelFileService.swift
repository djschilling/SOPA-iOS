//
//  LevelFileService.swift
//  SOPA
//
//  Created by Raphael Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation
class LevelFileService {
    private let LEVEL_BASE_PATH = "levels/"
    let fileHandler: FileHandler
    private let levelTranslator: LevelTranslator
    init() {
        levelTranslator = LevelTranslator()
        fileHandler = FileHandler()
    }
    
    func getLevel(id: Int) -> Level{
        let levelFilename: String = LEVEL_BASE_PATH + String(id) + ".lv"
        return levelTranslator.fromString(levelLines: fileHandler.readFromFile(filename: levelFilename))
    }
    
    
    func getAvailableLevelIds() -> [Int] {
        
        let filenamesInFolder: [String] = fileHandler.getFilenamesInFolder(folder: LEVEL_BASE_PATH);
        var levelIds: [Int] = [Int]()
        for i in filenamesInFolder {
            if(i.contains(".lv")) {
                let numberAsString : String = (i.components(separatedBy: "."))[0]
                levelIds.append(Int(numberAsString)!)
            }
        }
        return levelIds.sorted();
    }
}


