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
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "thlem"))
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent()
        addComponent(physicsComponent)
        
        let jumpSfxComponent = JumpSfxComponent(name: "jump", loop: false)
        addComponent(jumpSfxComponent)
        
        let musicSfxComponent = MusicSfxComponent(name: "music", loop: true)
        addComponent(musicSfxComponent)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}