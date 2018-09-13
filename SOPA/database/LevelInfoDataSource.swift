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
}
