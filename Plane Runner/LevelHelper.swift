//
//  LevelHelpper.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/23/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit
import AVFoundation

class LevelHelper {
    
    class func prepareAudioPlayer(view: SKView) -> AVAudioPlayer {
        
        var audioPlayer: AVAudioPlayer? = AVAudioPlayer()
        
        if let path = NSBundle.mainBundle().pathForResource("backgroundTrack", ofType: ".mp3") {
            let url = NSURL.fileURLWithPath(path)
            var error: NSError?
            
            audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
            audioPlayer!.volume = 0.2
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            
            return audioPlayer!
        }
        return audioPlayer!
    }
    
    class func getLetterTexture(letter: String) -> SKTexture {
        let letterTextuer = SKTexture(imageNamed: letter)
        return letterTextuer
    }
    
    class func wonTextNode() -> SKSpriteNode {
        var wonText = SKSpriteNode()
        
        let w = SKSpriteNode(texture: self.getLetterTexture("w"))
        w.position = CGPoint(x: -52, y: 0)
        wonText.addChild(w)
        
        let o = SKSpriteNode(texture: self.getLetterTexture("o"))
        o.position = CGPoint(x: 0, y: 0)
        wonText.addChild(o)
        
        let n = SKSpriteNode(texture: self.getLetterTexture("n"))
        n.position = CGPoint(x: 52, y: 0)
        wonText.addChild(n)
        
        return wonText
    }
    
    class func getReadyAction(view: SKView) -> (action: SKAction, getReadyNode: SKSpriteNode) {
        
        // Method resouces
        let getReadyTexture = SKTexture(imageNamed: TextGetReady)
        let one = SKTexture(imageNamed: OneImage)
        let two = SKTexture(imageNamed: TwoImage)
        let three = SKTexture(imageNamed: ThreeImage)
        
        let getReadyAction = SKAction.animateWithTextures([getReadyTexture, three, two, one], timePerFrame: 1.0)
        let removeNode = SKAction.removeFromParent()
        
        let getReadyAndRemoveAction = SKAction.sequence([getReadyAction, removeNode])
        
        var getReadyNode = SKSpriteNode(texture: getReadyTexture)
        
        return (getReadyAndRemoveAction, getReadyNode)
    }
}
