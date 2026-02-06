//
//  LevelInfoDataSource.swift
//  SOPA
//
//  Created by Raphael Schilling on 11.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//
import CoreData
import Foundation
public class LevelInfoDataSource {
    let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    init(appDelegate: AppDelegate){
        self.appDelegate = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func createLevelInfo(levelInfo: LevelInfo) -> LevelInfo {
        if(getLevelInfoById(id: levelInfo.levelId) != nil) {
            fatalError()
        }
        let entity = NSEntityDescription.entity(forEntityName: "LevelInfo", in: context)
        let newLevelInfo = NSManagedObject(entity: entity!, insertInto: context)
        newLevelInfo.setValue(levelInfo.levelId, forKey: "id")
        newLevelInfo.setValue(levelInfo.fewestMoves, forKey: "fewest_moves")
        newLevelInfo.setValue(levelInfo.locked, forKey: "locked")
        newLevelInfo.setValue(levelInfo.stars, forKey: "stars")
        newLevelInfo.setValue(levelInfo.time, forKey: "time")
        appDelegate.saveContext()
        return levelInfo;
    }
    
    func updateLevelInfo(levelInfo: LevelInfo) -> LevelInfo {
        let oldLevelFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "LevelInfo")
        oldLevelFetch.predicate = NSPredicate(format: "id == " + String(levelInfo.levelId) )
        do {
            let fetchedLevelInfos = try context.fetch(oldLevelFetch)
            if(fetchedLevelInfos.count != 1) {
                fatalError()
            }
            let oldLevel = fetchedLevelInfos[0] as! LevelInfoMO
            oldLevel.stars = Int16(levelInfo.stars)
            oldLevel.fewest_moves = Int16(levelInfo.fewestMoves)
            oldLevel.locked = levelInfo.locked
            oldLevel.time = levelInfo.time
            appDelegate.saveContext()
            return levelInfo
        } catch {
            fatalError()
        }
    }
    
    func getAllLevelInfos() -> [LevelInfo]{
        let levelInfoFetch = NSFetchRequest<LevelInfoMO>(entityName: "LevelInfo")
        levelInfoFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do{
            let levelInfosMO = try context.fetch(levelInfoFetch)
            var levelInfos: [LevelInfo] = []
            for levelInfoMO in levelInfosMO {
                levelInfos.append(LevelInfo(levelInfoMO: levelInfoMO))
            }
            return levelInfos
        } catch {
            fatalError()
        }
    }
    
    func getLevelInfoById(id: Int) -> LevelInfo? {
        let oldLevelFetch = NSFetchRequest<LevelInfoMO>(entityName: "LevelInfo")
        oldLevelFetch.predicate = NSPredicate(format: "id == " + String(id))
        do {
            let fetchedLevelInfos = try context.fetch(oldLevelFetch)
            if(fetchedLevelInfos.count < 1) {
                return nil
            }
            let levelInfoMO = fetchedLevelInfos[0]
            let levelInfo = LevelInfo(levelInfoMO: levelInfoMO)
            return levelInfo
        } catch {
            fatalError()
        }
    }
    
    func getLevelCount() -> Int {
        return getAllLevelInfos().count
    }
    
    
    func getLastUnlocked() -> LevelInfo? {
        let unlockedLevelsFetch = NSFetchRequest<LevelInfoMO>(entityName: "LevelInfo")
        unlockedLevelsFetch.predicate = NSPredicate(format: "locked == false")
        unlockedLevelsFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        do {
            let unlockedLevelsMO = try context.fetch(unlockedLevelsFetch)
            if(unlockedLevelsMO.count == 0) {
                return nil
            }
            return LevelInfo(levelInfoMO: unlockedLevelsMO[0])
        } catch {
            fatalError()
        }
    }
    
    func deleteAllLevelInfos() {
        let levelInfoFetch = NSFetchRequest<LevelInfoMO>(entityName: "LevelInfo")
        do{
            let levelInfosMO = try context.fetch(levelInfoFetch)
            for levelInfoMO in levelInfosMO {
                context.delete(levelInfoMO)
            }
        } catch {
            fatalError()
        }
    }
    
    func saveJustPlayScore(score: JustPlayScore) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JustPlayResults")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "scorePoints", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                let entity = NSEntityDescription.entity(forEntityName: "JustPlayResults", in: context)
                let newEntry = NSManagedObject(entity: entity!, insertInto: context)
                newEntry.setValue(Int64(score.points), forKey: "scorePoints")
                newEntry.setValue(Int64(score.solvedLevels), forKey: "solvedLevels")
            } else if let currentBest = result.first {
                let points = Int(currentBest.value(forKey: "scorePoints") as? Int64 ?? 0)
                if score.points > points {
                    currentBest.setValue(Int64(score.points), forKey: "scorePoints")
                    currentBest.setValue(Int64(score.solvedLevels), forKey: "solvedLevels")
                }
            }
            appDelegate.saveContext()
        } catch {
            fatalError()
        }
    }
    
    func getBestJustPlayScore() -> JustPlayScore? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JustPlayResults")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "scorePoints", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let currentBest = result.first else {
                return nil
            }
            let points = Int(currentBest.value(forKey: "scorePoints") as? Int64 ?? 0)
            let solvedLevels = Int(currentBest.value(forKey: "solvedLevels") as? Int64 ?? 0)
            return JustPlayScore(points: points, solvedLevels: solvedLevels)
        } catch {
            fatalError()
        }
    }
}
