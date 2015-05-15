//
//  MenuScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    // Nodes
    let worldNode = SKNode()
    let titleNode = SKNode()
    let startNode = SKNode()
    let infoNode = SKNode()
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let infoTexture = SKTexture(imageNamed: InfoIconImage)
    
    var clickFX: SKAction!
    
    override func didMoveToView(view: SKView) {
        
        println("Size height: \(size.height) Width: \(size.width)")
        println("View Height: \(view.bounds.height) Width: \(view.bounds.width)")
        println("Frame: \(self.frame), View.frame.width: \(view.frame.width) View.frame.height: \(view.frame.height)")
        
        self.addChild(worldNode)
        
        self.physicsWorld.contactDelegate = self
        
        // Click sound effect
        clickFX = SKAction.repeatAction(SKAction.playSoundFileNamed(ClickFX, waitForCompletion: true), count: 1)
        
        createBackground(view)
        createTitle(view)
        createStartButton(view)
        createInfoButton(view)
    }
}

// MARK: Setup Helpers
extension MenuScene {
    func createBackground(view: SKView) {
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        bg.zPosition = ZLevel.Background
        bg.size = size
        worldNode.addChild(bg)
    }
    
    func createTitle(view: SKView) {
        // Plane
        let p = SKSpriteNode(texture: LevelHelper.getLetterTexture("p"))
        p.position = CGPoint(x: -156, y: 0)
        titleNode.addChild(p)
        
        let l = SKSpriteNode(texture: LevelHelper.getLetterTexture("l"))
        l.position = CGPoint(x: -130, y: 0)
        titleNode.addChild(l)
        
        let a = SKSpriteNode(texture: LevelHelper.getLetterTexture("a"))
        a.position = CGPoint(x: -104, y: 0)
        titleNode.addChild(a)
        
        let n = SKSpriteNode(texture: LevelHelper.getLetterTexture("n"))
        n.position = CGPoint(x: -78, y: 0)
        titleNode.addChild(n)
        
        let e = SKSpriteNode(texture: LevelHelper.getLetterTexture("e"))
        e.position = CGPoint(x: -52, y: 0)
        titleNode.addChild(e)
        
        // Runner
        let r = SKSpriteNode(texture: LevelHelper.getLetterTexture("r"))
        r.position = CGPoint(x: 0, y: 0)
        titleNode.addChild(r)
        
        let u = SKSpriteNode(texture: LevelHelper.getLetterTexture("u"))
        u.position = CGPoint(x: 26, y: 0)
        titleNode.addChild(u)
        
        let n2 = SKSpriteNode(texture: LevelHelper.getLetterTexture("n"))
        n2.position = CGPoint(x: 52, y: 0)
        titleNode.addChild(n2)
        
        let n3 = SKSpriteNode(texture: LevelHelper.getLetterTexture("n"))
        n3.position = CGPoint(x: 78, y: 0)
        titleNode.addChild(n3)
        
        let e2 = SKSpriteNode(texture: LevelHelper.getLetterTexture("e"))
        e2.position = CGPoint(x: 104, y: 0)
        titleNode.addChild(e2)
        
        let r2 = SKSpriteNode(texture: LevelHelper.getLetterTexture("r"))
        r2.position = CGPoint(x: 130, y: 0)
        titleNode.addChild(r2)
        
        // Whole node
        titleNode.position = CGPoint(x: view.frame.width/2, y: view.frame.height - view.frame.height/3)
        worldNode.addChild(titleNode)
    }
    
    func createStartButton(view: SKView) {
        let startBtn = SKSpriteNode(texture: buttonTexture)
        startBtn.setScale(2.0)
        startBtn.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - view.frame.height/3 + 7)
        startBtn.zPosition = 0
        startNode.addChild(startBtn)
        
        let startText = SKLabelNode(fontNamed: GameFont)
        startText.text = "Start"
        startText.color = SKColor.whiteColor()
        startText.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - view.frame.height/3)
        startText.zPosition = 1
        startNode.addChild(startText)
        
        //        startNode.physicsBody = SKPhysicsBody(rectangleOfSize: buttonTexture.size())
        //        startNode.physicsBody?.categoryBitMask = PhysicsCategory.ButtonEnabled
        
        worldNode.addChild(startNode)
    }
    
    func createInfoButton(view: SKView) {
        let infoBtn = SKSpriteNode(texture: infoTexture)
        infoBtn.position = CGPoint(x: view.frame.width - infoBtn.size.width * 2, y: view.frame.height/2 - view.frame.height/3)
        
        infoNode.addChild(infoBtn)
        
        worldNode.addChild(infoNode)
    }
}

// MARK: Input Methods
extension MenuScene {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if startNode.containsPoint(location) {
                println("Start button touched")
                self.runAction(clickFX)
                let levelMenuScene = LevelMenuScene(size: size)
                self.view?.presentScene(levelMenuScene, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
            } else if infoNode.containsPoint(location) {
                self.runAction(clickFX)
                let infoScene = InfoScene(size: size)
                self.view?.presentScene(infoScene, transition: SKTransition.flipVerticalWithDuration(0.7))
            }
        }
    }
}

// MARK: SKPhysicsDelegate
extension MenuScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        println("button pressed")
    }
}
