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
    
    override func didMoveToView(view: SKView) {
        
        println("Size height: \(size.height) Width: \(size.width)")
        println("View Height: \(view.bounds.height) Width: \(view.bounds.width)")
        println("Frame: \(self.frame), View.frame.width: \(view.frame.width) View.frame.height: \(view.frame.height)")
        
        self.addChild(worldNode)
        
        self.physicsWorld.contactDelegate = self
        
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
        let p = SKSpriteNode(texture: getLetterTexture("p"))
        p.position = CGPoint(x: -156, y: 0)
        titleNode.addChild(p)
        
        let l = SKSpriteNode(texture: getLetterTexture("l"))
        l.position = CGPoint(x: -130, y: 0)
        titleNode.addChild(l)
        
        let a = SKSpriteNode(texture: getLetterTexture("a"))
        a.position = CGPoint(x: -104, y: 0)
        titleNode.addChild(a)
        
        let n = SKSpriteNode(texture: getLetterTexture("n"))
        n.position = CGPoint(x: -78, y: 0)
        titleNode.addChild(n)
        
        let e = SKSpriteNode(texture: getLetterTexture("e"))
        e.position = CGPoint(x: -52, y: 0)
        titleNode.addChild(e)
        
        // Runner
        let r = SKSpriteNode(texture: getLetterTexture("r"))
        r.position = CGPoint(x: 0, y: 0)
        titleNode.addChild(r)
        
        let u = SKSpriteNode(texture: getLetterTexture("u"))
        u.position = CGPoint(x: 26, y: 0)
        titleNode.addChild(u)
        
        let n2 = SKSpriteNode(texture: getLetterTexture("n"))
        n2.position = CGPoint(x: 52, y: 0)
        titleNode.addChild(n2)
        
        let n3 = SKSpriteNode(texture: getLetterTexture("n"))
        n3.position = CGPoint(x: 78, y: 0)
        titleNode.addChild(n3)
        
        let e2 = SKSpriteNode(texture: getLetterTexture("e"))
        e2.position = CGPoint(x: 104, y: 0)
        titleNode.addChild(e2)
        
        let r2 = SKSpriteNode(texture: getLetterTexture("r"))
        r2.position = CGPoint(x: 130, y: 0)
        titleNode.addChild(r2)
        
        // Whole node
        titleNode.position = CGPoint(x: view.frame.width/2, y: view.frame.height - view.frame.height/3)
        worldNode.addChild(titleNode)
    }
    
    func getLetterTexture(letter: String) -> SKTexture {
        let letterTextuer = SKTexture(imageNamed: letter)
        return letterTextuer
    }
    
    func createStartButton(view: SKView) {
        let startBtn = SKSpriteNode(texture: buttonTexture)
        startBtn.setScale(2.0)
        startBtn.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - view.frame.height/3 + 7)
        startBtn.zPosition = 0
        startNode.addChild(startBtn)
        
        let startText = SKLabelNode(fontNamed: "kenvector_future_thin")
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
                
//                let scene = LevelOneScene(size: size)
                let scene = LevelScene(size: size)
                self.view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
            } else if infoNode.containsPoint(location) {
                let infoScene = CreditsScene(size: size)
                self.view?.presentScene(infoScene)
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
