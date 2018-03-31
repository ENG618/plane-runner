//
//  Plane.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/20/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class Plane {
    
    fileprivate let textureNames: [String]
    fileprivate var planeNode: SKSpriteNode
    
    var position:CGPoint {
        get {
            return planeNode.position
        }
        set {
            planeNode.position = newValue
        }
    }
    
    init(textureNames: [String]) {
        self.textureNames = textureNames
//        plane = SKSpriteNode(imageNamed: textureNames.first!)
        let planeTexture = SKTexture(imageNamed: textureNames.first!)
        planeNode = SKSpriteNode(texture: planeTexture)
//        super.init(texture: planeTexture, color: nil, size: planeTexture.size())
//        planeNode.zPosition = ZLevel.Plane
        setPhysics(planeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPlane() -> SKSpriteNode {
        return planeNode
    }
    
    fileprivate func setPhysics(_ plane: SKSpriteNode) {
        
        plane.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: plane.size.width, height: plane.size.height))
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.restitution = 0.0
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        
//        return plane
    }
    
    // MARK: Animation
    func start() -> SKSpriteNode {
        animate()
        return planeNode
    }
    
    func stop() -> SKSpriteNode {
        planeNode.removeAllActions()
        return planeNode
    }
    
    fileprivate func animate() {
        // Animate plans propeller
        let animation = SKAction.animateWithTextures(textureNames, timePerFrame: 0.05)
        let makePropellerSpin = SKAction.repeatActionForever(animation)
        planeNode.runAction(makePropellerSpin)
    }
}
