//
//  Platform.swift
//  CollabJump
//
//  Created by Alexander Yeh on 07/01/16.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import GameplayKit
import SpriteKit

class Platform: GKEntity {
    
    override init() {
        super.init()
        
        //RANDOMIFY the Platform
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "platform-11"))
        addComponent(spriteComponent)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}