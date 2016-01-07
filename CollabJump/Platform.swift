//
//  Platform.swift
//  CollabJump
//
//  Created by Markus Thyrén on 2016-01-06.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Platform: GKEntity {
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "platform1"))
        addComponent(spriteComponent)
        
        //        let physicsComponent = PhysicsComponent()
        //        addComponent(physicsComponent)

    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}
