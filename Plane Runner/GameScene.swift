//
//  GameScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var bg = SKSpriteNode()
    var plane = SKSpriteNode()
    var groundTexture = SKTexture()
    var ground = SKSpriteNode()
    var movingObjects = SKNode()
    var audioPlayer = AVAudioPlayer()
    
    // Scene resources
    var planeCrashFX = SKAction()
    
    struct PhysicsCategory {
        static let All          :UInt32 = UInt32.max
        static let Plane        :UInt32 = 0x1
        static let Collidable   :UInt32 = 0x1 << 1
        static let Boundary     :UInt32 = 0x1 << 2
        static let Ground       :UInt32 = 0x1 << 3
    }
    
    struct zLevel {
        static let Background   : CGFloat = -2.0
        static let Ground       : CGFloat = -1.0
        static let Pipes        : CGFloat = 2.0
        static let Bird         : CGFloat = 5.0
    }
    
    override func didMoveToView(view: SKView) {
        
        // Loads all scenes resources
        loadResources(view)
        
        // Play background track
        //        let backgrountTrack = SKAction.repeatActionForever(SKAction.playSoundFileNamed("backgroundTrack.mp3", waitForCompletion: true))
        //        self.runAction(backgrountTrack)
        
        loopBackgroundTrack(view)
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        // Change gravity
        self.physicsWorld.gravity = CGVectorMake(0, -1.6)
        
        
        createBackground(view)
        createBoundry(view)
        createGround(view)
        createPlane(view)
        
        
        //        setObstacles(view)
        
        // Create obstacles at interval
        //var timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: Selector(createObstacles()), userInfo: nil, repeats: true)
        
        // Uncomment to show physics
        view.showsPhysics = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let planeFly = SKAction.repeatAction(SKAction.playSoundFileNamed("Helicopter.mp3", waitForCompletion: true), count: 1)
        runAction(planeFly)
        
        plane.physicsBody?.velocity = CGVectorMake(0, 0)
        plane.physicsBody?.applyImpulse(CGVectorMake(0, 75))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Scene setup helpers
    
    func loopBackgroundTrack(sceneView: SKView) {
        
        let path = NSBundle.mainBundle().pathForResource("backgroundTrack", ofType: ".mp3")
        let url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        audioPlayer.volume = 0.2
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func createBackground(sceneView: SKView){
        var bgTexture = SKTexture(imageNamed: "mainBackground")
        
        // Create action to replace background
        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 20)
        var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        // Create 3 backgrounds for endless scrolling
        for var i:CGFloat = 0; i < 3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.zPosition = zLevel.Background
            
            bg.runAction(movebgForever)
            
            movingObjects.addChild(bg)
        }
    }
    
    func createBoundry(sceneView: SKView) {
        // Create ground
        var boundary = SKNode()
        boundary.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.categoryBitMask = PhysicsCategory.Boundary
        
        self.addChild(boundary)
    }
    
    func createGround(sceneView: SKView) {
        // TODO: Load floor and roof.
        
        
        // Create action to replace background
        var moveGround = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 9)
        var replaceGround = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0)
        var moveGroundForever = SKAction.repeatActionForever(SKAction.sequence([moveGround, replaceGround]))
        
        // Create 3 grounds for endless scrolling
        for var i:CGFloat = 0; i < 3; i++ {
            
            ground = SKSpriteNode(texture: groundTexture)
            ground.position = CGPoint(x: groundTexture.size().width/2 + groundTexture.size().width * i, y: groundTexture.size().height / 2 + 95)
            ground.zPosition = zLevel.Ground
            
            ground.runAction(moveGroundForever)
            
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(ground.size.width, ground.size.height))
            ground.physicsBody?.dynamic = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
            
            movingObjects.addChild(ground)
        }
    }
    
    func createObstacles(sceneView: SKView) {
        // TODO: Set mountain plains up and down.
        
        var moveObstacle = SKAction.moveByX(-self.frame.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        var removeObstacle = SKAction.removeFromParent()
        var moveAndRemoveObsticle = SKAction.sequence([moveObstacle, removeObstacle])
        
        // Create upper obstacle
        var upperObstacleTexture = SKTexture(imageNamed: "rockDown")
        var upperObstacle = SKSpriteNode(texture: upperObstacleTexture)
        upperObstacle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - upperObstacle.size.height)
        //        upperObstacle.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetHeight(self.frame) - upperObstacle.size.height)
        //        upperObstacle.runAction(moveAndRemoveObsticle)
        //        upperObstacle.runAction(moveObstacle)
        
        upperObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: upperObstacle.size)
        upperObstacle.physicsBody?.dynamic = false
        upperObstacle.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        
        movingObjects.addChild(upperObstacle)
        
        // Create upper obsticle
        var lowerObstacleTexture = SKTexture(imageNamed: "rock")
        var lowerObstacle = SKSpriteNode(texture: lowerObstacleTexture)
        lowerObstacle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + lowerObstacle.size.height)
        //        lowerObstacle.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width + 400, y: lowerObstacle.size.height / 2)
        //        lowerObstacle.runAction(moveAndRemoveObsticle)
        //        lowerObstacle.runAction(moveObstacle)
        
        lowerObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: lowerObstacle.size)
        lowerObstacle.physicsBody?.dynamic = false
        lowerObstacle.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        
        movingObjects.addChild(lowerObstacle)
        
    }
    
    func createClouds(sceneView: SKView) {
        // TODO: Create clouds
    }
    
    func createPlane(sceneView: SKView) {
        let planeTexture = SKTexture(imageNamed: "planeRed1")
        let planeTexture1 = SKTexture(imageNamed: "planeRed2")
        let planeTexture2 = SKTexture(imageNamed: "planeRed3")
        
        // Animate plans propeller
        let animation = SKAction.animateWithTextures([planeTexture, planeTexture1, planeTexture2], timePerFrame: 0.05)
        let makePropellerSpin = SKAction.repeatActionForever(animation)
        
        // Set planes position
        plane = SKSpriteNode(texture: planeTexture)
        plane.position = CGPointMake(size.width/4, size.height/2)
        
        plane.runAction(makePropellerSpin)
        
        plane.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(plane.size.width, plane.size.height))
        plane.physicsBody?.dynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        
        // Set elevation
        plane.zPosition = zLevel.Bird
        
        self.addChild(plane)
    }
    
    // MARK: Cache scene data
    func loadResources(view: SKView){
        // Plane crash sound effect
        planeCrashFX = SKAction.repeatAction(SKAction.playSoundFileNamed("planeCrash.mp3", waitForCompletion: true), count: 1)
        
        // Ground
        groundTexture = SKTexture(imageNamed: "groundGrass")
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("Plane crashed")
        
        
        runAction(planeCrashFX)
    }
}
