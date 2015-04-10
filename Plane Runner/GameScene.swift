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
    
    struct PhysicsCategory {
        static let All          :UInt32 = UInt32.max
        static let Plane        :UInt32 = 1
        static let Collidable   :UInt32 = 2
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Play background track
        let backgrountTrack = SKAction.repeatActionForever(SKAction.playSoundFileNamed("backgroundTrack.mp3", waitForCompletion: true))
        self.runAction(backgrountTrack)
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        // Change gravity
        self.physicsWorld.gravity = CGVectorMake(0, -1.6)
        
        setBackground()
        setGround()
        createPlane()
        setObsticles()
        
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
//        ground.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointMake(0, 0), toPoint: CGPointMake(0, self.frame.width))
        ground.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        
        self.addChild(ground)
    }
    
    func setObsticles() {
        // TODO: Set moutain plains up and down.
        
        let moveObsticle = SKAction.moveByX(-self.frame.width, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        
        // Create upper obsticle
        let upperObsticle = SKSpriteNode(imageNamed: "rockDown")
        //upperObsticle.position = CGPointMake(<#x: CGFloat#>, <#y: CGFloat#>)
        
        
        
        
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
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable
        
        // Set elevation
        plane.zPosition = 5
        
        self.addChild(plane)
    }
}

// MARK: SKPhysicsContactDelegate extension
extension GameScene: SKPhysicsContactDelegate {

    func didBeginContact(contact: SKPhysicsContact) {
        println("Plane crashed")
        let planeCrash = SKAction.repeatAction(SKAction.playSoundFileNamed("planeCrash.mp3", waitForCompletion: true), count: 1)
        runAction(planeCrash)
    }
}
