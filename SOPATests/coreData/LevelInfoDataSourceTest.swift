//
//  LevelInfoDataSourceTest.swift
//  SOPATests
//
//  Created by Raphael Schilling on 12.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import XCTest

class LevelInfoDataSourceTest: XCTestCase {
    
    let sut = LevelInfoDataSource(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
