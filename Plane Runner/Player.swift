//
//  Player.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/23/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import GameKit

class Player {
    
    static let sharedInstance: Player = Player()
    
    var enabeledGameCenter = true
    var localPlayer: GKLocalPlayer
    var canUseGameCenter: Bool = false {
        didSet{
            if canUseGameCenter == true {
                // Load previous achievements
                //loadAchievements()
            }
        }
    }
    
    // Achievements
    var achievements: [(name: String, achievement: GKAchievement)] = []
    var achievementStrings: [String] = []
    
    init() {
        self.localPlayer = GKLocalPlayer.localPlayer()
    }
    
    func authLocalPlayer(vc: UIViewController) {
        if !localPlayer.authenticated {
            
            localPlayer.authenticateHandler = {(viewController, error) -> Void in
                if viewController != nil {
                    // Show scene
                    vc.presentViewController(viewController, animated: true, completion: nil)
                } else {
                    print((GKLocalPlayer.localPlayer().authenticated))
                }
            }
        }
    }
    
    func isAuthed() -> Bool {
        if localPlayer.authenticated{
            return true
        }
        return false
    }
}

// MARK: Achievements
//extension Player {
//    
//    
//    func loadAchievements() {
//        var achievements: [GKAchievement] = []
//        
//        GKAchievement.loadAchievementsWithCompletionHandler({ (achievements, error: NSError!) -> Void in
//            if error != nil {
//                println("Achievements error: \(error.description)")
//            } else {
//                for anAchievement in achievements {
//                    if let achievement = anAchievement as? GKAchievement {
//                        self.achievementStrings.append(achievement.identifier)
//                    }
//                    //                    let saveableAchievement = (achievement.identifier, achievement)
//                    //                    self.player.achievements.append(saveableAchievement)
//                    
//                }
//            }
//        })
//    }
//    
//    
//    
//    
//}
