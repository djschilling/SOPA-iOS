//
//  FileHandlerTest.swift
//  SOPATests
//
//  Created by Raphael Schilling on 30.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import XCTest

@testable import SOPA

class FileHandlerTest: XCTestCase {
    let FILE_LEVEL0_CONTENT = ["Erste Linie", "Zweite Linie", "Dritte Linie", "", "5. Linie", ""]
    func testReadFile() {
        let fileHandler = FileHandler()
        XCTAssertEqual(fileHandler.readFromFile(filename: "levels/level0.txt") , FILE_LEVEL0_CONTENT)
        
        let levelFileService : LevelFileService = LevelFileService()
        XCTAssertTrue(levelFileService.getAvailableLevelIds().count == 100)
    }
    
    func getLevelIDs() {
    }
}
