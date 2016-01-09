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