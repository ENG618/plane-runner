//
//  GameScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bg = SKSpriteNode()
    
    var movingObjects = SKNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.addChild(movingObjects)
        
        setBackground()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Scene setup helpers
    func setBackground(){
        // TODO: Set background.
        var bgTexture = SKTexture(imageNamed: "mainBackground")
        
        // Create action to replace background
        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        // Create 3 backgrouds for endless scrolling
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            
            bg.runAction(movebgForever)
            
            movingObjects.addChild(bg)
        }
    }
    
    func setObsticles() {
        // TODO: Set moutain plains up and down.
    }
    
    func createClouds() {
        // TODO: Create clouds
    }
    
    func createPlane() {
        // TODO: Create plane
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
