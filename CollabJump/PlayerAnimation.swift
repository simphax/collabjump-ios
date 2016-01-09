//
//  PlayerAnimation.swift
//  CollabJump
//
//  Created by Alexander Yeh on 09/01/16.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import GameplayKit
import SpriteKit
import Foundation

class PlayerAnimation: GKEntity {
    
}

class PlayerStanding : GameState {
    let playerStandingAnimation = SKTextureAtlas(named: "ThlenStanding")
    //perhaps set time so he goes to idle after a while?
}

class PlayerRunning : GKState {
    
    var sprite: SKSpriteNode
    var thlenRunningFrames: [SKTexture]!
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        let thlenAnimatedAtlas = SKTextureAtlas(named: "ThlenRunning")
        var runningFrames = [SKTexture]()
        
        let numImages = thlenAnimatedAtlas.textureNames.count
        
        //remove the 2
        for var i=1; i<=numImages; i++ {
            let thlenTextureName = "ThlenRunning_\(i)"
            runningFrames.append(thlenAnimatedAtlas.textureNamed(thlenTextureName))
        }
        
        thlenRunningFrames = runningFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
            sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
                    thlenRunningFrames,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true)),
                    withKey:"runningInPlaceThlen")
    }
}


class PlayerJumping : GameState {
    let playerJumpingAnimation = SKTextureAtlas(named: "ThlenJumping")
    //play jumpSong
}

class PlayerFalling : GameState {
    let playerFallingAnimation = SKTextureAtlas(named: "ThlenFalling")
    //play landingSong
}

class PlayerIdle : GameState {
    let playerIdleAnimation = SKTextureAtlas(named: "ThlenIdle")
}