//
//  LevelManager.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import Foundation
import GameKit
    

class LevelManager {
    
    // Singleton
    static let sharedInstance = LevelManager()
    
    // Game Center
    let player = Player.sharedInstance
    
    // Key constants
    let PRStarsForStageOneLevelOneKey = "StarsStageOneLeveOne"
    let PRStarsForStageOneLevelTwoKey = "StarsStageOneLeveTwo"
    let PRStarsForStageOneLevelThreeKey = "StarsStageOneLeveThree"
    let PRStarsForStageTwoLevelOneKey = "StarsStageTwoLeveOne"
    let PRStarsForStageTwoLevelTwoKey = "StarsStageTwoLeveTwo"
    let PRStarsForStageTwoLevelthereKey = "StarsStageTwoLeveThree"
    let PRTotalStarsKey = "TotalStars"
    let PRTotalDistanceKey = "TotalDistance"
    
    
    // Score for games in action
    var distance: Int = 0
    var starsCollected: Int = 0
    
    // Totals
    var totalDistance: Int = 0
    var totalStarsCollected: Int = 0
    
    // Level Totals
    var firstOneStars: Int = 0
    var firstTwoStars: Int = 0
    var firstThreeStars: Int = 0
    var secondOneStars: Int = 0
    var secondTwoStars: Int = 0
    var secondThreeStars: Int = 0
    
    // User Defaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func load() {
        // Load totals
        totalDistance = defaults.integerForKey(PRTotalDistanceKey)
        totalStarsCollected = defaults.integerForKey(PRTotalStarsKey)
        
        // Load level data
        firstOneStars = defaults.integerForKey(PRStarsForStageOneLevelOneKey)
        firstTwoStars = defaults.integerForKey(PRStarsForStageOneLevelTwoKey)
        firstThreeStars = defaults.integerForKey(PRStarsForStageOneLevelThreeKey)
        secondOneStars = defaults.integerForKey(PRStarsForStageTwoLevelOneKey)
        secondTwoStars = defaults.integerForKey(PRStarsForStageTwoLevelTwoKey)
        secondThreeStars = defaults.integerForKey(PRStarsForStageTwoLevelthereKey)
    }
    
    func save() {
        // Save totals
        defaults.setInteger(totalDistance, forKey: PRTotalDistanceKey)
        defaults.setInteger(totalStarsCollected, forKey: PRTotalStarsKey)
        
        // Save level data
        defaults.setInteger(firstOneStars, forKey: PRStarsForStageOneLevelOneKey)
        defaults.setInteger(firstTwoStars, forKey: PRStarsForStageOneLevelTwoKey)
        defaults.setInteger(firstThreeStars, forKey: PRStarsForStageOneLevelThreeKey)
        defaults.setInteger(secondOneStars, forKey: PRStarsForStageTwoLevelOneKey)
        defaults.setInteger(secondTwoStars, forKey: PRStarsForStageTwoLevelTwoKey)
        defaults.setInteger(secondThreeStars, forKey: PRStarsForStageTwoLevelthereKey)
    }
}

// MARK: Level Score logic
extension LevelManager {
    
    func reset() {
        self.distance = 0
        self.starsCollected = 0
    }
    
    func updateStars(level: StageLevel) {
        switch level {
            
        case .FirstOne:
            if starsCollected > firstOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstOneStars + starsCollected
                // Update level stars
                firstOneStars = starsCollected
            }
            
        case .FirstTwo:
            if starsCollected > firstTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstTwoStars + starsCollected
                // Update level stars
                firstTwoStars = starsCollected
            }
            
        case .FirstThree:
            if starsCollected > firstThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstThreeStars + starsCollected
                // Update level stars
                firstThreeStars = starsCollected
            }
            
        case .SecondOne:
            if starsCollected > secondOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondOneStars + starsCollected
                // Update level stars
                secondOneStars = starsCollected
            }
            
        case .SecondTwo:
            println("2-2 needs to be set up")
            if starsCollected > secondTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondTwoStars + starsCollected
                // Update level stars
                secondTwoStars = starsCollected
            }
            
        case .SecondThree:
            println("2-3 needs to be set up")
            if starsCollected > secondThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondThreeStars + starsCollected
                // Update level stars
                secondThreeStars = starsCollected
            }
        }
        
        save()
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



