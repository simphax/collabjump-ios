//
//  Player.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-07.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

// For the collisionbitmasks
let PlayerCategory:UInt32 = 0 << 1
let PlatformCategory:UInt32 = 1 << 1

class Player: GKEntity {
    override init() {
        super.init()
        
        
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "thlem small"))
        
        spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOfSize: spriteComponent.node.size)
        spriteComponent.node.physicsBody?.allowsRotation = false
        spriteComponent.node.physicsBody?.dynamic = true
        spriteComponent.node.physicsBody?.mass = 1
        spriteComponent.node.physicsBody?.restitution = 0
        spriteComponent.node.physicsBody?.affectedByGravity = true
        spriteComponent.node.physicsBody?.categoryBitMask = PlayerCategory
        spriteComponent.node.physicsBody?.collisionBitMask = PlatformCategory
        spriteComponent.node.physicsBody?.contactTestBitMask = PlatformCategory
        
        
        addComponent(spriteComponent)
        
        let animationComponent = AnimationComponent()
        addComponent(animationComponent)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}