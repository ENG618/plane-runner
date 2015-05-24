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
                    println((GKLocalPlayer.localPlayer().authenticated))
                }
            }
        }
    }
}
