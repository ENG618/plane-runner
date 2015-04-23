//
//  HUD.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/23/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class HUD {
    
    var distanceTraveled: Int
    var starsCollected: Int
    let distanceLabel: SKNode
    let starsLabel: SKNode
    
    init() {
        // Set initial values
        distanceTraveled = 0
        starsCollected = 0
        distanceLabel = SKNode()
        starsLabel = SKNode()
        
        
        setUpDistanceLable(distanceLabel)
    }
    
    private func setUpDistanceLable(parent: SKNode) {
        // TODO: Set up label node
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
    
    private func setUpStarsLabel(parent: SKNode) {
        // TODO: Set up stars label
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
