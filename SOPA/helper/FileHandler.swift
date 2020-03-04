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
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func writeIntoDocumentDirectory(fileName: String, conten: String) {
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try conten.write(to: url, atomically: true, encoding: .utf8)
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
}


