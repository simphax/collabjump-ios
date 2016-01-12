//
//  Scored.swift
//  CollabJump
//
//  Created by Alexander Yeh on 12/01/16.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Scored : GameState {
    
    //var scoreLabel: SKLabelNode?
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
        gameScene.scoreLabel?.text = "Score: \(gameScene.scoreCount)"
    }
    
    override func willExitWithNextState(nextState: GKState) {
        //whut whut whut!
    }
}