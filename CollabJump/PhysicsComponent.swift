//
//  PhysicsComponent.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-07.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PhysicsComponent: GKComponent {
    
    let gravityVector = vector2(4.8, 0)
    
    override init() {
        super.init()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if let spriteNode = self.entity?.componentForClass(SpriteComponent.self)?.node {
            let yChange: CGFloat = CGFloat(gravityVector.y * seconds * 50)
            let xChange: CGFloat = CGFloat(gravityVector.x * seconds * 50)
            //debugPrint(yChange)
            spriteNode.position.x += xChange
            spriteNode.position.y -= yChange
            
        }
    }
}