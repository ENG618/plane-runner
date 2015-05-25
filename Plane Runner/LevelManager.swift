//
//  LevelManager.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import Foundation
import GameKit

enum Levels {
    case LevelOne
    case LevelTwo
}
    

class LevelManager: NSObject, NSCoding {
    
    // Singleton
    static let sharedInstance = LevelManager()
    
    // Game Center
    let player = Player.sharedInstance
    
    // Key constants
    let PRStarsForLevelKey = "StarsForLevel"
    let PRLevelManagerTotalStarsKey = "totalStars"
    let PRLevelManagerTotalDistanceKey = "totalDistance"
    
    // Score
    var distance: Int = 0
    var starsCollected: Int = 0
    
    // Totals
    var totalDistance: Int = 0
    var totalStarsCollected: Int = 0
    
    // Level Totals
    var levelOneStars: Int = 0
    var levelTwoStars: Int = 0
    
    // User Defaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.starsCollected = 0
        self.distance = 0
        self.totalStarsCollected = aDecoder.decodeIntegerForKey(self.PRLevelManagerTotalStarsKey)
        self.totalDistance = aDecoder.decodeIntegerForKey(self.PRLevelManagerTotalDistanceKey)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(totalStarsCollected, forKey: PRLevelManagerTotalStarsKey)
        aCoder.encodeInteger(totalDistance, forKey: PRLevelManagerTotalDistanceKey)
    }
    
    func loadInstance() -> LevelManager {
        if let decodedData = NSFileManager.defaultManager().contentsAtPath(filePath()) {
            return NSKeyedUnarchiver.unarchiveObjectWithData(decodedData) as! LevelManager
        }
        return LevelManager()
    }
    
    func save() {
        var encodedData = NSKeyedArchiver.archivedDataWithRootObject(self)
        encodedData.writeToFile(filePath(), atomically: true)
    }

    func filePath() -> String! {
        if let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first?.stringByAppendingPathComponent("gameData") {
            return filePath
        }
        return nil
    }
}

// MARK: Level Score logic
extension LevelManager {
    
    func reset() {
        self.distance = 0
        self.starsCollected = 0
    }
    
    func updateStars(level: Levels) {
        switch level {
            
        case .LevelOne:
            println("LevelOne")
            if starsCollected > levelOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - levelOneStars + starsCollected
                // Update level stars
                levelOneStars = starsCollected
            }
            
        case .LevelTwo:
            println("LevelTwo")
            if starsCollected > levelTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - levelTwoStars + starsCollected
                // Update level stars
                levelTwoStars = starsCollected
            }
            
        }
        
        saveHighScore()
    }
    
    func saveHighScore() {
        if player.isAuthed() {
            println("Saving High Score")
            
            var starReporter = GKScore(leaderboardIdentifier: "planeRunnerLeaderboardTotalStars")
            
            starReporter.value = Int64(totalStarsCollected)
            
            var starArray: [GKScore] = [starReporter]
            
            GKScore.reportScores(starArray, withCompletionHandler: {(error: NSError!) -> Void in
                if error != nil {
                    println("error: \(error.description)")
                }
            })
        }
    }

}



