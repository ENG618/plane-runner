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
    let PRDidFly1000Key = "DidFly1000"
    
    
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
    
    // Achievement Bools
    var didFly1000: Bool = false
    
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
        
        didFly1000 = defaults.boolForKey(PRDidFly1000Key)
        
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
        
        defaults.setBool(didFly1000, forKey: PRDidFly1000Key)
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
                submitProgress(Achievements.LevelOne)
            }
            
        case .FirstTwo:
            if starsCollected > firstTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstTwoStars + starsCollected
                // Update level stars
                firstTwoStars = starsCollected
                submitStarsLeaderboard()
                submitProgress(Achievements.LevelTwo)
            }
            submitProgress(Achievements.LevelTwo)
        case .FirstThree:
            if starsCollected > firstThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstThreeStars + starsCollected
                // Update level stars
                firstThreeStars = starsCollected
                submitStarsLeaderboard()
                submitProgress(Achievements.LevelThree)
            }
            
        case .SecondOne:
            if starsCollected > secondOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondOneStars + starsCollected
                // Update level stars
                secondOneStars = starsCollected
                submitStarsLeaderboard()
            }
            
        case .SecondTwo:
            print("2-2 needs to be set up")
            if starsCollected > secondTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondTwoStars + starsCollected
                // Update level stars
                secondTwoStars = starsCollected
                submitStarsLeaderboard()
            }
            
        case .SecondThree:
            print("2-3 needs to be set up")
            if starsCollected > secondThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondThreeStars + starsCollected
                // Update level stars
                secondThreeStars = starsCollected
                submitStarsLeaderboard()
            }
        }
        
        save()
    }
}

// MARK: Game Center
extension LevelManager {
    
    func submitStarsLeaderboard() {
        if player.isAuthed() {
            print("Saving Stars high Score")
            
            // Report total stars
            let starReporter = GKScore(leaderboardIdentifier: Leaderboard.TotalStars.id)
            
            starReporter.value = Int64(totalStarsCollected)
            
            var starArray: [GKScore] = [starReporter]
            
            GKScore.reportScores(starArray, withCompletionHandler: {(error: NSError?) -> Void in
                if error != nil {
                    print("Stars LEaderboard error: \(error.description)")
                }
            })
        }
    }
    
    func submitDistanceLeaderboard() {
        if player.isAuthed() {
            print("Saving distance high Score")
            
            // Report updated total distance flown
            let distanceReporter = GKScore(leaderboardIdentifier: Leaderboard.TotalDistance.id)
            
            distanceReporter.value = Int64(totalDistance)
            
            var distanceArray: [GKScore] = [distanceReporter]
            
            GKScore.reportScores(distanceArray, withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print("Distance Leaderboard error: \(error.description)")
                }
            })
        }
        submitProgress(Achievements.Fly1000)
    }
    
    func loadAchievements() {
        
        GKAchievement.loadAchievementsWithCompletionHandler({ (achievements: [GKAchievement]?, error: NSError?) -> Void in
            if error != nil {
                print("Achievements error: \(error.description)")
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
    
    func achievementProgress(numStars: Int, achievement: GKAchievement) -> GKAchievement {
        
        // Check if stage one is completed
        if firstOneStars == 3 && firstTwoStars == 3 && firstThreeStars == 3 {
            submitProgress(Achievements.StageOne)
        }
        
        // Determin percent completed
        switch numStars {
        case 1:
            achievement.percentComplete = Double(33.0)
            return achievement
        case 2:
            achievement.percentComplete = Double(66.0)
            return achievement
        case 3:
            achievement.percentComplete = Double(100.0)
            return achievement
        default:
            achievement.percentComplete = Double(0.0)
            return achievement
        }
    }
    
    func submitProgress(achievement: Achievements) {
        
        if player.isAuthed() == false {
            return // stop function is player is not authed
        }
        
        // TODO: Update achievement progress
        var achieveUpdateArray: [GKAchievement] = []
        
        switch achievement {
            
        case .LevelOne:
            let current = GKAchievement(identifier: achievement.id)
            current.showsCompletionBanner = true
            achieveUpdateArray.append(achievementProgress(firstOneStars, achievement: current))
            
        case .LevelTwo:
            let current = GKAchievement(identifier: achievement.id)
            current.showsCompletionBanner = true
            achieveUpdateArray.append(achievementProgress(firstTwoStars, achievement: current))
            
        case .LevelThree:
            let current = GKAchievement(identifier: achievement.id)
            current.showsCompletionBanner = true
            achieveUpdateArray.append(achievementProgress(firstThreeStars, achievement: current))
            
        case .StageOne:
            if firstOneStars == 3 && firstTwoStars == 3 && firstThreeStars == 3 {
                let completedAchievement = GKAchievement(identifier: achievement.id)
                completedAchievement.showsCompletionBanner = true
                completedAchievement.percentComplete = Double(100.00)
                achieveUpdateArray.append(completedAchievement)
            }
        case .Fly1000:
            let fly1000 = GKAchievement(identifier: achievement.id)
            fly1000.showsCompletionBanner = true
            
            if totalDistance < 1000 && !didFly1000 {
                fly1000.percentComplete = Double(totalDistance) / Double(1000.00)
                achieveUpdateArray.append(fly1000)
            }
            
            if totalDistance >= 1000 && !didFly1000 {
                didFly1000 = true
                fly1000.percentComplete = Double(100.00)
                achieveUpdateArray.append(fly1000)
            }
        }
        
        if achieveUpdateArray.count > 0 {
            GKAchievement.reportAchievements(achieveUpdateArray, withCompletionHandler: nil)
        }
    }
    
    func saveAchievments() {
        
    }
}



