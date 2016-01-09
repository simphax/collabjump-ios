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

class Player: GKEntity {
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "thlem small"))
        
        spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOfSize: spriteComponent.node.size)
        spriteComponent.node.physicsBody?.allowsRotation = false
        spriteComponent.node.physicsBody?.dynamic = true
        spriteComponent.node.physicsBody?.mass = 1

//        let physicsComponent = PhysicsComponent()
//        addComponent(physicsComponent)
        
        
        spriteComponent.node.runAction(SoundManager.sharedInstance.soundJump)
        addComponent(spriteComponent)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
       
        print("update",seconds)
    }
}