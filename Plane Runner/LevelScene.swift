//
//  LevelScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/29/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

class LevelScene: SKScene {
    
    // Data manager
    let levelManager = LevelManager.sharedInstance
    
    // World Node
    let worldNode = SKNode()
    // Moving Node
    let movingNodes = SKNode()
    // Tutorial Node
    let tutorialNode = SKNode()
    
    // Level Dictionary
    var level: StageLevel!
    var levelPlistPath: String!
    var levelData: NSDictionary!
    
    // Win distance
    var endLevelX = 0
    var sceneLength: CGFloat!
    
    // Audio Player
    var audioPlayer = AVAudioPlayer()
    
    // Emitters
    var starBronzeEmmiter: SKEmitterNode!
    var starSilverEmmiter: SKEmitterNode!
    var starGoldEmmiter:SKEmitterNode!
    
    // Level Textures
    let backgroundTexture   = SKTexture(imageNamed: BackgroundImage)
    let groundTexture       = SKTexture(imageNamed: GroundGrassImage)
    let rockTexture         = SKTexture(imageNamed: RockGrassImage)
    let rockDownTexture     = SKTexture(imageNamed: RockGrassDownImage)
    let planeTexture        = SKTexture(imageNamed: PlaneOneImage)
    let planeTexture1       = SKTexture(imageNamed: PlaneTwoImage)
    let planeTexture2       = SKTexture(imageNamed: PlaneThreeImage)
    let gameOverTexture     = SKTexture(imageNamed: TextGameOver)
    let pauseTexture        = SKTexture(imageNamed: ButtonSmallImage)
    let pauseIconTexture    = SKTexture(imageNamed: PauseIconImage)
    let tapTexture          = SKTexture(imageNamed: TapTick)
    let starTexture         = SKTexture(imageNamed: StarGold)
    let uiBackground        = SKTexture(imageNamed: UIBackgroundImage)
    let replyBtnTexture     = SKTexture(imageNamed: Replay)
    let nextLevelBtnTexture = SKTexture(imageNamed: NextLevel)
    let LevelMenuTexture    = SKTexture(imageNamed: LevelMenu)
    let starEmptyTexture    = SKTexture(imageNamed: StarEmpty)
    let starBronzeTexture   = SKTexture(imageNamed: StarBronze)
    let starSilverTexture   = SKTexture(imageNamed: StarSilver)
    let starGoldTexture     = SKTexture(imageNamed: StarGold)
    
    // Level Image Nodes
    var backgroundLevelNode: SKSpriteNode!
    var foregroundLevelNode: SKSpriteNode!
    var plane: SKSpriteNode!
    
    // Win/Lose Dialog Nodes
    var levelUI: SKSpriteNode!
    var levelDialog = SKNode()
    var winLoseTextNode: SKSpriteNode!
    var replayBtn: SKSpriteNode!
    var nextBtn: SKSpriteNode!
    var levelMenuBtn: SKSpriteNode!
    var starHolderNode: SKSpriteNode!
    
    // HUD
    var hud = SKNode()
    var hudDistanceLabel = SKLabelNode(fontNamed: GameFont)
    var hudPauseButn = SKNode()
    var hudStarNode = SKNode()
    var hudStarLabel = SKLabelNode(fontNamed: GameFont)
    
    // Sound Actions
    var planeCrashFX: SKAction!
    var distanceIncreasFX: SKAction!
    var planeFlyingFX: SKAction!
    var starFX: SKAction!
    var clickFX: SKAction!
    
    // Labels
    var labelHolderGetReady = SKSpriteNode()
    
    // Booleans
    var gameStarted = false
    var gamePaused = false
    var gameOver = false
    var isTouching = false
    var levelWon = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(size: CGSize, level: StageLevel) {
        super.init(size: size)
        self.level = level
        levelPlistPath = Bundle.main.path(forResource: level.name, ofType: "plist")!
        levelData = NSDictionary(contentsOfFile: levelPlistPath)
    }
}

// MARK: Lifecycle methods
extension LevelScene {
    
    override func didMove(to view: SKView) {
        // Add world node to main scene
        addChild(worldNode)
        // Add moving nodes to world
        worldNode.addChild(movingNodes)
        // Add tutorial node
        worldNode.addChild(tutorialNode)
        
        // Assign contact delegate to current class
        self.physicsWorld.contactDelegate = self
        
        // Change gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        self.physicsBody?.restitution = 0.0
        
        // Obtaine prepared audio player from helper class
        audioPlayer = LevelHelper.prepareAudioPlayer(view)
        // Insure its prepared and start playing background audio.
        if audioPlayer.prepareToPlay() {
            audioPlayer.play()
        }
        
        // Reset points in levelManager
        levelManager.reset()
        
        // Configure scene
        loadResouces()
        createHUD(view)
        createBoundry(view)
        createBackground(view)
        createGround(view)
        createObsticles(view)
        createClouds(view)
        createDistanceMarkers(view)
        createPlane(view)
        createTutorial(view)
        createStars(view)
    }
}

// MARK: Level setup
extension LevelScene {
    
    func loadResouces(){
        // Get total length of level from dictionary
        endLevelX = (levelData["EndX"]! as AnyObject).intValue!
        sceneLength = CGFloat(endLevelX)
        
        // Create scene background
        backgroundLevelNode = SKSpriteNode()
        backgroundLevelNode.zPosition = ZLevel.Background
        // Create scene foreground
        foregroundLevelNode = SKSpriteNode()
        foregroundLevelNode.zPosition = ZLevel.Foreground
        
        // Plane crash sound effect
        planeCrashFX = SKAction.repeat(SKAction.playSoundFileNamed(PlaneCrashSoundFX, waitForCompletion: true), count: 1)
        
        // Distance increase sound effect
        distanceIncreasFX = SKAction.repeat(SKAction.playSoundFileNamed(DistanceIncreaseSoundFX, waitForCompletion: true), count: 1)
        
        // Plane flying sound effect
        planeFlyingFX = SKAction.repeat(SKAction.playSoundFileNamed(PlaneFlyingSoundFX, waitForCompletion: true), count: 1)
        
        // Star sound effect
        starFX = SKAction.repeat(SKAction.playSoundFileNamed(StarFX, waitForCompletion: true), count: 1)
        
        // Click sound effect
        clickFX = SKAction.repeat(SKAction.playSoundFileNamed(ClickFX, waitForCompletion: true), count: 1)
    }
    
    func createHUD(_ view: SKView) {
        // Create pause button
        let pauseButton = SKSpriteNode(texture: pauseTexture)
        pauseButton.setScale(1.4)
        pauseButton.position = CGPoint(x: view.frame.width - pauseButton.size.width / 2 - 10, y: view.frame.height - pauseButton.size.height / 2 - 10)
        
        // Create pause icon
        let pauseIcon = SKSpriteNode(texture: pauseIconTexture)
        pauseIcon.position = CGPoint(x: view.frame.width - pauseButton.size.width / 2 - 10, y: view.frame.height - pauseButton.size.height / 2 - 10)
        
        hudPauseButn.addChild(pauseButton)
        hudPauseButn.addChild(pauseIcon)
        
        // Add to hud
        hud.addChild(hudPauseButn)
        
        // Create distance label
        hudDistanceLabel.text = "Distance: \(levelManager.distance) meters"
        hudDistanceLabel.fontColor = SKColor.black
        hudDistanceLabel.fontSize = 14
        hudDistanceLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        hudDistanceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        hudDistanceLabel.position = CGPoint(x: 10, y: self.frame.maxY - 10)
        
        // Add to hud
        hud.addChild(hudDistanceLabel)
        
        // Create star lable
        let star = SKSpriteNode(texture: starTexture)
        star.position = CGPoint(x: 10 + star.size.width / 2, y: view.frame.height - hudDistanceLabel.frame.height - 20)
        
        hudStarLabel.text = "= \(levelManager.starsCollected)"
        hudStarLabel.fontColor = SKColor.black
        hudStarLabel.fontSize = 14
        hudStarLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        hudStarLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        hudStarLabel.position = CGPoint(x: 10 + star.size.width, y: view.frame.height - hudDistanceLabel.frame.height - 20)
        
        hudStarNode.addChild(star)
        hudStarNode.addChild(hudStarLabel)
        
        // Add to hud
        hud.addChild(hudStarNode)
        
        hud.zPosition = ZLevel.HUD
        worldNode.addChild(hud)
    }
    
    func createBoundry(_ view: SKView) {
        let boundry = SKNode()
        boundry.physicsBody = SKPhysicsBody(edgeLoopFrom: view.frame)
        boundry.physicsBody?.isDynamic = false
        boundry.physicsBody?.restitution = 0.0
        boundry.physicsBody?.categoryBitMask = PhysicsCategory.Boundary
        
        worldNode.addChild(boundry)
    }
    
    func createBackground(_ view: SKView) {
        
        // Set up variables for while loop
        var i: CGFloat = 0
        
        // Number of backgrounds created
        var numBgCreated = 0
        
        while i < sceneLength + view.frame.width {
            numBgCreated += 1
            
            let bg = SKSpriteNode(texture: backgroundTexture)
            bg.size = view.frame.size
            bg.position = CGPoint(x: i - 2, y: view.frame.height/2)
            bg.zPosition = ZLevel.Background
            
            backgroundLevelNode.addChild(bg)
            
            i = i + bg.size.width
        }
        
        print("Number of backgrounds created \(numBgCreated)")
        movingNodes.addChild(backgroundLevelNode)
    }
    
    func createGround(_ view: SKView) {
        var i: CGFloat = 0
        
        var numGroundCreated = 0
        
        while i < sceneLength + view.frame.width + groundTexture.size().width {
            numGroundCreated += 1
            
            let ground = SKSpriteNode(texture: groundTexture)
            ground.position = CGPoint(x: i, y: ground.frame.height/2)
            ground.zPosition = ZLevel.Ground
            
            // Set physics
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.restitution = 0.0
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
            
            foregroundLevelNode.addChild(ground)
            
            i = i + ground.size.width
        }
        print("Number of grounds created \(numGroundCreated)")
    }
    
    func createObsticles(_ view: SKView) {
        
        // Create lower rocks
        let rocksDictionary = levelData["Rocks"] as! NSDictionary
        let rocksArray = rocksDictionary["Positions"] as! [NSDictionary]
        
        for rock in rocksArray {
            
            let rockScale = rock["scale"] as! CGFloat
            
            let rockNode = SKSpriteNode(texture: rockTexture)
            rockNode.setScale(rockScale)
            
            let x = (rock["x"] as AnyObject).floatValue
            let y = (rock["y"] as AnyObject).floatValue
            let xPosition = CGFloat(x!) - rockNode.size.width/2
            let yPosition = CGFloat(y!) + rockNode.size.height/2
            
            rockNode.position = CGPoint(x: xPosition, y: yPosition)
            rockNode.zPosition = ZLevel.Rocks
            
            print("Rock postion x:\(xPosition) y:\(yPosition)")
            
            // Create path for physicsBody
            let rockPath = CGMutablePath()
            
            // Bottom left of rock
//            CGPathMoveToPoint(rockPath, nil, -rockNode.size.width/2, -rockNode.size.height/2)
            rockPath.move(to: CGPoint(x: -rockNode.size.width/2, y: -rockNode.size.height/2))
            
            
            
            // Top middle of rock
//            CGPathAddLineToPoint(rockPath, nil, 10, rockNode.size.height/2)
            rockPath.move(to: CGPoint(x: 10, y: rockNode.size.height/2))
            // Bottom right of rock
//            CGPathAddLineToPoint(rockPath, nil, rockNode.size.width/2, -rockNode.size.height/2)
            rockPath.addLine(to: CGPoint(x: rockNode.size.width/2, y: -rockNode.size.height/2))
            // Close path
            rockPath.closeSubpath()
            
            
            // Set physics
            rockNode.physicsBody = SKPhysicsBody(polygonFrom: rockPath)
            rockNode.physicsBody?.isDynamic = false
            rockNode.physicsBody?.restitution = 0.0
            rockNode.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            foregroundLevelNode.addChild(rockNode)
        }
        
        // Create upper rocks
        let rocksDownDictionary = levelData["RocksDown"] as! NSDictionary
        let rocksDownArray = rocksDownDictionary["Positions"] as! [NSDictionary]
        
        for rockDown in rocksDownArray {
            
            
            let rockDownScale = rockDown["scale"] as! CGFloat
            
            let rockDownNode = SKSpriteNode(texture: rockDownTexture)
            rockDownNode.setScale(rockDownScale)
            
            let x = (rockDown["x"] as AnyObject).floatValue
            let xPosition = CGFloat(x!) - rockDownNode.size.width/2
            let yPosition = view.frame.height - rockDownNode.size.height/2
            
            rockDownNode.position = CGPoint(x: xPosition, y: yPosition)
            rockDownNode.zPosition = ZLevel.Rocks
            
            print("RockDown postion x:\(xPosition) y:\(yPosition)")
            
            // Create path for physicsBody
            let rockDownPath = CGMutablePath()
            
            // Top left of rockDown
//            CGPathMoveToPoint(rockDownPath, nil, -rockDownNode.size.width/2, rockDownNode.size.height/2)
            rockDownPath.move(to: CGPoint(x: -rockDownNode.size.width/2, y: rockDownNode.size.height/2))
            
            
            // Bottom middle of rockDown
//            CGPathAddLineToPoint(rockDownPath, nil, 10, -rockDownNode.size.height/2)
            rockDownPath.move(to: CGPoint(x: 10, y: -rockDownNode.size.height/2))
            // Top right of rockDown
//            CGPathAddLineToPoint(rockDownPath, nil, rockDownNode.size.width/2, rockDownNode.size.height/2)
            rockDownPath.addLine(to: CGPoint(x: rockDownNode.size.width/2, y: rockDownNode.size.height/2))
            // Close path
            rockDownPath.closeSubpath()
            
            // Set physics
            rockDownNode.physicsBody = SKPhysicsBody(polygonFrom: rockDownPath)
            rockDownNode.physicsBody?.isDynamic = false
            rockDownNode.physicsBody?.restitution = 0.0
            rockDownNode.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            
            foregroundLevelNode.addChild(rockDownNode)
        }
        movingNodes.addChild(foregroundLevelNode)
    }
    
    func createStars(_ view: SKView) {
        let starDictionary = levelData["Stars"] as! NSDictionary
        let positionsArray = starDictionary["Positions"] as! [NSDictionary]
        
        for star in positionsArray {
            let starNode = SKSpriteNode(texture: starTexture)
            starNode.setScale(2.0)
            
            let x = (star["x"] as AnyObject).floatValue
            let y = (star["y"] as AnyObject).floatValue
            let xPositoin = CGFloat(x!)
            let yPosition = CGFloat(y!)
            
            print("Star postioion x:\(xPositoin) y:\(yPosition)")
            starNode.position = CGPoint(x: xPositoin, y: yPosition)
            
            // Set physics
            starNode.physicsBody = SKPhysicsBody(rectangleOf: starNode.size)
            starNode.physicsBody?.isDynamic = false
            starNode.physicsBody?.categoryBitMask = PhysicsCategory.Stars
            starNode.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
            
            foregroundLevelNode.addChild(starNode)
        }
    }
    
    func createClouds(_ view: SKView) {
        // TODO: Create clouds
    }
    
    func createDistanceMarkers(_ view: SKView) {
        var i: CGFloat = view.frame.width / 4 + planeTexture.size().width/2 + 10
        
        while i < sceneLength + view.frame.width {
            let distanceMarkerNode = SKNode()
            distanceMarkerNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: i, y: 0), to: CGPoint(x: i, y: view.frame.height))
            distanceMarkerNode.physicsBody?.isDynamic = false
            distanceMarkerNode.physicsBody?.categoryBitMask = PhysicsCategory.Distance
            distanceMarkerNode.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
            
            foregroundLevelNode.addChild(distanceMarkerNode)
            
            i = i + 10
        }
    }
    
    func createPlane(_ view: SKView) {
        plane = SKSpriteNode(texture: planeTexture)
        plane.position = CGPoint(x: view.frame.width/4, y: view.frame.height/2)
        plane.zPosition = ZLevel.Plane
        
        // Set physics
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.restitution = 0.0
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground | PhysicsCategory.Distance | PhysicsCategory.Stars
        
        plane.physicsBody?.pinned = true
        
        worldNode.addChild(plane)
    }
    
    func createTutorial(_ view: SKView) {
        let scaleUp = SKAction.resize(byWidth: 50, height: 50, duration: 0.5)
        let scaleDown = SKAction.resize(byWidth: -50, height: -50, duration: 0.5)
        let repeatScaling = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        
        
        let tapTick = SKSpriteNode(texture: tapTexture)
        tapTick.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        tapTick.zPosition = ZLevel.Tutorial
        
        tapTick.run(repeatScaling)
        
        tutorialNode.addChild(tapTick)
    }
    
    func createWinLoseDialog(_ didWin: Bool) {
        let uiSize = self.view!.frame.height - 50
        
        levelUI = SKSpriteNode(texture: uiBackground)
        levelUI.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2)
        levelUI.size = CGSize(width: uiSize + 50, height: uiSize)
        levelUI.zPosition = ZLevel.UiBackground
        
        levelDialog.addChild(levelUI)
        
        // Check is win or lose
        if didWin {
            // Show Won
            winLoseTextNode = LevelHelper.wonTextNode()
            winLoseTextNode.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2 + (levelUI.size.height * 0.25))
            winLoseTextNode.zPosition = ZLevel.Label
        } else {
            // Show Gameover
            winLoseTextNode = SKSpriteNode(texture: gameOverTexture)
            winLoseTextNode.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2 + (levelUI.size.height * 0.25))
            winLoseTextNode.zPosition = ZLevel.Label
        }
        
        levelDialog.addChild(winLoseTextNode)
        
        // TODO: Create buttons for retry, next level, men menu
        
        let buttonDistance = levelUI.size.width / 4
        
        replayBtn = SKSpriteNode(texture: replyBtnTexture)
        replayBtn.position = CGPoint(x: self.view!.frame.width / 2 - buttonDistance, y: self.view!.frame.height / 2 - (levelUI.size.height * 0.25))
        replayBtn.zPosition = ZLevel.Label
        
        nextBtn = SKSpriteNode(texture: nextLevelBtnTexture)
        nextBtn.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2 - (levelUI.size.height * 0.25))
        nextBtn.zPosition = ZLevel.Label
        
        if !didWin {
            nextBtn.isHidden = true
        }
        
        levelMenuBtn = SKSpriteNode(texture: LevelMenuTexture)
        levelMenuBtn.position = CGPoint(x: self.view!.frame.width / 2 + buttonDistance, y: self.view!.frame.height / 2 - (levelUI.size.height * 0.25))
        levelMenuBtn.zPosition = ZLevel.Label
        
        levelDialog.addChild(replayBtn)
        levelDialog.addChild(nextBtn)
        levelDialog.addChild(levelMenuBtn)
        
        starHolderNode = SKSpriteNode(texture: starEmptyTexture)
        starHolderNode.setScale(4)
        starHolderNode.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2)
        starHolderNode.zPosition = ZLevel.Label
        
        levelDialog.addChild(starHolderNode)
        
        
        // Add win dialog to world
        worldNode.addChild(levelDialog)
        
        if didWin {
            animateStars()
        }
    }
    
    func animateStars() {
        let delay = SKAction.wait(forDuration: 1)
        
        // Bronze Actions
        let changeToBronze = SKAction.setTexture(starBronzeTexture)
        let addBronzeEmitter = SKAction.run({
            self.starBronzeEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "BronzeParticle", ofType: "sks")!) as! SKEmitterNode
            self.starBronzeEmmiter.zPosition = ZLevel.UiAnnimation
            self.starHolderNode.addChild(self.starBronzeEmmiter)
        })
        let bronzeSequence = SKAction.sequence([delay, changeToBronze, addBronzeEmitter])
        
        // Silver Actions
        let changeToSilver = SKAction.setTexture(starSilverTexture)
        let addSilverEmitter = SKAction.run({
            self.starSilverEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "SilverParticle", ofType: "sks")!) as! SKEmitterNode
            self.starSilverEmmiter.zPosition = ZLevel.UiAnnimation
            self.starHolderNode.addChild(self.starSilverEmmiter)
        })
        let silverSequence = SKAction.sequence([delay, changeToSilver, addSilverEmitter])
        
        // Gold Actions
        let changeToGold = SKAction.setTexture(starGoldTexture)
        let addGoldEmitter = SKAction.run({
            self.starGoldEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "GoldParticle", ofType: "sks")!) as! SKEmitterNode
            self.starGoldEmmiter.zPosition = ZLevel.UiAnnimation
            self.starHolderNode.addChild(self.starGoldEmmiter)
        })
        let goldSequence = SKAction.sequence([delay, changeToGold, addGoldEmitter])
        
        
        switch levelManager.starsCollected {
        case 1:
            starHolderNode.run(bronzeSequence)
        case 2:
            starHolderNode.run(SKAction.sequence([bronzeSequence, silverSequence]))
        case 3:
            starHolderNode.run(SKAction.sequence([bronzeSequence, silverSequence, goldSequence]))
        default:
            print("Lost")
        }
    }
    
    func restartLevel() {
        // Reset scene
        audioPlayer.stop()
        let scene = LevelScene(size: size, level: level)
        self.view?.presentScene(scene)
    }
}

// MARK: Game Events
extension LevelScene {
    
    func play(){
        // Action to move background
        let moveBg = SKAction.moveBy(x: -sceneLength, y: 0, duration: TimeInterval(sceneLength/50))
        backgroundLevelNode.run(moveBg)
        
        // Action to move foreground
        let moveFg = SKAction.moveBy(x: -sceneLength, y: 0, duration: TimeInterval(sceneLength/150))
        foregroundLevelNode.run(moveFg)
        
        // Animate plans propeller
        let animation = SKAction.animate(with: [planeTexture, planeTexture1, planeTexture2], timePerFrame: 0.05)
        let makePropellerSpin = SKAction.repeatForever(animation)
        plane.run(makePropellerSpin)
        
        plane.physicsBody?.pinned = false
        
        tutorialNode.removeFromParent()
    }
    
    func pause() {
        gamePaused = true
        // pause physics
        self.isPaused = true
        if audioPlayer.isPlaying{
            audioPlayer.pause()
        }
    }
    
    func resume() {
        gamePaused = false
        // Unpause physics
        self.isPaused = false
        if !audioPlayer.isPlaying {
            audioPlayer.play()
        }
    }
    
    func updateDistance() {
        //        runAction(distanceIncreasFX)
        levelManager.distance += 1
        levelManager.totalDistance += 1
//        distanceFlown++
        hudDistanceLabel.text = "Distance: \(levelManager.distance) meters"
    }
    
    func collectStar(_ star: SKNode) {
        star.removeFromParent()
        hudStarNode.addChild(star)
        star.physicsBody = nil
        
        star.position = CGPoint(x: self.frame.size.width / 3, y: 100)
        
        
        self.run(starFX)
        
        let moveStar = SKAction.move(to: CGPoint(x: 10, y: view!.frame.height - 20), duration: 1.5)
        //        let shrinkStar = SKAction.scaleXTo(0.5, duration: 1.5)
        let shrinkStar = SKAction.resize(toWidth: star.frame.width / 2, height: star.frame.height / 2, duration: 1.5)
        let moveAndShring = SKAction.group([moveStar, shrinkStar])
        let removeStar = SKAction.removeFromParent()
        let moveAndRemoveStar = SKAction.sequence([moveAndShring, removeStar])
        
        star.run(moveAndRemoveStar)
        
        levelManager.starsCollected += 1
        hudStarLabel.text = "= \(levelManager.starsCollected)"
    }
    
    func won() {
        print("WON!!")
        levelWon = true
        movingNodes.speed = 0
        isTouching = false
        plane.physicsBody?.pinned = true
        plane.removeAllActions()
        
        
        createWinLoseDialog(true)
        levelManager.updateStars(level)
        levelManager.submitDistanceLeaderboard()

        
//        saveHighScore()
    }
    
    func lost() {
        // TODO: Setup lost condition
        gameOver = true
        movingNodes.speed = 0
        
        isTouching = false
        
        // Stop propeller spinning
        plane.removeAllActions()
        
        createWinLoseDialog(false)
    }
}

// MARK: Input methods
extension LevelScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            gameStarted = true
            play()
        }
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if hudPauseButn.contains(location) {
                self.run(clickFX)
                print("Pause/Play")
                if self.isPaused {
                    resume()
                } else {
                    pause()
                }
            }
            
            if levelWon || gameOver {
                
                if replayBtn.contains(location) {
                    restartLevel()
                }
                if nextBtn.contains(location) {
                    print("Next Level")
                }
                
                if levelMenuBtn.contains(location) {
                    print("Level Menu")
                    // Reset scene
                    audioPlayer.stop()
                    let menuScene = LevelMenuScene(size: size)
                    self.view?.presentScene(menuScene)
                }
            }
            
//            if gameOver {
//                restartLevel()
//            }
            
            if !gamePaused && !levelWon && !gameOver {
                // Used for contiuous flying while touching screen.
                isTouching = true
                
                let addSmoke = SKAction.run({
                    let planeEngineSmoke = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "SmokeParticle", ofType: "sks")!) as! SKEmitterNode
                    planeEngineSmoke.position = CGPoint(x: -20, y: 0)
                    planeEngineSmoke.zPosition = ZLevel.PlaneSmoke
                    self.plane.addChild(planeEngineSmoke)
                })
                plane.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                plane.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 8))
                plane.run(SKAction.group([planeFlyingFX, addSmoke]))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        //        if isTouching {
        //            plane.physicsBody?.applyForce(CGVectorMake(0, 50))
        //        }
        
        if levelManager.distance >= Int(sceneLength) / 10 {
            if !levelWon {
                won()
            }
        }
    }
}

// MARK: SKPhysicsContactDelegate
extension LevelScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var notPlane = SKPhysicsBody()
        var notPlaneNode = SKNode()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            notPlane = contact.bodyB
            notPlaneNode = contact.bodyB.node!
        } else {
            notPlane = contact.bodyA
            notPlaneNode = contact.bodyA.node!
        }
        
        switch notPlane.categoryBitMask {
        case PhysicsCategory.Distance:
            print("Distance increased")
            updateDistance()
        case PhysicsCategory.Stars:
            print("Collected a star")
            collectStar(notPlaneNode)
        default:
            print("Plane crashed")
            
            run(planeCrashFX)
            plane.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            plane.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -50))
            
            
            if gameOver == false {
                lost()
            }
        }
    }
}









