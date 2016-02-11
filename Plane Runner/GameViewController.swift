//
//  GameViewController.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authLocalPlayer()
    }
    
    override func viewWillLayoutSubviews() {
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                
                let scene = MenuScene(size: skView.bounds.size)
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                // Uncomment to show game physics
                //skView.showsPhysics = true
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .Fill
                
                skView.presentScene(scene)
                
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.Landscape
        } else {
            return UIInterfaceOrientationMask.Landscape
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension GameViewController {
    
    func authLocalPlayer() {
        let player = Player.sharedInstance
        
        player.authLocalPlayer(self)
    }
}
