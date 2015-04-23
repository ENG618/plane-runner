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
    
    init() {
        distanceTraveled = 0
        starsCollected = 0
        distanceLabel = SKNode()
        setUpDistanceLable(distanceLabel)
        
    }
    
    private func setUpDistanceLable(parent: SKNode) {
        // TODO: Set up label node
    }
}
