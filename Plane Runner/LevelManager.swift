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
        
        loadAchievements()
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
                submitStarsLeaderboard()
                submitProgress()
            }
            
        case .FirstTwo:
            if starsCollected > firstTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstTwoStars + starsCollected
                // Update level stars
                firstTwoStars = starsCollected
                submitStarsLeaderboard()
                submitProgress()
            }
            
        case .FirstThree:
            if starsCollected > firstThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstThreeStars + starsCollected
                // Update level stars
                firstThreeStars = starsCollected
                submitStarsLeaderboard()
                submitProgress()
            }
            
        case .SecondOne:
            if starsCollected > secondOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondOneStars + starsCollected
                // Update level stars
                secondOneStars = starsCollected
                submitStarsLeaderboard()
                submitProgress()
            }
            
        case .SecondTwo:
            println("2-2 needs to be set up")
            if starsCollected > secondTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondTwoStars + starsCollected
                // Update level stars
                secondTwoStars = starsCollected
                submitStarsLeaderboard()
                submitProgress()
            }
            
        case .SecondThree:
            println("2-3 needs to be set up")
            if starsCollected > secondThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondThreeStars + starsCollected
                // Update level stars
                secondThreeStars = starsCollected
                submitStarsLeaderboard()
                submitProgress()
            }
        }
        
        save()
    }
}

// MARK: Game Center
extension LevelManager {
    
    func submitStarsLeaderboard() {
        if player.isAuthed() {
            println("Saving Stars high Score")
            
            // Report total stars
            let starReporter = GKScore(leaderboardIdentifier: Leaderboard.TotalStars.id)
            
            starReporter.value = Int64(totalStarsCollected)
            
            var starArray: [GKScore] = [starReporter]
            
            GKScore.reportScores(starArray, withCompletionHandler: {(error: NSError!) -> Void in
                if error != nil {
                    println("Stars LEaderboard error: \(error.description)")
                }
            })
        }
    }
    
    func submitDistanceLeaderboard() {
        if player.isAuthed() {
            println("Saving distance high Score")
            
            // Report updated total distance flown
            let distanceReporter = GKScore(leaderboardIdentifier: Leaderboard.TotalDistance.id)
            
            distanceReporter.value = Int64(totalDistance)
            
            var distanceArray: [GKScore] = [distanceReporter]
            
            GKScore.reportScores(distanceArray, withCompletionHandler: { (error: NSError!) -> Void in
                if error != nil {
                    println("Distance Leaderboard error: \(error.description)")
                }
            })
        }
    }
    
    
    
    func loadAchievements() {
        
        GKAchievement.loadAchievementsWithCompletionHandler({ (achievements: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("Achievements error: \(error.description)")
            } else {
                if let recievedAchievements = achievements as? [GKAchievement] {
                    for item in recievedAchievements {
                        self.player.achievementStrings.append(item.identifier)
                    }
                }
                if achievements != nil {
                    for anAchievement in achievements {
                        if let achievement = anAchievement as? GKAchievement {
                            self.player.achievementStrings.append(achievement.identifier)
                        }
                        //                    let saveableAchievement = (achievement.identifier, achievement)
                        //                    self.player.achievements.append(saveableAchievement)
                        
                    }
                }
            }
        })
    }
    
    
    
    func submitProgress() {
        
    }
    
    func saveAchievments() {
        
    }
}



