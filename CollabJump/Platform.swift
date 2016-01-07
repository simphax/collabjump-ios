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
        
        //Random the platform shall occur.
        let imageNr = arc4random() % 10
        //Randomly selects between 2 and 4 for right type of rotation
        let randomPlatformPosition = (arc4random() % 2)
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "platform-\(imageNr)"))
        if randomPlatformPosition == 0 {
            spriteComponent.node.zRotation = CGFloat(M_PI_2)
        }
        addComponent(spriteComponent)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}