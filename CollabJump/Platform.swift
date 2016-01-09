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
//        if randomPlatformPosition == 0 {
//            spriteComponent.node.zRotation = CGFloat(M_PI_2)
//        }
        spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOfSize: spriteComponent.node.size)
        spriteComponent.node.physicsBody?.allowsRotation = false
        spriteComponent.node.physicsBody?.dynamic = false
        spriteComponent.node.physicsBody?.restitution = 0.0
        spriteComponent.node.physicsBody?.mass = 20
        spriteComponent.node.physicsBody?.affectedByGravity = false
        addComponent(spriteComponent)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        print("update",seconds)
    }
}

