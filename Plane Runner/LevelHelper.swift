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
}
