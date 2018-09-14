//
//  LogFileHandler.swift
//  SOPA
//
//  Created by Raphael Schilling on 13.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation

struct LogFileHandler: TextOutputStream {
    
    /// Appends the given string to the stream.
    mutating func write(_ string: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath = paths.first!
        let log = documentDirectoryPath.appendingPathComponent("log.txt")
        
        do {
            let handle = try FileHandle(forWritingTo: log)
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } catch {
            print(error.localizedDescription)
            do {
                try string.data(using: .utf8)?.write(to: log)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func readLog() -> String{
        let file = "log.txt" //this is the file. we will write to and read from it
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                return text
            }
            catch {
                print("File not found")
            }
        }
        return "File not found"
    }
    
    static var logger: LogFileHandler = LogFileHandler()
    
}
