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
    private var backgroundNode: SKSpriteNode!
    private var backgroundLevelNode: SKSpriteNode!
    
    // Sound Actions
    var planeCrashFX: SKAction!
    var distanceIncreasFX: SKAction!
    var planeFlyingFX: SKAction!
    
    // Labels
    private var labelHolderGameOver = SKSpriteNode()
    private var labelHolderGetReady = SKSpriteNode()
    
    // Boolians
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
        createBackground(view)
    }
}

// MARK: Level setup
extension LevelScene {
    
    func loadResouces(){
        // Get total length of level from dictionary
        endLevelX = levelData["EndX"]!.integerValue!
        
        // Plane crash sound effect
        planeCrashFX = SKAction.repeatAction(SKAction.playSoundFileNamed(PlaneCrashSoundFX, waitForCompletion: true), count: 1)
        
        // Distance increase sound effect
        distanceIncreasFX = SKAction.repeatAction(SKAction.playSoundFileNamed(DistanceIncreaseSoundFX, waitForCompletion: true), count: 1)
        
        // Plane flying sound effect
        planeFlyingFX = SKAction.repeatAction(SKAction.playSoundFileNamed(PlaneFlyingSoundFX, waitForCompletion: true), count: 1)
    }
    
    func createBackground(view: SKView) {
        // Create scene background
        backgroundLevelNode = SKSpriteNode()
        
        // Set up variables for while loop
        var i: CGFloat = 0
        sceneLength = CGFloat(endLevelX)
        
        while i < sceneLength + view.frame.width {
            
            let bg = SKSpriteNode(texture: backgroundTexture)
            bg.size = view.frame.size
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.position = CGPoint(x: i, y: 0)
            
            backgroundLevelNode.addChild(bg)
            
            i = i + bg.size.width
        }
        
        movingNodes.addChild(backgroundLevelNode)
    }
}

// MARK: Play/Pause/Resume
extension LevelScene {
    
    func play(){
        // Action to move backgorund
        let moveBg = SKAction.moveByX(-sceneLength, y: 0, duration: NSTimeInterval(sceneLength/100))
        backgroundLevelNode.runAction(moveBg)
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









