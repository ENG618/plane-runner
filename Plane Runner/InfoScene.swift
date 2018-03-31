//
//  CreditsScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/26/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class InfoScene: SKScene {
    
    // Nodes
    let worldNode = SKNode()
    let backBtnNode = SKNode()
    let dialogNode = SKNode()
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let backBtnTexture = SKTexture(imageNamed: BackIconImage)
    let dialogBackgroundTexture = SKTexture(imageNamed: UIBackgroundImage)
    
    var clickFX: SKAction!
    
    override func didMove(to view: SKView) {
        self.addChild(worldNode)
        worldNode.addChild(backBtnNode)
        worldNode.addChild(dialogNode)
        
        self.physicsWorld.contactDelegate = self
        
        // Click sound effect
        clickFX = SKAction.repeat(SKAction.playSoundFileNamed(ClickFX, waitForCompletion: true), count: 1)
        
        createBackground(view)
        createBackButton(view)
        createDialog(view)
    }
}

// MARK: Setup Helpers
extension InfoScene {
    func createBackground(_ view: SKView) {
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        bg.zPosition = ZLevel.Background
        bg.size = size
        worldNode.addChild(bg)
    }
    
    func createBackButton(_ view: SKView) {
        let backBtn = SKSpriteNode(texture: backBtnTexture)
        backBtn.position = CGPoint(x: 10 + backBtnTexture.size().width / 2, y: -10 - backBtnTexture.size().height / 2 + view.frame.height)
        
        backBtnNode.addChild(backBtn)
    }
    
    func createDialog(_ view: SKView) {
        let dialogBackground = SKSpriteNode(texture: dialogBackgroundTexture)
        dialogBackground.size = CGSize(width: view.frame.width - 150, height: view.frame.height - 40)
        dialogBackground.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        var lineHeight = view.frame.height - 80
        print("Line height: \(lineHeight)")
        
        let developerText = SKLabelNode(fontNamed: GameFont)
        developerText.fontColor = SKColor.black
        developerText.text = "Developer: Eric Garcia"
        developerText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - developerText.frame.size.height - 25
        print("Line height: \(lineHeight)")
        
        let creditsText = SKLabelNode(fontNamed: GameFont)
        creditsText.fontColor = SKColor.black
        creditsText.text = "Credits"
        creditsText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - creditsText.frame.size.height - 10
        print("Line height: \(lineHeight)")
        
        let artCreditText = SKLabelNode(fontNamed: GameFont)
        artCreditText.fontColor = SKColor.black
        artCreditText.fontSize = 18
        artCreditText.text = "Image assets: Kenny.nl"
        artCreditText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - artCreditText.frame.size.height - 10
        print("Line height: \(lineHeight)")
        
        let bgAudioCreditText = SKLabelNode(fontNamed: GameFont)
        bgAudioCreditText.fontColor = SKColor.black
        bgAudioCreditText.fontSize = 18
        bgAudioCreditText.text = "Background audio: David Brenner on Melody Loops"
        bgAudioCreditText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - bgAudioCreditText.frame.size.height - 10
        print("Line height: \(lineHeight)")
        
        let planeCrashAudioCreditText = SKLabelNode(fontNamed: GameFont)
        planeCrashAudioCreditText.fontColor = SKColor.black
        planeCrashAudioCreditText.fontSize = 18
        planeCrashAudioCreditText.text = "Plane Crashing: http://www.freefx.co.uk"
        planeCrashAudioCreditText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - planeCrashAudioCreditText.frame.size.height - 10
        print("Line height: \(lineHeight)")
        
        let planeFlyingAudioCreditText = SKLabelNode(fontNamed: GameFont)
        planeFlyingAudioCreditText.fontColor = SKColor.black
        planeFlyingAudioCreditText.fontSize = 18
        planeFlyingAudioCreditText.text = "Plane Flying: SoundBible.com"
        planeFlyingAudioCreditText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - planeFlyingAudioCreditText.frame.size.height - 10
        print("Line height: \(lineHeight)")
        
        let starAudioCreditText = SKLabelNode(fontNamed: GameFont)
        starAudioCreditText.fontColor = SKColor.black
        starAudioCreditText.fontSize = 18
        starAudioCreditText.text = "Star: http://www.freefx.co.uk"
        starAudioCreditText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        lineHeight = lineHeight - starAudioCreditText.frame.size.height - 10
        print("Line height: \(lineHeight)")
        
        let clickAudioCreditText = SKLabelNode(fontNamed: GameFont)
        clickAudioCreditText.fontColor = SKColor.black
        clickAudioCreditText.fontSize = 18
        clickAudioCreditText.text = "Click: Kenney.nl"
        clickAudioCreditText.position = CGPoint(x: view.frame.width / 2, y: lineHeight)
        
        
        dialogNode.addChild(dialogBackground)
        dialogNode.addChild(developerText)
        dialogNode.addChild(creditsText)
        dialogNode.addChild(artCreditText)
        dialogNode.addChild(bgAudioCreditText)
        dialogNode.addChild(planeCrashAudioCreditText)
        dialogNode.addChild(planeFlyingAudioCreditText)
        dialogNode.addChild(starAudioCreditText)
        dialogNode.addChild(clickAudioCreditText)
    }
}

// MARK: Input Methods
extension InfoScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if backBtnNode.contains(location) {
                print("Start button touched")
                self.run(clickFX)
                
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 0.7))
            }
        }
    }
}

// MARK: SKPhysicsDelegate
extension InfoScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("Button pressed")
    }
}
