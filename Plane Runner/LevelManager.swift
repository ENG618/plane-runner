//
//  LevelManager.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import Foundation

class LevelManager {
    
    // Key constants
    let KeyStarsForLevel = "StarsForLevel"
    
    // Score
    var distance: Int = 0
    var starsCollected: Int = 0
    
    // Totals
    var totalDistanc: Int = 0
    var totalStarsCollected: Int = 0
    
    // Singlton
    static let sharedInstance = LevelManager()
    
    // User Defaults
    let defauts = NSUserDefaults.standardUserDefaults()
    
//    var level: String!
//    var starsEarned: Int!
    
    var levelsCompleted: [(level: String, starsCollected: Int)]
    
    init() {
        println("LevelManager Initialized")
        levelsCompleted = []
        self.loadFromDefaults()
    }
    
    func loadFromDefaults() {
        // TODO: load all data from defaults to levelsCompleted
//        levelsCompleted = defauts.objectForKey(<#defaultName: String#>)
    }
    
    func levelCompleted(level: String, starsCollected: Int) {
//        levelsCompleted.append(level: level, starsCollected: starsCollected)
//        defauts.setObject(levelsCompleted, forKey: KeyStarsForLevel)
    }
}

// MARK: Level Score lodgic
extension LevelManager {
    
    func reset() {
        self.distance = 0
        self.starsCollected = 0
    }
}





