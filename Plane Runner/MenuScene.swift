//
//  GameScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    let bgTexture = SKTexture(imageNamed: "mainBackground")
    
    override func didMoveToView(view: SKView) {
        
        createBackground()
        
        
        
//        var label = SKLabelNode(text: "Hello World")
//        label.position = CGPoint(x: size.width/2, y: size.height/2)
//        self.addChild(label)
    }
    
    // MARK: Setup Helpers
    func createBackground() {
        var bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = ZLevel.Background
        bg.size = size
        self.addChild(bg)
    }
}
