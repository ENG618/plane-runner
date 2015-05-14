//
//  LevelManager.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import Foundation

class LevelManager {
    
    static let sharedInstance = LevelManager()
    let defauts = NSUserDefaults.standardUserDefaults()
    
    var level: String!
    var starsEarned: Int!
    
    var levelsCompleted: [(String, Int)]
    
    init() {
        println("LevelManager Initialized")
        levelsCompleted = []
        self.loadFromDefaults()
    }
    
    func loadFromDefaults() {
        // TODO: load all data from defaults to levelsCompleted
    }
    
    func levelCompleted(level: String, starsCollected: Int) {
        levelsCompleted.append((level, starsCollected))
    }
}