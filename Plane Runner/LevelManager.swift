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
    let defaults = UserDefaults.standard
    
    // Achievement Bools
    var didFly1000: Bool = false
    
    func load() {
        // Load totals
        totalDistance = defaults.integer(forKey: PRTotalDistanceKey)
        totalStarsCollected = defaults.integer(forKey: PRTotalStarsKey)
        
        // Load level data
        firstOneStars = defaults.integer(forKey: PRStarsForStageOneLevelOneKey)
        firstTwoStars = defaults.integer(forKey: PRStarsForStageOneLevelTwoKey)
        firstThreeStars = defaults.integer(forKey: PRStarsForStageOneLevelThreeKey)
        secondOneStars = defaults.integer(forKey: PRStarsForStageTwoLevelOneKey)
        secondTwoStars = defaults.integer(forKey: PRStarsForStageTwoLevelTwoKey)
        secondThreeStars = defaults.integer(forKey: PRStarsForStageTwoLevelthereKey)
        
        didFly1000 = defaults.bool(forKey: PRDidFly1000Key)
        
        loadAchievements()
    }
    
    func save() {
        // Save totals
        defaults.set(totalDistance, forKey: PRTotalDistanceKey)
        defaults.set(totalStarsCollected, forKey: PRTotalStarsKey)
        
        // Save level data
        defaults.set(firstOneStars, forKey: PRStarsForStageOneLevelOneKey)
        defaults.set(firstTwoStars, forKey: PRStarsForStageOneLevelTwoKey)
        defaults.set(firstThreeStars, forKey: PRStarsForStageOneLevelThreeKey)
        defaults.set(secondOneStars, forKey: PRStarsForStageTwoLevelOneKey)
        defaults.set(secondTwoStars, forKey: PRStarsForStageTwoLevelTwoKey)
        defaults.set(secondThreeStars, forKey: PRStarsForStageTwoLevelthereKey)
        
        defaults.set(didFly1000, forKey: PRDidFly1000Key)
    }
}

// MARK: Level Score logic
extension LevelManager {
    
    func reset() {
        self.distance = 0
        self.starsCollected = 0
    }
    
    func updateStars(_ level: StageLevel) {
        switch level {
            
        case .firstOne:
            if starsCollected > firstOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstOneStars + starsCollected
                // Update level stars
                firstOneStars = starsCollected
                submitStarsLeaderboard()
                submitProgress(Achievements.levelOne)
            }
            
        case .firstTwo:
            if starsCollected > firstTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstTwoStars + starsCollected
                // Update level stars
                firstTwoStars = starsCollected
                submitStarsLeaderboard()
                submitProgress(Achievements.levelTwo)
            }
            submitProgress(Achievements.levelTwo)
        case .firstThree:
            if starsCollected > firstThreeStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - firstThreeStars + starsCollected
                // Update level stars
                firstThreeStars = starsCollected
                submitStarsLeaderboard()
                submitProgress(Achievements.levelThree)
            }
            
        case .secondOne:
            if starsCollected > secondOneStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondOneStars + starsCollected
                // Update level stars
                secondOneStars = starsCollected
                submitStarsLeaderboard()
            }
            
        case .secondTwo:
            print("2-2 needs to be set up")
            if starsCollected > secondTwoStars {
                // Update total stars
                totalStarsCollected = totalStarsCollected - secondTwoStars + starsCollected
                // Update level stars
                secondTwoStars = starsCollected
                submitStarsLeaderboard()
            }
            
        case .secondThree:
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
            let starReporter = GKScore(leaderboardIdentifier: Leaderboard.totalStars.id)
            
            starReporter.value = Int64(totalStarsCollected)
            
            let starArray: [GKScore] = [starReporter]
            
            GKScore.report(starArray, withCompletionHandler: {(error: NSError?) -> Void in
                if error != nil {
                    print("Stars LEaderboard error: \(String(describing: error?.description))")
                }
                } as? (Error?) -> Void)
        }
    }
    
    func submitDistanceLeaderboard() {
        if player.isAuthed() {
            print("Saving distance high Score")
            
            // Report updated total distance flown
            let distanceReporter = GKScore(leaderboardIdentifier: Leaderboard.totalDistance.id)
            
            distanceReporter.value = Int64(totalDistance)
            
            let distanceArray: [GKScore] = [distanceReporter]
            
            GKScore.report(distanceArray, withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print("Distance Leaderboard error: \(String(describing: error?.description))")
                }
                } as? (Error?) -> Void)
        }
        submitProgress(Achievements.fly1000)
    }
    
    func loadAchievements() {
        
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: NSError?) -> Void in
            if error != nil {
                print("Achievements error: \(String(describing: error?.description))")
            } else {
                if let recievedAchievements = achievements {
                    for item in recievedAchievements {
                        self.player.achievementStrings.append(item.identifier!)
                    }
                }
                if achievements != nil {
                    for anAchievement in achievements! {
                        if let achievement = anAchievement as? GKAchievement {
                            self.player.achievementStrings.append(achievement.identifier!)
                        }
                        //                    let saveableAchievement = (achievement.identifier, achievement)
                        //                    self.player.achievements.append(saveableAchievement)
                        
                    }
                }
            }
            } as? ([GKAchievement]?, Error?) -> Void)
    }
    
    func achievementProgress(_ numStars: Int, achievement: GKAchievement) -> GKAchievement {
        
        // Check if stage one is completed
        if firstOneStars == 3 && firstTwoStars == 3 && firstThreeStars == 3 {
            submitProgress(Achievements.stageOne)
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
    
    func submitProgress(_ achievement: Achievements) {
        
        if player.isAuthed() == false {
            return // stop function is player is not authed
        }
        
        // TODO: Update achievement progress
        var achieveUpdateArray: [GKAchievement] = []
        
        switch achievement {
            
        case .levelOne:
            let current = GKAchievement(identifier: achievement.id)
            current.showsCompletionBanner = true
            achieveUpdateArray.append(achievementProgress(firstOneStars, achievement: current))
            
        case .levelTwo:
            let current = GKAchievement(identifier: achievement.id)
            current.showsCompletionBanner = true
            achieveUpdateArray.append(achievementProgress(firstTwoStars, achievement: current))
            
        case .levelThree:
            let current = GKAchievement(identifier: achievement.id)
            current.showsCompletionBanner = true
            achieveUpdateArray.append(achievementProgress(firstThreeStars, achievement: current))
            
        case .stageOne:
            if firstOneStars == 3 && firstTwoStars == 3 && firstThreeStars == 3 {
                let completedAchievement = GKAchievement(identifier: achievement.id)
                completedAchievement.showsCompletionBanner = true
                completedAchievement.percentComplete = Double(100.00)
                achieveUpdateArray.append(completedAchievement)
            }
        case .fly1000:
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
            GKAchievement.report(achieveUpdateArray, withCompletionHandler: nil)
        }
    }
    
    func saveAchievments() {
        
    }
}



