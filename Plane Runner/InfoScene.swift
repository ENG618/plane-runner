//
//  CreditsScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/26/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class InfoScene: SKScene {
    
    // Nodes
    let worldNode = SKNode()
    let backNode = SKNode()
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let backBtnTexture = SKTexture(imageNamed: BackIconImage)
    
    override func didMoveToView(view: SKView) {
        self.addChild(worldNode)
        self.addChild(backNode)
        
        self.physicsWorld.contactDelegate = self
        
        createBackground(view)
        createBackButton(view)
    }
}

// MARK: Setup Helpers
extension InfoScene {
    func createBackground(view: SKView) {
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        bg.zPosition = ZLevel.Background
        bg.size = size
        worldNode.addChild(bg)
    }
    
    func createBackButton(view: SKView) {
        let backBtn = SKSpriteNode(texture: backBtnTexture)
        backBtn.position = CGPoint(x: 10 + backBtnTexture.size().width / 2, y: -10 - backBtnTexture.size().height / 2 + view.frame.height)
        
        backNode.addChild(backBtn)
    }
}

// MARK: Input Methods
extension InfoScene {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if backNode.containsPoint(location) {
                println("Start button touched")
                
                //                let scene = LevelOneScene(size: size)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(0.7))
            }
        }
    }
}

// MARK: SKPhysicsDelegate
extension InfoScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        println("Button pressed")
    }
}