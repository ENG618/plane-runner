//
//  GameOverScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/22/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        if won {
            // Level was won
            println("Player won")
        } else {
            // Level was lost
            println("Player lost")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
