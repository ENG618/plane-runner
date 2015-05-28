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
    let dialogNode = SKNode()
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let backBtnTexture = SKTexture(imageNamed: BackIconImage)
    let levelBackgroundTexture = SKTexture(imageNamed: UIBackgroundImage)
    let starEmpty = SKTexture(imageNamed: StarEmpty)
    
    // Level Nodes
    private var levelOne: SKSpriteNode!
    private var levelTwo: SKSpriteNode!
    
    var clickFX: SKAction!
    
    override func didMoveToView(view: SKView) {
        self.addChild(worldNode)
        worldNode.addChild(backBtnNode)
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
    
    func createLevels(view: SKView) {
        let levelSeperation = self.view!.frame.width / 3
        
        // Level One
        levelOne = SKSpriteNode(texture: levelBackgroundTexture)
        levelOne.position = CGPoint(x: view.frame.width / 2 - levelSeperation, y: view.frame.height / 2)
        levelOne.zPosition = ZLevel.UiBackground
        
        let levelOneIcon = SKSpriteNode(texture: LevelHelper.getLetterTexture("1"))
        levelOneIcon.position = CGPoint(x: 0, y: 25)
        levelOneIcon.zPosition = ZLevel.Label
        
        let levelOneStar = SKSpriteNode(texture: starEmpty)
        levelOneStar.position = CGPoint(x: 0, y: -25)
        
        levelOne.addChild(levelOneIcon)
        levelOne.addChild(levelOneStar)
        
        worldNode.addChild(levelOne)
        
        // Level Two
        levelTwo = SKSpriteNode(texture: levelBackgroundTexture)
        levelTwo.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        levelTwo.zPosition = ZLevel.UiBackground
        
        let levelTwoIcon = SKSpriteNode(texture: LevelHelper.getLetterTexture("2"))
        levelTwoIcon.position = CGPoint(x: 0, y: 25)
        levelTwoIcon.zPosition = ZLevel.Label
        
        let levelTwoStar = SKSpriteNode(texture: starEmpty)
        levelTwoStar.position = CGPoint(x: 0, y: -25)
        
        levelTwo.addChild(levelTwoIcon)
        levelTwo.addChild(levelTwoStar)
         
        worldNode.addChild(levelTwo)
        
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
            
            if levelOne.containsPoint(location) {
                self.runAction(clickFX)
                let levelOneScene = LevelScene(size: size, level: LevelNames.LevelOne)
                self.view?.presentScene(levelOneScene)
            }
            
            if levelTwo.containsPoint(location){
                self.runAction(clickFX)
                let levelTwoScene = LevelScene(size: size, level: LevelNames.LevelTwo)
                self.view?.presentScene(levelTwoScene)
            }
        }
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        println("Swiped Right")
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        println("Swiped left")
    }
}

// : SKPhysicsContactDelegate
extension LevelMenuScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        println("Button Pressed")
    }
}