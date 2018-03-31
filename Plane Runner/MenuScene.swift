//
//  MenuScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/9/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class MenuScene: SKScene {
    
    var player: Player!
    let levelManager = LevelManager.sharedInstance
    
    // Nodes
    let worldNode = SKNode()
    let titleNode = SKNode()
    let startNode = SKNode()
    let infoNode = SKNode()
    let leaderNode = SKNode()
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let infoTexture = SKTexture(imageNamed: InfoIconImage)
    let leaderBoad = SKTexture(imageNamed: LeaderBoard)
    
    
    var clickFX: SKAction!
    
    override func didMove(to view: SKView) {
        
        print("Size height: \(size.height) Width: \(size.width)")
        print("View Height: \(view.bounds.height) Width: \(view.bounds.width)")
        print("Frame: \(self.frame), View.frame.width: \(view.frame.width) View.frame.height: \(view.frame.height)")
        
        self.addChild(worldNode)
        
        self.physicsWorld.contactDelegate = self
        
        // Click sound effect
        clickFX = SKAction.repeat(SKAction.playSoundFileNamed(ClickFX, waitForCompletion: true), count: 1)
        
        createBackground(view)
        createTitle(view)
        createStartButton(view)
        createInfoButton(view)
        createLeaderBoardButton(view)
        
        levelManager.load()
    }
}

// MARK: Setup Helpers
extension MenuScene {
    func createBackground(_ view: SKView) {
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        bg.zPosition = ZLevel.Background
        bg.size = size
        worldNode.addChild(bg)
    }
    
    func createTitle(_ view: SKView) {
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
    
    func createStartButton(_ view: SKView) {
        let startBtn = SKSpriteNode(texture: buttonTexture)
        startBtn.setScale(2.0)
        startBtn.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - view.frame.height/3 + 7)
        startBtn.zPosition = 0
        startNode.addChild(startBtn)
        
        let startText = SKLabelNode(fontNamed: GameFont)
        startText.text = "Start"
        startText.color = SKColor.white
        startText.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - view.frame.height/3)
        startText.zPosition = 1
        startNode.addChild(startText)
        
        //        startNode.physicsBody = SKPhysicsBody(rectangleOfSize: buttonTexture.size())
        //        startNode.physicsBody?.categoryBitMask = PhysicsCategory.ButtonEnabled
        
        worldNode.addChild(startNode)
    }
    
    func createInfoButton(_ view: SKView) {
        let infoBtn = SKSpriteNode(texture: infoTexture)
        infoBtn.position = CGPoint(x: view.frame.width - infoBtn.size.width * 2, y: view.frame.height/2 - view.frame.height/3)
        
        infoNode.addChild(infoBtn)
        
        worldNode.addChild(infoNode)
    }
    
    func createLeaderBoardButton(_ view: SKView) {
        let leaderBtn = SKSpriteNode(texture: leaderBoad)
        leaderBtn.position = CGPoint(x: leaderBtn.size.width * 2, y: view.frame.height/2 - view.frame.height/3)
        
        leaderNode.addChild(leaderBtn)
        worldNode.addChild(leaderNode)
    }
}

// MARK: Game Center Helpers
extension MenuScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
//        self.presentViewController(vc, andimated: true, completion: nil)
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.present(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: Input Methods
extension MenuScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if startNode.contains(location) {
                print("Start button touched")
                self.run(clickFX)
                let levelMenuScene = LevelMenuScene(size: size)
                self.view?.presentScene(levelMenuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
            } else if infoNode.contains(location) {
                self.run(clickFX)
                let infoScene = InfoScene(size: size)
                self.view?.presentScene(infoScene, transition: SKTransition.flipVertical(withDuration: 0.7))
            } else if leaderNode.contains(location) {
                // TODO: Launch Game Center
                print("Leaderboard touched")
                showLeaderboard()
            }
        }
    }
}

// MARK: SKPhysicsDelegate
extension MenuScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("button pressed")
    }
}
