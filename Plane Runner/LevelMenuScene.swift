//
//  LevelMenuScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class LevelMenuScene: SKScene {
    
    let worldNode = SKNode()
    let backBtnNode = SKNode()
    let levelsNode = SKNode()
    let dialogNode = SKNode()
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let backBtnTexture = SKTexture(imageNamed: BackIconImage)
    let levelBackgroundTexture = SKTexture(imageNamed: UIBackgroundImage)
    let starEmpty = SKTexture(imageNamed: StarEmpty)
    
    // Level Nodes
    // Naming: Stage1Level1 = s01l01
    var s01l01: SKSpriteNode!
    var s01l02: SKSpriteNode!
    var s01l03: SKSpriteNode!
    var s02l01: SKSpriteNode!
    var s02l02: SKSpriteNode!
    var s02l03: SKSpriteNode!
    
    
    var clickFX: SKAction!
    
    var onStageOne: Bool = true
    
    override func didMoveToView(view: SKView) {
        self.addChild(worldNode)
        worldNode.addChild(backBtnNode)
        worldNode.addChild(levelsNode)
        worldNode.addChild(dialogNode)
        
        self.physicsWorld.contactDelegate = self
        
        // Click sound effect
        clickFX = SKAction.repeatAction(SKAction.playSoundFileNamed(ClickFX, waitForCompletion: true), count: 1)
        
        setupGestureRecognizers()
        
        createBackground(view)
        createBackButton(view)
        createLevels(view)
    }
}

// MARK: Scene Helpers
extension LevelMenuScene {
    
    func setupGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view?.addGestureRecognizer(swipeLeft)
    }
    
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
        
        backBtnNode.addChild(backBtn)
    }
    
    func createLabels(view: SKView) {
        // TODO: Setup "Stage One" and "Stage Two" lables, and pagination.
    }
    
    func createLevels(view: SKView) {
        let levelWidthSeperation = view.frame.width / 3
        let levelHeightSeperation = view.frame.height / 3
        
        stageOne(view, levelWidthSeperation: levelWidthSeperation, levelHeightSeperation: levelHeightSeperation)
        stageTwo(view, levelWidthSeperation: levelWidthSeperation, levelHeightSeperation: levelHeightSeperation)
    }
    
    func stageOne(view: SKView, levelWidthSeperation: CGFloat, levelHeightSeperation: CGFloat) {
        //
        // Stage One Levels
        //
        
        // Level One
        s01l01 = SKSpriteNode(texture: levelBackgroundTexture)
        s01l01.position = CGPoint(x: view.frame.width / 2 - levelWidthSeperation, y: levelHeightSeperation * 2)
        s01l01.zPosition = ZLevel.UiBackground
        
        let s01l01Icon = SKSpriteNode(texture: LevelHelper.getLetterTexture("1"))
        s01l01Icon.position = CGPoint(x: 0, y: 25)
        s01l01Icon.zPosition = ZLevel.Label
        
        let s01l01Star = SKSpriteNode(texture: starEmpty)
        s01l01Star.position = CGPoint(x: 0, y: -25)
        
        s01l01.addChild(s01l01Icon)
        s01l01.addChild(s01l01Star)
        
        levelsNode.addChild(s01l01)
        
        // Level Two
        s01l02 = SKSpriteNode(texture: levelBackgroundTexture)
        s01l02.position = CGPoint(x: view.frame.width / 2, y: levelHeightSeperation * 2)
        s01l02.zPosition = ZLevel.UiBackground
        
        let s01l02Icon = SKSpriteNode(texture: LevelHelper.getLetterTexture("2"))
        s01l02Icon.position = CGPoint(x: 0, y: 25)
        s01l02Icon.zPosition = ZLevel.Label
        
        let s01l02Star = SKSpriteNode(texture: starEmpty)
        s01l02Star.position = CGPoint(x: 0, y: -25)
        
        s01l02.addChild(s01l02Icon)
        s01l02.addChild(s01l02Star)
        
        levelsNode.addChild(s01l02)
        
        // Level Three
        s01l03 = SKSpriteNode(texture: levelBackgroundTexture)
        s01l03.position = CGPoint(x: view.frame.width / 2 + levelWidthSeperation, y: levelHeightSeperation * 2)
        s01l03.zPosition = ZLevel.UiBackground
        
        let s01l03Icon = SKSpriteNode(texture: LevelHelper.getLetterTexture("3"))
        s01l03Icon.position = CGPoint(x: 0, y: 25)
        s01l03Icon.zPosition = ZLevel.Label
        
        let s01l03Star = SKSpriteNode(texture: starEmpty)
        s01l03Star.position = CGPoint(x: 0, y: -25)
        
        s01l03.addChild(s01l03Icon)
        s01l03.addChild(s01l03Star)
        
        levelsNode.addChild(s01l03)
    }
    
    func stageTwo(view: SKView, levelWidthSeperation: CGFloat, levelHeightSeperation: CGFloat) {
        //
        // Stage Two Levels
        //
        
        let stageTwoXOrigin = view.frame.width
        
        // Stage 2 Level 1
        s02l01 = SKSpriteNode(texture: levelBackgroundTexture)
        s02l01.position = CGPoint(x: stageTwoXOrigin + view.frame.width / 2 - levelWidthSeperation, y: levelHeightSeperation * 2)
        s02l01.zPosition = ZLevel.UiBackground
        
        let s02l01Icon = SKSpriteNode(texture: LevelHelper.getLetterTexture("1"))
        s02l01Icon.position = CGPoint(x: 0, y: 25)
        s02l01Icon.zPosition = ZLevel.Label
        
        let s02l01Star = SKSpriteNode(texture: starEmpty)
        s02l01Star.position = CGPoint(x: 0, y: -25)
        
        s02l01.addChild(s02l01Icon)
        s02l01.addChild(s02l01Star)
        
        levelsNode.addChild(s02l01)
        
        // Stage 2 Level 2
        s02l02 = SKSpriteNode(texture: levelBackgroundTexture)
        s02l02.position = CGPoint(x: stageTwoXOrigin + view.frame.width / 2, y: levelHeightSeperation * 2)
        s02l02.zPosition = ZLevel.UiBackground
        
        let s02l02Icon = SKSpriteNode(texture: LevelHelper.getLetterTexture("2"))
        s02l02Icon.position = CGPoint(x: 0, y: 25)
        s02l02Icon.zPosition = ZLevel.Label
        
        let s02l02Star = SKSpriteNode(texture: starEmpty)
        s02l02Star.position = CGPoint(x: 0, y: -25)
        
        s02l02.addChild(s02l02Icon)
        s02l02.addChild(s02l02Star)
        
        levelsNode.addChild(s02l02)
        
        // Stage 2 Level 3
        s02l03 = SKSpriteNode(texture: levelBackgroundTexture)
        s02l03.position = CGPoint(x: stageTwoXOrigin + view.frame.width / 2 + levelWidthSeperation, y: levelHeightSeperation * 2)
        s02l03.zPosition = ZLevel.UiBackground
        
        let s02l03Icon = SKSpriteNode(texture: LevelHelper.getLetterTexture("3"))
        s02l03Icon.position = CGPoint(x: 0, y: 25)
        s02l03Icon.zPosition = ZLevel.Label
        
        let s02l03Star = SKSpriteNode(texture: starEmpty)
        s02l03Star.position = CGPoint(x: 0, y: -25)
        
        s02l03.addChild(s02l03Icon)
        s02l03.addChild(s02l03Star)
        
        levelsNode.addChild(s02l03)
    }
}

// Mark: Input Methods
extension LevelMenuScene {
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if backBtnNode.containsPoint(location) {
                println("Back button pressed")
                self.runAction(clickFX)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: SKTransition.doorsCloseHorizontalWithDuration(1))
            }
            
            if s01l01.containsPoint(location) {
                self.runAction(clickFX)
                let levelOneScene = LevelScene(size: size, level: LevelNames.LevelOne)
                self.view?.presentScene(levelOneScene)
            }
            
            if s01l02.containsPoint(location){
                self.runAction(clickFX)
                let levelTwoScene = LevelScene(size: size, level: LevelNames.LevelTwo)
                self.view?.presentScene(levelTwoScene)
            }
        }
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        println("Swiped Right")
        if !onStageOne {
            let moveToOne = SKAction.moveByX( self.frame.size.width, y: 0, duration: 0.5)
            levelsNode.runAction(moveToOne)
            onStageOne = true
        }
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        println("Swiped left")
        if onStageOne {
            let moveToTwo = SKAction.moveByX( -self.frame.size.width, y: 0, duration: 0.5)
            levelsNode.runAction(moveToTwo)
            onStageOne = false
        }
    }
}

// : SKPhysicsContactDelegate
extension LevelMenuScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        println("Button Pressed")
    }
}