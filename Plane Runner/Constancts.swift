//
//  Constancts.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/26/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import UIKit

// MARK: Images
let BackgroundImage = "mainBackground"
let GroundGrassImage = "groundGrass"
let RockGrassImage = "rockGrass"
let RockGrassDownImage = "rockGrassDown"
let TextGameOver = "textGameOver"
let TextGetReady = "textGetReady"
let PlaneOneImage = "planeRed1"
let PlaneTwoImage = "planeRed2"
let PlaneThreeImage = "planeRed3"
let InfoIconImage = "information"
let BackIconImage = "arrowLeft"
let PauseIconImage = "pause"
let TapTick = "tapTick"
let StarGold = "starGold"
let ButtonSmallImage = "buttonSmall"
let ButtonLargeImgae = "buttonLarge"
let UIBackgroundImage = "Uibg"
let OneImage = "1"
let TwoImage = "2"
let ThreeImage = "3"

// MARK: Sounds
let PlaneFlyingSoundFX = "Helicopter.mp3"
let PlaneCrashSoundFX = "planeCrash.mp3"
let DistanceIncreaseSoundFX = "distanceTick.wav"
let StarFX = "star.mp3"
let ClickFX = "click.wav"
let BackgroundMusicSound = "backgroundTrack"

// MARK: Fonts
let GameFont = "kenvector_future-thin.tff"

// MARK: Other Resouces
let BlurAmount = 10.0

struct ZLevel {
    static let Background   : CGFloat = -2.0
    static let Foreground   : CGFloat = -1.0
    static let Ground       : CGFloat = 0.0
    static let Rocks        : CGFloat = 1.0
    static let Clouds       : CGFloat = 2.0
    static let PlaneSmoke   : CGFloat = 4.0
    static let Plane        : CGFloat = 5.0
    static let Tutorial     : CGFloat = 6.0
    static let Label        : CGFloat = 9.0
    static let HUD          : CGFloat = 10.0
    static let Pause        : CGFloat = 15.0
}

struct PhysicsCategory {
    static let All          :UInt32 = UInt32.max
    static let Plane        :UInt32 = 0x1
    static let Collidable   :UInt32 = 0x1 << 1
    static let Boundary     :UInt32 = 0x1 << 2
    static let Ground       :UInt32 = 0x1 << 3
    static let ButtonEnabled:UInt32 = 0x1 << 4
    static let Distance     :UInt32 = 0x1 << 5
    static let Stars        :UInt32 = 0x1 << 6
}
