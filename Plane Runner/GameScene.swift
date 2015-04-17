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
    var rockTexture = SKTexture()
    var rockDownTexture = SKTexture()
    var gameOverText = SKSpriteNode()
    
    var labelHolder = SKSpriteNode()
    var moveAndRemove = SKAction()
    var movingObjects = SKNode()
    
    var audioPlayer = AVAudioPlayer()
    
    var gameOver = false
    
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
        static let Clouds       : CGFloat = -1.0
        static let Rocks        : CGFloat = 0.0
        static let Ground       : CGFloat = 1.0
        static let Plane         : CGFloat = 5.0
    }
    
    override func didMoveToView(view: SKView) {
        
        // Loads all scenes resources
        loadResources()
        
        // Play background track
        //        let backgrountTrack = SKAction.repeatActionForever(SKAction.playSoundFileNamed("backgroundTrack.mp3", waitForCompletion: true))
        //        self.runAction(backgrountTrack)
        
        loopBackgroundTrack()
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        // Change gravity
        self.physicsWorld.gravity = CGVectorMake(0, -1.6)
        self.physicsBody?.restitution = 0.0
        
        
        createBackground()
        createBoundry()
        createGround()
        createPlane()
        
        obstacleSetUp()
        
        
        // Uncomment to show physics
        view.showsPhysics = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        if gameOver {
            
            movingObjects.removeAllChildren()
            
            createBackground()
            createGround()
            
            plane.position = CGPointMake(size.width/4, size.height/2)
            plane.physicsBody?.velocity = CGVectorMake(0, 0)
            
            labelHolder.removeAllChildren()
            
            movingObjects.speed = 1
            
            gameOver = false
            
        } else {
            
            let planeFly = SKAction.repeatAction(SKAction.playSoundFileNamed("Helicopter.mp3", waitForCompletion: true), count: 1)
            runAction(planeFly)
            
            plane.physicsBody?.velocity = CGVectorMake(0, 0)
            plane.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Scene setup helpers
    
    func loopBackgroundTrack() {
        
        let path = NSBundle.mainBundle().pathForResource("backgroundTrack", ofType: ".mp3")
        let url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        audioPlayer.volume = 0.2
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func obstacleSetUp() {
        let distanceToMove = CGFloat(self.frame.width + 5.0 * rockTexture.size().width)
        let moveRocks = SKAction.moveByX(-distanceToMove, y: 0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removeRocks = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([moveRocks, removeRocks])
        
        // Create Action to spawn new obstacles after delay.
        let spawn = SKAction.runBlock({
            () in self.createObstacles()
        })
        let delay = SKAction.waitForDuration(NSTimeInterval(7.0))
        let spawnAndDelay = SKAction.sequence([spawn, delay])
        let spawnAndDelayForever = SKAction.repeatActionForever(spawnAndDelay)
        self.runAction(spawnAndDelayForever)
    }
    
    func createBackground(){
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
    
    func createBoundry() {
        // Create ground
        var boundary = SKNode()
        boundary.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.categoryBitMask = PhysicsCategory.Boundary
        
        self.addChild(boundary)
    }
    
    func createGround() {

        // Create action to replace ground
        var moveGround = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 8)
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
            ground.physicsBody?.restitution = 0.0
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
            
            movingObjects.addChild(ground)
        }
    }
    
    func createObstacles() {
        
        if gameOver == false {
            
            // Create upper obstacle
            let rockDown = SKSpriteNode(texture: rockDownTexture)
            rockDown.position = CGPoint(x: self.frame.width + rockDown.size.width, y: CGRectGetMaxY(self.frame) - rockDown.size.height + 50)
            rockDown.zPosition = zLevel.Rocks
            rockDown.runAction(moveAndRemove)
            // Physics
            rockDown.physicsBody = SKPhysicsBody(rectangleOfSize: rockDown.size)
            rockDown.physicsBody?.dynamic = false
            rockDown.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            movingObjects.addChild(rockDown)
            
            // Create lower obstacle
            let rock = SKSpriteNode(texture: rockTexture)
            rock.position = CGPoint(x: self.frame.width + rock.size.width * 4, y: rock.size.height - 10)
            rock.zPosition = zLevel.Rocks
            rock.runAction(moveAndRemove)
            // Physics
            rock.physicsBody = SKPhysicsBody(rectangleOfSize: rock.size)
            rock.physicsBody?.dynamic = false
            rock.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            movingObjects.addChild(rock)
        }
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
        
        // Set planes position
        plane = SKSpriteNode(texture: planeTexture)
        plane.position = CGPointMake(size.width/4, size.height/2)
        
        plane.runAction(makePropellerSpin)
        
        plane.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(plane.size.width, plane.size.height))
        plane.physicsBody?.dynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.restitution = 0.0
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        
        // Set elevation
        plane.zPosition = zLevel.Plane
        
        self.addChild(plane)
    }
    
    // MARK: Cache scene data
    func loadResources(){
        // Plane crash sound effect
        planeCrashFX = SKAction.repeatAction(SKAction.playSoundFileNamed("planeCrash.mp3", waitForCompletion: true), count: 1)
        
        // Ground
        groundTexture = SKTexture(imageNamed: "groundGrass")
        
        // Rock
        rockTexture = SKTexture(imageNamed: "rock")
        
        // Rock Down
        rockDownTexture = SKTexture(imageNamed: "rockDown")
        
        // Add label holder
        self.addChild(labelHolder)
        
        // Game Over
        let gameOverTexture = SKTexture(imageNamed: "textGameOver")
        gameOverText = SKSpriteNode(texture: gameOverTexture)
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("Plane crashed")
        
        
        runAction(planeCrashFX)
        //        plane.physicsBody?.velocity = CGVectorMake(0, 0)
        plane.physicsBody?.applyImpulse(CGVectorMake(0, -200))
        
        
        if gameOver == false {
            gameOver = true
            movingObjects.speed = 0
            
            gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            
            labelHolder.addChild(gameOverText)
        }
        
    }
}
