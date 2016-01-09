//
//  GameStates.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-06.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class GameState : GKState {
    
    unowned let gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
}

class DisjoinedScreen : GameState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
        
        gameScene.pauseButton.hidden = false
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
    }
}

class JoinedScreen : GameState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
        gameScene.pauseButton.hidden = false
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
}

class GameOver : GameState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
        gameScene.pauseButton.hidden = true
    }
}