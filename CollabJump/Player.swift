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
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "thlen"))
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent()
        addComponent(physicsComponent)
        
        spriteComponent.node.runAction(SoundManager.sharedInstance.soundJump)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}