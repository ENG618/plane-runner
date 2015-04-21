//
//  Plane.swift
//  Plane Runner
//
//  Created by Eric Garcia on 4/20/15.
//  Copyright (c) 2015 Garcia Enterprise. All rights reserved.
//

import SpriteKit

class Plane {
    
    private let plane: SKSpriteNode!
    private let textureNames: [String]
    
    init(textureNames: [String]) {
        self.textureNames = textureNames
        plane = SKSpriteNode(imageNamed: textureNames.first!)
        plane.zPosition = ZLevel.Plane
        self.setPhysics(plane)
    }
    
//    private func createPlane() -> SKSpriteNode {
//        let planeNode = SKSpriteNode(imageNamed: textureNames.first!)
//        planeNode.zPosition = ZLevel.Plane
//        
//        return setPhysics(planeNode)
//    }
    
    private func setPhysics(plane: SKSpriteNode) {
        
        plane.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(plane.size.width, plane.size.height))
        plane.physicsBody?.dynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.restitution = 0.0
        plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        plane.physicsBody?.collisionBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.Collidable | PhysicsCategory.Boundary | PhysicsCategory.Ground
        
//        return plane
    }
    
    // MARK: Animation
    func start() -> Plane {
        animate()
        return self
    }
    
    func stop() -> Plane {
        plane.removeAllActions()
        return self
    }
    
    private func animate() {
        // Animate plans propeller
        let animation = SKAction.animateWithTextures(textureNames, timePerFrame: 0.05)
        let makePropellerSpin = SKAction.repeatActionForever(animation)
        plane.runAction(makePropellerSpin)
    }
}
