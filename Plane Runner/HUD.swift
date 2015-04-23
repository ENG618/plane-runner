//
//  HUD.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/23/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class HUD {
    
    // MARK: Class Variables
    var distanceTraveled: Int
    var starsCollected: Int
    let distanceLabel: SKNode
    let starsLabel: SKNode
    
    // MARK: Init
    init() {
        // Set initial values
        distanceTraveled = 0
        starsCollected = 0
        distanceLabel = SKNode()
        starsLabel = SKNode()
        
        // Setup
        setUpDistanceLable(distanceLabel)
        setUpStarsLabel(starsLabel)
    }
    
    // MARK: Distance
    private func setUpDistanceLable(parent: SKNode) {
        // TODO: Setup label node
    }
    
    func increaseDistance() {
        // Adds yard to distance traveled
        distanceTraveled++
        // Update label
        updateDistanceLabel()
    }
    
    private func updateDistanceLabel() {
        // TODO: Update distance label
    }
    
    // MARK: Stars
    private func setUpStarsLabel(parent: SKNode) {
        // TODO: Setup stars label
    }
    
    func increaseStar() {
        if starsCollected < 3 {
            starsCollected++
            updateStarsLabel()
        }
    }
    
    private func updateStarsLabel() {
        // TODO: Update stars label
    }
}
