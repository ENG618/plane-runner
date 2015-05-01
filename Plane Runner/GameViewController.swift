//
//  GameViewController.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        if let skView = self.view as? SKView {
            if skView.scene == nil {
//                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
//                let scene = MenuScene(size: CGSize(width: 320 * aspectRatio, height: 320))
                
                let scene = MenuScene(size: skView.bounds.size)
                
                skView.showsFPS = true
                skView.showsNodeCount = true
//                skView.showsPhysics = true 
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .Fill
                
                skView.presentScene(scene)
            }
        }
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let scene = MenuScene(size: view.bounds.size)
////        let scene = LevelOneScene(size: view.bounds.size)
//        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount  = true
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .ResizeFill
//        skView.presentScene(scene)
//    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Landscape.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.Landscape.rawValue)
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
