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
    var plane = SKSpriteNode()
    
    var movingObjects = SKNode()
    
    let planeGroup:UInt32 = 1
    let collidableObjectsGroup:UInt32 = 2
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        
        setBackground()
        //setGround()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        // Change gravity
        self.physicsWorld.gravity = CGVectorMake(0, -1.6)
        
        createPlane()
        
        // Uncomment to show physics
        view.showsPhysics = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        plane.physicsBody?.velocity = CGVectorMake(0, 0)
        plane.physicsBody?.applyImpulse(CGVectorMake(0, 75))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Scene setup helpers
    func setBackground(){
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
            bg.zPosition = -2
            
            bg.runAction(movebgForever)
            
            movingObjects.addChild(bg)
        }
    }
    
    func setGround() {
        // Create ground
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = collidableObjectsGroup
        
        self.addChild(ground)
    }
    
    func setObsticles() {
        // TODO: Set moutain plains up and down.
    }
    
    func createClouds() {
        // TODO: Create clouds
    }
    
    func createPlane() {
        let planeTexture = SKTexture(imageNamed: "planeRed1")
        let planeTexture1 = SKTexture(imageNamed: "planeRed2")
        let planeTexture2 = SKTexture(imageNamed: "planeRed3")
        
        // Animate plans propeller
        let animation = SKAction.animateWithTextures([planeTexture, planeTexture1, planeTexture2], timePerFrame: 0.05)
        let makePropellerSpin = SKAction.repeatActionForever(animation)
        
        // Set planes possition
        plane = SKSpriteNode(texture: planeTexture)
        plane.position = CGPointMake(size.width/4, size.height/2)
        
        plane.runAction(makePropellerSpin)
        
        plane.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(plane.size.width, plane.size.height))
        plane.physicsBody?.dynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.categoryBitMask = planeGroup
        plane.physicsBody?.collisionBitMask = collidableObjectsGroup
        plane.physicsBody?.contactTestBitMask = collidableObjectsGroup
        
        // Set elevation
        plane.zPosition = 5
        
        self.addChild(plane)
    }
}

// MARK: SKPhysicsContactDelegate extension
extension GameScene: SKPhysicsContactDelegate {

    func didBeginContact(contact: SKPhysicsContact) {
        println("Plane crashed")
    }
}
