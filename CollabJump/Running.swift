//
//  Playing.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-11.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Running : GameState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
        
        gameScene.pauseButton.hidden = false
        gameScene.physicsWorld.speed = 0.5
        /*
        if !gameScene.lockBackground {
            gameScene.backgroundManager.hideBackground()
            if let platform = gameScene.entityManager?.getPlatform() {
                gameScene.entityManager?.remove(platform)
            }
            gameScene.randomPlatform()
        }
        */
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
    }
}