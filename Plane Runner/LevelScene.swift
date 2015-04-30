//
//  LevelScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/29/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    // World Node
    let worldNode = SKNode()
    // Moving Node
    let movingNodes = SKNode()
    // Level Dictionary
    let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
    var levelData: NSDictionary!
    // Win distance
    var endLevelX = 0
    var sceneLength: CGFloat!
    
    // Level Textures
    private let backgroundTexture = SKTexture(imageNamed: BackgroundImage)
    private let groundTexture = SKTexture(imageNamed: GroundGrassImage)
    private let rockTexture = SKTexture(imageNamed: RockGrassImage)
    private let rockDownTexture = SKTexture(imageNamed: RockGrassDownImage)
    private let gameOverTexture = SKTexture(imageNamed: TextGameOver)
    
    // Level Image Nodes
//    private var backgroundNode: SKSpriteNode!
    private var backgroundLevelNode: SKSpriteNode!
    private var foregroundLevelNode: SKSpriteNode!
    
    // Sound Actions
    var planeCrashFX: SKAction!
    var distanceIncreasFX: SKAction!
    var planeFlyingFX: SKAction!
    
    // Labels
    private var labelHolderGameOver = SKSpriteNode()
    private var labelHolderGetReady = SKSpriteNode()
    
    // Booleans
    private var gameStarted = false
    private var gamePause = false
    private var gameOver = false
    private var isTouching = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        levelData = NSDictionary(contentsOfFile: levelPlist!)
        loadResouces()
    }
}

// MARK: Lifecycle methods
extension LevelScene {
    
    override func didMoveToView(view: SKView) {
        // Add world node to main scene
        addChild(worldNode)
        // Add moving nodes to world
        worldNode.addChild(movingNodes)
        
        loadResouces()
        createBoundry(view)
        createBackground(view)
        createGround(view)
        createObsticles(view)
        createClouds(view)
        createDistanceMarkers(view)
    }
}

// MARK: Level setup
extension LevelScene {
    
    func loadResouces(){
        // Get total length of level from dictionary
        endLevelX = levelData["EndX"]!.integerValue!
        sceneLength = CGFloat(endLevelX)
        
        // Create scene background
        backgroundLevelNode = SKSpriteNode()
        backgroundLevelNode.zPosition = ZLevel.Background
        // Create scene foreground
        foregroundLevelNode = SKSpriteNode()
        foregroundLevelNode.zPosition = ZLevel.Foreground
        
        // Plane crash sound effect
        planeCrashFX = SKAction.repeatAction(SKAction.playSoundFileNamed(PlaneCrashSoundFX, waitForCompletion: true), count: 1)
        
        // Distance increase sound effect
        distanceIncreasFX = SKAction.repeatAction(SKAction.playSoundFileNamed(DistanceIncreaseSoundFX, waitForCompletion: true), count: 1)
        
        // Plane flying sound effect
        planeFlyingFX = SKAction.repeatAction(SKAction.playSoundFileNamed(PlaneFlyingSoundFX, waitForCompletion: true), count: 1)
    }
    
    func createBoundry(view: SKView) {
        let boundry = SKNode()
        boundry.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        boundry.physicsBody?.dynamic = false
        boundry.physicsBody?.restitution = 0.0
        boundry.physicsBody?.categoryBitMask = PhysicsCategory.Boundary
        
        worldNode.addChild(boundry)
    }
    
    func createBackground(view: SKView) {
        
        // Set up variables for while loop
        var i: CGFloat = 0
        
        // Number of backgrounds created
        var numBgCreated = 0
        
        while i < sceneLength + view.frame.width {
            numBgCreated++
            
            let bg = SKSpriteNode(texture: backgroundTexture)
            bg.size = view.frame.size
            bg.position = CGPoint(x: i, y: view.frame.height/2)
            bg.zPosition = ZLevel.Background
            
            backgroundLevelNode.addChild(bg)
            
            i = i + bg.size.width
        }
        
        println("Number of backgrounds created \(numBgCreated)")
        movingNodes.addChild(backgroundLevelNode)
    }
    
    func createGround(view: SKView) {
        var i: CGFloat = 0
        
        var numGroundCreated = 0
        
        while i < sceneLength + view.frame.width {
            numGroundCreated++
            
            let ground = SKSpriteNode(texture: groundTexture)
            ground.position = CGPoint(x: i, y: ground.frame.height/2)
            ground.zPosition = ZLevel.Ground
            
            // Set physics
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
            ground.physicsBody?.dynamic = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
            
            foregroundLevelNode.addChild(ground)
            
            i = i + ground.size.width
        }
        println("Number of grounds created \(numGroundCreated)")
    }
    
    func createObsticles(view: SKView) {
        
        // Create lower rocks
        let rocksDictionary = levelData["Rocks"] as! NSDictionary
        let rocksArray = rocksDictionary["Positions"] as! [NSDictionary]
        
        for rock in rocksArray {
            
            
            let rockNode = SKSpriteNode(texture: rockTexture)
            rockNode.setScale(2.0)
            
            let x = rock["x"]?.floatValue
            let y = rock["y"]?.floatValue
            let xPosition = CGFloat(x!) - rockNode.size.width/2
            let yPosition = CGFloat(y!) + rockNode.size.height/2
            
            rockNode.position = CGPoint(x: xPosition, y: yPosition)
            rockNode.zPosition = ZLevel.Rocks
            
            println("Rock postion x:\(xPosition) y:\(yPosition)")
            
            // Set physics
            rockNode.physicsBody = SKPhysicsBody(rectangleOfSize: rockNode.size)
            rockNode.physicsBody?.dynamic = false
            rockNode.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            foregroundLevelNode.addChild(rockNode)
        }
        
        // Create upper rocks
        let rocksDownDictionary = levelData["RocksDown"] as! NSDictionary
        let rocksDownArray = rocksDownDictionary["Positions"] as! [NSDictionary]
        
        for rockDown in rocksDownArray {
            
            let rockDownNode = SKSpriteNode(texture: rockDownTexture)
            rockDownNode.setScale(2.0)
            
            let x = rockDown["x"]?.floatValue
            let xPosition = CGFloat(x!) - rockDownNode.size.width/2
            let yPosition = view.frame.height - rockDownNode.size.height/2
            
            rockDownNode.position = CGPoint(x: xPosition, y: yPosition)
            rockDownNode.zPosition = ZLevel.Rocks
            
            println("RockDown postion x:\(xPosition) y:\(yPosition)")
            
            // Set physics
            rockDownNode.physicsBody = SKPhysicsBody(rectangleOfSize: rockDownNode.size)
            rockDownNode.physicsBody?.dynamic = false
            rockDownNode.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            foregroundLevelNode.addChild(rockDownNode)
        }
        movingNodes.addChild(foregroundLevelNode)
    }
    
    func createClouds(view: SKView) {
        // TODO: Create clouds
    }
    
    func createDistanceMarkers(view: SKView) {
        var i: CGFloat = 10
        
        while i < sceneLength {
            let distanceMarkerNode = SKNode()
            distanceMarkerNode.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: i, y: 0), toPoint: CGPoint(x: i, y: view.frame.height))
            distanceMarkerNode.physicsBody?.dynamic = false
            distanceMarkerNode.physicsBody?.categoryBitMask = PhysicsCategory.Distance
            distanceMarkerNode.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
            
            foregroundLevelNode.addChild(distanceMarkerNode)
            
            i = i + 10
        }
    }
}

// MARK: Play/Pause/Resume
extension LevelScene {
    
    func play(){
        // Action to move background
        let moveBg = SKAction.moveByX(-sceneLength, y: 0, duration: NSTimeInterval(sceneLength/50))
        backgroundLevelNode.runAction(moveBg)
        
        // Action to move foreground
        let moveFg = SKAction.moveByX(-sceneLength, y: 0, duration: NSTimeInterval(sceneLength/100))
        foregroundLevelNode.runAction(moveFg)
    }
    
    func pause() {
        // TODO: Setup pause
    }
    
    func resume() {
        // TODO: Setup resume
    }
}

// MARK: Input methods
extension LevelScene {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // TODO: Setup touches
        if !gameStarted {
            gameStarted = true
            play()
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // TODO: Setup touches ended
    }
    
    override func update(currentTime: NSTimeInterval) {
        // TODO: Setup scene update
    }
}

// MARK: SKPhysicsContactDelegate
extension LevelScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        // TODO: Setup contact methods
    }
}









