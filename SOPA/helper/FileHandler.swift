//
//  FileHandler.swift
//  SOPA
//
//  Created by Raphael Schilling on 30.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

class FileHandler {
    init() {
        
    }
    func readFromFile(filename : String) -> [String] {
        if let path = Bundle.main.path(forResource: filename, ofType: "") {
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            return multipleLineStringToArray(data: data)
        }
            catch {print("FileHanlder Error")}
        } else {
            print("FileHanlder Error")
        }
        return []
    }
    
    private func multipleLineStringToArray(data: String) -> [String] {
        return data.components(separatedBy: "\n")
    }
    
    func getFilenamesInFolder(folder: String) -> [String] {
        let docsPath = Bundle.main.resourcePath! + "/" + folder
        let fileManager = FileManager.default
        
        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath)
            return docsArray;
        } catch {
            print(error)
        }
        return []
    }
}


