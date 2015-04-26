//
//  LevelOneScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/22/15.
//
//

import SpriteKit
import AVFoundation

class LevelOneScene: SKScene {
    
    var gamePaused = false
    
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    var bg = SKSpriteNode()
    var plane = SKSpriteNode()
    var testPlane:Plane!
    var groundTexture = SKTexture()
    var ground = SKSpriteNode()
    var rockTexture = SKTexture()
    var rockDownTexture = SKTexture()
    var gameOverText = SKSpriteNode()
    
    var hud = SKNode()
    var distanceFlown = 0
    var hudDistanceLabel = SKLabelNode(fontNamed: GameFont)
    var hudPauseButn = SKSpriteNode()
    var labelHolder = SKSpriteNode()
    var moveAndRemove = SKAction()
    var movingObjects = SKNode()
    
    var audioPlayer = AVAudioPlayer()
    
    var isTouching = false
    var gameOver = false
    
    // Scene Resources
    var planeCrashFX = SKAction()
    var distanceIncreasFX = SKAction()
    var planeFlyingFX = SKAction()
    
    // Pause Menu Resouces
    let pauseNode = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        println("Size height: \(size.width) Width: \(size.height)")
        println("View Height: \(view.bounds.height) Width: \(view.bounds.width)")
        
        
        // Loads all scenes resources
        loadResources()
        
        loopBackgroundTrack(view)
        //        LevelHelper.playBackgroundMusic(view)
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        // Change gravity
        self.physicsWorld.gravity = CGVectorMake(0, -1.6)
        self.physicsBody?.restitution = 0.0
        
        createHUD(view)
        createBackground(view)
        createBoundry(view)
        createGround(view)
        createDistanceMarkers(view)
        
        //        var testnode = SKSpriteNode()
        //
        //        let newPlane = Plane(textureNames: ["planeYellow1", "planeYellow2", "planeYellow3"])
        //        newPlane.position = CGPointMake(size.width/4, size.height/2)
        ////        newPlane.start()
        //        testnode.addChild(newPlane)
        //
        //        self.addChild(newPlane)
        
        
        
        createPlane(view)
        obstacleSetUp(view)
        
        
        // Uncomment to show physics
        view.showsPhysics = true
    }
    
    func updateDistance() {
        runAction(distanceIncreasFX)
        distanceFlown++
        hudDistanceLabel.text = "Distance: \(distanceFlown) meters"
    }
    
    // MARK: Scene setup helpers
    func loopBackgroundTrack(view: SKView) {
        
        let path = NSBundle.mainBundle().pathForResource(BackgroundMusicSound, ofType: ".mp3")
        let url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        audioPlayer.volume = 0.1
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func obstacleSetUp(view: SKView) {
        let distanceToMove = CGFloat(view.bounds.width + 5.0 * rockTexture.size().width)
        //        let distanceToMove = SKAction.moveByX(-rockTexture.size().width, y: 0, duration: <#NSTimeInterval#>)
        let moveRocks = SKAction.moveByX(-distanceToMove, y: 0, duration: 8 /*NSTimeInterval(0.01 * distanceToMove)*/)
        let removeRocks = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([moveRocks, removeRocks])
        
        // Create Action to spawn new obstacles after delay.
        let spawn = SKAction.runBlock({
            () in self.createObstacles(view)
            self.createDistanceMarkers(view)
        })
        let delay = SKAction.waitForDuration(NSTimeInterval(4.0))
        let spawnAndDelay = SKAction.sequence([spawn, delay])
        let spawnAndDelayForever = SKAction.repeatActionForever(spawnAndDelay)
        self.runAction(spawnAndDelayForever)
    }
    
    func createBackground(view: SKView){
        //        var bgTexture = SKTexture(imageNamed: BackgroundImage)
        
        // Create action to replace background
        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 20)
        var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        // Create 3 backgrounds for endless scrolling
        for var i:CGFloat = 0; i < 3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: size.height/2)
            bg.size = size
            bg.zPosition = ZLevel.Background
            
            bg.runAction(movebgForever)
            
            movingObjects.addChild(bg)
        }
    }
    
    func createBoundry(view: SKView) {
        // Create ground
        var boundary = SKNode()
        boundary.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        boundary.physicsBody?.dynamic = false
        ground.physicsBody?.restitution = 0.0
        boundary.physicsBody?.categoryBitMask = PhysicsCategory.Boundary
        
        self.addChild(boundary)
    }
    
    func createGround(view: SKView) {
        
        // Create action to replace ground
        var moveGround = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 8)
        var replaceGround = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0)
        var moveGroundForever = SKAction.repeatActionForever(SKAction.sequence([moveGround, replaceGround]))
        
        // Create 3 grounds for endless scrolling
        for var i:CGFloat = 0; i < 7; i++ {
            
            ground = SKSpriteNode(texture: groundTexture)
            //            ground.setScale(0.5)
            ground.position = CGPoint(x: ground.size.width / 2 + ground.size.width * i, y: ground.size.height / 2)
            ground.zPosition = ZLevel.Ground
            
            ground.runAction(moveGroundForever)
            
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(ground.size.width, ground.size.height))
            ground.physicsBody?.dynamic = false
            ground.physicsBody?.restitution = 0.0
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
            
            movingObjects.addChild(ground)
        }
    }
    
    func createObstacles(view: SKView) {
        
        if gameOver == false {
            
            // Create upper obstacle
            let rockDown = SKSpriteNode(texture: rockDownTexture)
            rockDown.position = CGPoint(x: self.frame.width + rockDown.size.width, y: CGRectGetMaxY(self.frame) - rockDown.size.height/2)
            rockDown.zPosition = ZLevel.Rocks
            rockDown.runAction(moveAndRemove)
            // Physics
            rockDown.physicsBody = SKPhysicsBody(rectangleOfSize: rockDown.size)
            rockDown.physicsBody?.dynamic = false
            rockDown.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            movingObjects.addChild(rockDown)
            
            // Create lower obstacle
            let rock = SKSpriteNode(texture: rockTexture)
            rock.position = CGPoint(x: self.frame.width + rock.size.width, y: rock.size.height/2)
            rock.zPosition = ZLevel.Rocks
            rock.runAction(moveAndRemove)
            // Physics
            rock.physicsBody = SKPhysicsBody(rectangleOfSize: rock.size)
            rock.physicsBody?.dynamic = false
            rock.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            movingObjects.addChild(rock)
        }
    }
    
    func createClouds(view: SKView) {
        // TODO: Create clouds
    }
    
    func createDistanceMarkers(view: SKView) {
//        var moveGround = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 8)
//        var replaceGround = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0)
//        var moveGroundForever = SKAction.repeatActionForever(SKAction.sequence([moveGround, replaceGround]))
        
        
        let moveMarker = SKAction.moveByX(-size.width/2, y: 0, duration: 8)
        let removeMarker = SKAction.removeFromParent()
        let moveAndRemoveMarker = SKAction.repeatActionForever(SKAction.sequence([moveMarker, removeMarker]))
        
        
        let distanceMarker = SKNode()
        distanceMarker.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointMake(CGRectGetMidX(self.frame), 0), toPoint: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)))
        distanceMarker.physicsBody?.dynamic = false
        distanceMarker.physicsBody?.categoryBitMask = PhysicsCategory.Distance

        distanceMarker.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        distanceMarker.physicsBody?.dynamic = true
        distanceMarker.runAction(moveAndRemoveMarker)
        
        movingObjects.addChild(distanceMarker)
    }
    
    func createPlane(view: SKView) {
        let planeTexture = SKTexture(imageNamed: PlaneOneImage)
        let planeTexture1 = SKTexture(imageNamed: PlaneTwoImage)
        let planeTexture2 = SKTexture(imageNamed: PlaneThreeImage)
        
        // Animate plans propeller
        let animation = SKAction.animateWithTextures([planeTexture, planeTexture1, planeTexture2], timePerFrame: 0.05)
        let makePropellerSpin = SKAction.repeatActionForever(animation)
        
        // Set planes position
        plane = SKSpriteNode(texture: planeTexture)
        //        plane.setScale(0.5)
        plane.position = CGPointMake(size.width/4, size.height/2)
        
        plane.runAction(makePropellerSpin)
        
        plane.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(plane.size.width, plane.size.height))
        plane.physicsBody?.dynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.restitution = 0.0
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground | PhysicsCategory.Distance
        
        // Set elevation
        plane.zPosition = ZLevel.Plane
        
        self.addChild(plane)
    }
    
    func createHUD(view: SKView) {
        
        // Create pause button
        let pauseTexture = SKTexture(imageNamed: ButtonSmallImage)
        hudPauseButn = SKSpriteNode(texture: pauseTexture)
        hudPauseButn.position = CGPoint(x: CGRectGetMaxX(self.frame) - hudPauseButn.size.width / 2 - 10, y: CGRectGetMaxY(self.frame) - hudPauseButn.size.height / 2 - 10)
        
        // Add to hud
        hud.addChild(hudPauseButn)
        
        // Create distance label
        hudDistanceLabel.text = "Distance: \(distanceFlown) meters"
        hudDistanceLabel.fontColor = SKColor.blackColor()
        hudDistanceLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        hudDistanceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        hudDistanceLabel.position = CGPoint(x: 10, y: CGRectGetMaxY(self.frame) - 10)
        
        // Add to hud
        hud.addChild(hudDistanceLabel)
        
        
        
        
        hud.zPosition = ZLevel.HUD
        self.addChild(hud)
        
    }
    
    // MARK: Cache scene data
    func loadResources(){
        // Plane crash sound effect
        planeCrashFX = SKAction.repeatAction(SKAction.playSoundFileNamed(PlaneCrashSoundFX, waitForCompletion: true), count: 1)
        
        // Distance increase sound effect
        distanceIncreasFX = SKAction.repeatAction(SKAction.playSoundFileNamed(DistanceIncreaseSoundFX, waitForCompletion: true), count: 1)
        
        // Plane flying sound effect
        planeFlyingFX = SKAction.repeatAction(SKAction.playSoundFileNamed(PlaneFlyingSoundFX, waitForCompletion: true), count: 1)
        
        // Ground
        groundTexture = SKTexture(imageNamed: GroundGrassImage)
        
        // Rock
        rockTexture = SKTexture(imageNamed: RockGrassImage)
        
        // Rock Down
        rockDownTexture = SKTexture(imageNamed: RockGrassDownImage)
        
        // Add label holder
        self.addChild(labelHolder)
        
        // Game Over
        let gameOverTexture = SKTexture(imageNamed: TextGameOver)
        gameOverText = SKSpriteNode(texture: gameOverTexture)
    }
}

// MARK: Pause Game Node
extension LevelOneScene {
    
    func pauseGame() {
        gamePaused = true
        // pause physics
        self.paused = true
        if audioPlayer.playing{
            audioPlayer.pause()
        }
        
    }
    
    func resumeGame() {
        gamePaused = false
        // Unpause physics
        self.paused = false
        if !audioPlayer.playing {
            audioPlayer.play()
        }
    }
}

// MARK: Input Methods
extension LevelOneScene {
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        println("View Height: \(view!.bounds.height) Width: \(view!.bounds.width)")
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if hudPauseButn.containsPoint(location) {
                println("Pause/Play")
                if self.paused {
                    resumeGame()
                } else {
                    pauseGame()
                }
            } else {
                if gameOver {
                    
                    movingObjects.removeAllChildren()
                    
                    createBackground(view!)
                    createGround(view!)
                    distanceFlown = 0
                    hudDistanceLabel.text = "Distance: \(distanceFlown) meters"
                    
                    plane.position = CGPointMake(size.width/4, size.height/2)
                    plane.physicsBody?.velocity = CGVectorMake(0, 0)
                    
                    labelHolder.removeAllChildren()
                    
                    movingObjects.speed = 1
                    
                    gameOver = false
                    
                } else if !self.paused {
                    isTouching = true
                    runAction(planeFlyingFX)
                    //
                    // plane.physicsBody?.velocity = CGVectorMake(0, 0)
                    // plane.physicsBody?.applyImpulse(CGVectorMake(0, 10))
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        isTouching = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if isTouching {
            plane.physicsBody?.applyForce(CGVectorMake(0, 50))
        }
    }
}

// MARK: SKPhysicsContactDelegate
extension LevelOneScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        var notPlane = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            notPlane = contact.bodyB
        } else {
            notPlane = contact.bodyA
        }
        
        if notPlane.categoryBitMask == PhysicsCategory.Distance {
            // TODO: Add to distance label
            println("distance increased")
            updateDistance()
        } else {
            println("Plane crashed")
            
            runAction(planeCrashFX)
            plane.physicsBody?.velocity = CGVectorMake(0, 0)
            plane.physicsBody?.applyImpulse(CGVectorMake(0, -50))
            
            
            if gameOver == false {
                gameOver = true
                movingObjects.speed = 0
                
                gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                
                labelHolder.addChild(gameOverText)
            }
        }
    }
}
