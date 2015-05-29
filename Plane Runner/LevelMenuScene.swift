//
//  LevelMenuScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

enum Level {
    case One
    case Two
    case Three
}

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
    var sOneLOne: SKSpriteNode!
    var sOnelTwo: SKSpriteNode!
    var sOnel0Three: SKSpriteNode!
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
        sOneLOne = SKSpriteNode(texture: levelBackgroundTexture)
        sOneLOne.position = CGPoint(x: view.frame.width / 2 - levelWidthSeperation, y: levelHeightSeperation * 2)
        sOneLOne.zPosition = ZLevel.UiBackground
        
        let sOneLOneIcon = SKSpriteNode(texture: LevelHelper.getLetterTexture("1"))
        sOneLOneIcon.position = CGPoint(x: 0, y: 25)
        sOneLOneIcon.zPosition = ZLevel.Label
        
        let sOneLOneStar = SKSpriteNode(texture: starEmpty)
        sOneLOneStar.position = CGPoint(x: 0, y: -25)
        
        sOneLOne.addChild(sOneLOneIcon)
        sOneLOne.addChild(sOneLOneStar)
        
        levelsNode.addChild(sOneLOne)
        
        // Level Two
        sOnelTwo = SKSpriteNode(texture: levelBackgroundTexture)
        sOnelTwo.position = CGPoint(x: view.frame.width / 2, y: levelHeightSeperation * 2)
        sOnelTwo.zPosition = ZLevel.UiBackground
        
        let sOnelTwoIcon = SKSpriteNode(texture: LevelHelper.getLetterTexture("2"))
        sOnelTwoIcon.position = CGPoint(x: 0, y: 25)
        sOnelTwoIcon.zPosition = ZLevel.Label
        
        let sOnelTwoStar = SKSpriteNode(texture: starEmpty)
        sOnelTwoStar.position = CGPoint(x: 0, y: -25)
        
        sOnelTwo.addChild(sOnelTwoIcon)
        sOnelTwo.addChild(sOnelTwoStar)
        
        levelsNode.addChild(sOnelTwo)
        
        // Level Three
        sOnel0Three = SKSpriteNode(texture: levelBackgroundTexture)
        sOnel0Three.position = CGPoint(x: view.frame.width / 2 + levelWidthSeperation, y: levelHeightSeperation * 2)
        sOnel0Three.zPosition = ZLevel.UiBackground
        
        let sOnel0ThreeIcon = SKSpriteNode(texture: LevelHelper.getLetterTexture("3"))
        sOnel0ThreeIcon.position = CGPoint(x: 0, y: 25)
        sOnel0ThreeIcon.zPosition = ZLevel.Label
        
        let sOnel0ThreeStar = SKSpriteNode(texture: starEmpty)
        sOnel0ThreeStar.position = CGPoint(x: 0, y: -25)
        
        sOnel0Three.addChild(sOnel0ThreeIcon)
        sOnel0Three.addChild(sOnel0ThreeStar)
        
        levelsNode.addChild(sOnel0Three)
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
            
            if sOneLOne.containsPoint(location) {
                println("Level One")
                showLevel(Level.One)
            }
            
            if sOnelTwo.containsPoint(location){
                println("Level Two")
                showLevel(Level.Two)
            }
            
            if sOnel0Three.containsPoint(location) {
//                println("Stage: 1 Level: 3")
                println("Level Three")
                showLevel(Level.Three)
            }
        }
    }
    
    func showLevel(level: Level) {
        switch level {
        case .One:
            if onStageOne{
                println("Stage One")
                self.runAction(clickFX)
                let levelOneScene = LevelScene(size: size, level: LevelNames.LevelOne)
                self.view?.presentScene(levelOneScene)
            } else {
                println("Stage Two")
            }
        case .Two:
            if onStageOne{
                self.runAction(clickFX)
                let levelTwoScene = LevelScene(size: size, level: LevelNames.LevelTwo)
                self.view?.presentScene(levelTwoScene)

            } else {
                println("Stage Two")
            }
        case .Three:
            if onStageOne{
                println("Stage One")
            } else {
                println("Stage Two")
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