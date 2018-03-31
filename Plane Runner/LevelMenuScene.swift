//
//  LevelMenuScene.swift
//  Plane Runner
//
//  Created by Eric Garcia on 5/14/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

enum LevelSelection {
    case one
    case two
    case three
}

class LevelMenuScene: SKScene {
    
    let worldNode = SKNode()
    let backBtnNode = SKNode()
    let levelsNode = SKNode()
    let dialogNode = SKNode()
    
    let levelManager = LevelManager.sharedInstance
    
    // Textures
    let bgTexture = SKTexture(imageNamed: BackgroundImage)
    let buttonTexture = SKTexture(imageNamed: ButtonSmallImage)
    let backBtnTexture = SKTexture(imageNamed: BackIconImage)
    let levelBackgroundTexture = SKTexture(imageNamed: UIBackgroundImage)
    let starEmpty = SKTexture(imageNamed: StarEmpty)
    let starBronze = SKTexture(imageNamed: StarBronze)
    let starSilver = SKTexture(imageNamed: StarSilver)
    let starGold = SKTexture(imageNamed: StarGold)
    
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
    
    override func didMove(to view: SKView) {
        self.addChild(worldNode)
        worldNode.addChild(backBtnNode)
        worldNode.addChild(levelsNode)
        worldNode.addChild(dialogNode)
        
        self.physicsWorld.contactDelegate = self
        
        // Click sound effect
        clickFX = SKAction.repeat(SKAction.playSoundFileNamed(ClickFX, waitForCompletion: true), count: 1)
        
        setupGestureRecognizers()
        
        createBackground(view)
        createBackButton(view)
        createLevels(view)
    }
}

// MARK: Scene Helpers
extension LevelMenuScene {
    
    func setupGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LevelMenuScene.swipedRight(_:)))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LevelMenuScene.swipedLeft(_:)))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
    }
    
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
    
    func createLabels(_ view: SKView) {
        // TODO: Setup "Stage One" and "Stage Two" lables, and pagination.
    }
    
    func createLevels(_ view: SKView) {
        let levelWidthSeperation = view.frame.width / 3
        let levelHeightSeperation = view.frame.height / 3
        
        stageOne(view, levelWidthSeperation: levelWidthSeperation, levelHeightSeperation: levelHeightSeperation)
        stageTwo(view, levelWidthSeperation: levelWidthSeperation, levelHeightSeperation: levelHeightSeperation)
    }
    
    func getstarTexture(_ starColor: Star) -> SKTexture {
        switch starColor {
        case .empty:
            return starEmpty
        case .bronze:
            return starBronze
        case .silver:
            return starSilver
        case .gold:
            return starGold
        }
    }
    
    func getCorrectStar(_ level: StageLevel) -> SKSpriteNode {
        switch level {
        case .firstOne :
            let numStars = levelManager.firstOneStars
            switch numStars {
            case 1:
                return SKSpriteNode(texture: getstarTexture(.bronze))
            case 2:
                return SKSpriteNode(texture: getstarTexture(.silver))
            case 3:
                return SKSpriteNode(texture: getstarTexture(.gold))
            default:
                return SKSpriteNode(texture: getstarTexture(.empty))
            }
        case .firstTwo:
            let numStars = levelManager.firstTwoStars
            switch numStars {
            case 1:
                return SKSpriteNode(texture: getstarTexture(.bronze))
            case 2:
                return SKSpriteNode(texture: getstarTexture(.silver))
            case 3:
                return SKSpriteNode(texture: getstarTexture(.gold))
            default:
                return SKSpriteNode(texture: getstarTexture(.empty))
            }
        case .firstThree:
            let numStars = levelManager.firstThreeStars
            switch numStars {
            case 1:
                return SKSpriteNode(texture: getstarTexture(.bronze))
            case 2:
                return SKSpriteNode(texture: getstarTexture(.silver))
            case 3:
                return SKSpriteNode(texture: getstarTexture(.gold))
            default:
                return SKSpriteNode(texture: getstarTexture(.empty))
            }
        case .secondOne:
            let numStars = levelManager.secondOneStars
            switch numStars {
            case 1:
                return SKSpriteNode(texture: getstarTexture(.bronze))
            case 2:
                return SKSpriteNode(texture: getstarTexture(.silver))
            case 3:
                return SKSpriteNode(texture: getstarTexture(.gold))
            default:
                return SKSpriteNode(texture: getstarTexture(.empty))
            }
        case .secondTwo:
            let numStars = levelManager.secondTwoStars
            switch numStars {
            case 1:
                return SKSpriteNode(texture: getstarTexture(.bronze))
            case 2:
                return SKSpriteNode(texture: getstarTexture(.silver))
            case 3:
                return SKSpriteNode(texture: getstarTexture(.gold))
            default:
                return SKSpriteNode(texture: getstarTexture(.empty))
            }
        case .secondThree:
            let numStars = levelManager.secondThreeStars
            switch numStars {
            case 1:
                return SKSpriteNode(texture: getstarTexture(.bronze))
            case 2:
                return SKSpriteNode(texture: getstarTexture(.silver))
            case 3:
                return SKSpriteNode(texture: getstarTexture(.gold))
            default:
                return SKSpriteNode(texture: getstarTexture(.empty))
            }
        }
    }
    
    func stageOne(_ view: SKView, levelWidthSeperation: CGFloat, levelHeightSeperation: CGFloat) {
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
        
        let sOneLOneStar = getCorrectStar(StageLevel.firstOne)
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
        
        let sOnelTwoStar = getCorrectStar(StageLevel.firstTwo)
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
        
        let sOnel0ThreeStar = getCorrectStar(StageLevel.firstThree)
        sOnel0ThreeStar.position = CGPoint(x: 0, y: -25)
        
        sOnel0Three.addChild(sOnel0ThreeIcon)
        sOnel0Three.addChild(sOnel0ThreeStar)
        
        levelsNode.addChild(sOnel0Three)
    }
    
    func stageTwo(_ view: SKView, levelWidthSeperation: CGFloat, levelHeightSeperation: CGFloat) {
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
        
        let s02l01Star = getCorrectStar(StageLevel.secondOne)
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
        
        let s02l02Star = getCorrectStar(StageLevel.secondTwo)
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
        
        let s02l03Star = getCorrectStar(StageLevel.secondThree)
        s02l03Star.position = CGPoint(x: 0, y: -25)
        
        s02l03.addChild(s02l03Icon)
        s02l03.addChild(s02l03Star)
        
        levelsNode.addChild(s02l03)
    }
}

// Mark: Input Methods
extension LevelMenuScene {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if backBtnNode.contains(location) {
                print("Back button pressed")
                self.run(clickFX)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
            }
            
            if sOneLOne.contains(location) {
                print("Level One")
                determineLevel(LevelSelection.one)
            }
            
            if sOnelTwo.contains(location){
                print("Level Two")
                determineLevel(LevelSelection.two)
            }
            
            if sOnel0Three.contains(location) {
                //                println("Stage: 1 Level: 3")
                print("Level Three")
                determineLevel(LevelSelection.three)
            }
        }
    }
    
    func determineLevel(_ level: LevelSelection) {
        switch level {
            
        // First Stage
        case .one:
            self.run(clickFX)
            if onStageOne{
                showLevel(StageLevel.firstOne)
            } else {
                showLevel(StageLevel.secondOne)
            }
        case .two:
            self.run(clickFX)
            if onStageOne{
                showLevel(StageLevel.firstTwo)
            } else {
                showLevel(StageLevel.secondTwo)
            }
        case .three:
            self.run(clickFX)
            if onStageOne{
                showLevel(StageLevel.firstThree)
            } else {
                showLevel(StageLevel.secondThree)
            }
        }
    }
    
    func showLevel(_ level: StageLevel) {
        let levelScene = LevelScene(size: size, level: level)
        self.view?.presentScene(levelScene)
    }
    
    @objc func swipedRight(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Right")
        if !onStageOne {
            let moveToOne = SKAction.moveBy( x: self.frame.size.width, y: 0, duration: 0.5)
            levelsNode.run(moveToOne)
            onStageOne = true
        }
    }
    
    @objc func swipedLeft(_ sender: UISwipeGestureRecognizer) {
        print("Swiped left")
        if onStageOne {
            let moveToTwo = SKAction.moveBy( x: -self.frame.size.width, y: 0, duration: 0.5)
            levelsNode.run(moveToTwo)
            onStageOne = false
        }
    }
}

// : SKPhysicsContactDelegate
extension LevelMenuScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("Button Pressed")
    }
}
