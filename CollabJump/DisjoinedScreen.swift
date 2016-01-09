//
//  DisjoinedScreen.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-09.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class DisjoinedScreen : GameState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
        
        gameScene.pauseButton.hidden = false
        gameScene.physicsWorld.speed = 1.0
        if !gameScene.lockBackground {
            gameScene.backgroundManager.hideBackground()
            if let platform = gameScene.entityManager?.getPlatform() {
                gameScene.entityManager?.remove(platform)
            }
            gameScene.randomPlatform()
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
    }
}

