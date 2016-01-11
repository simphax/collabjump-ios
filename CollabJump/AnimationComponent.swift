//
//  AnimationComponent.swift
//  CollabJump
//
//  Created by Alexander Yeh on 09/01/16.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AnimationComponent: GKComponent {
    var stateMachine: GKStateMachine?
    
    override init() {
        super.init()
        
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
        if stateMachine == nil {
            if let spriteNode = self.entity?.componentForClass(SpriteComponent.self)?.node {
                stateMachine = GKStateMachine(states: [PlayerStanding(sprite: spriteNode), PlayerRunning(sprite: spriteNode), PlayerJumping(sprite: spriteNode), PlayerFalling(), PlayerIdle()])
            }
        }
        
        stateMachine?.updateWithDeltaTime(seconds)
    }
}