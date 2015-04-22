//
//  GameScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    let bgTexture = SKTexture(imageNamed: "mainBackground")
    let titleNode = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        createBackground()
        createTitle()
        
        
//        var label = SKLabelNode(text: "Hello World")
//        label.position = CGPoint(x: size.width/2, y: size.height/2)
//        self.addChild(label)
    }
    
    // MARK: Setup Helpers
    func createBackground() {
        var bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = ZLevel.Background
        bg.size = size
        self.addChild(bg)
    }
    
    func createTitle() {
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
        titleNode.position = CGPoint(x: size.width/2, y: size.height - size.height/3)
        self.addChild(titleNode)
    }
    
    func getLetterTexture(letter: String) -> SKTexture {
        let letterTextuer = SKTexture(imageNamed: letter)
        return letterTextuer
    }
}
