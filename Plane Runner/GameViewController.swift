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
                
                scene.scaleMode = .fill
                
                skView.presentScene(scene)
                
            }
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.landscape
        } else {
            return UIInterfaceOrientationMask.landscape
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}

extension GameViewController {
    
    func authLocalPlayer() {
        let player = Player.sharedInstance
        
        player.authLocalPlayer(self)
    }
}
