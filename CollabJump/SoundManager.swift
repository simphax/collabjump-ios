//
//  SoundManager.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-14.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class SoundManager {
    
    let soundJump = SKAction.playSoundFileNamed("jump", waitForCompletion: false)
    
    static let sharedInstance = SoundManager()
    
}