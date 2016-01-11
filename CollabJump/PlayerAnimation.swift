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

class PlayerStanding : GKState {
    var sprite: SKSpriteNode
    var sFrames: [SKTexture]!
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        let standingAnimatedAtlas = SKTextureAtlas(named: "ThlenStanding")
        var standingFrames = [SKTexture]()
        let numImages = standingAnimatedAtlas.textureNames.count
        //remove the 2
        for var i=0; i<numImages; i++ {
            standingFrames.append(standingAnimatedAtlas.textureNamed(standingAnimatedAtlas.textureNames[i]))
        }
        sFrames = standingFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're standing")
        print(sFrames)
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
            sFrames,
            timePerFrame: 0.1,
            resize: false,
            restore: true)),
            withKey:"StandingInPlaceThlen")
    }
    
    override func willExitWithNextState(nextState: GKState?) {
        sprite.removeActionForKey("StandingInPlaceThlen")
    }
}

class PlayerRunning : GKState {

    var sprite: SKSpriteNode
    var thlenRunningFrames: [SKTexture]!
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        let runningAnimatedAtlas = SKTextureAtlas(named: "ThlenRunning")
        var runningFrames = [SKTexture]()
        
        let numImages = runningAnimatedAtlas.textureNames.count
        //remove the 2
        for var i=0; i<numImages; i++ {
            //let thlenTextureName = "ThlenRunning_\(i)"
            runningFrames.append(runningAnimatedAtlas.textureNamed(runningAnimatedAtlas.textureNames[i]))
        }
        
        thlenRunningFrames = runningFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're running")
        print(thlenRunningFrames)
            sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
                    thlenRunningFrames,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true)),
                    withKey:"runningInPlaceThlen")
    }
    
    override func willExitWithNextState(nextState: GKState?) {
        sprite.removeActionForKey("runningInPlaceThlen")
    }
}


class PlayerJumping : GKState {
    var sprite: SKSpriteNode
    var jFrames: [SKTexture]!
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        let jumpingAnimatedAtlas = SKTextureAtlas(named: "ThlenJumping")
        var jumpingFrames = [SKTexture]()
        
        let numImages = jumpingAnimatedAtlas.textureNames.count
        //remove the 2
        for var i=0; i<numImages; i++ {
            jumpingFrames.append(jumpingAnimatedAtlas.textureNamed(jumpingAnimatedAtlas.textureNames[i]))
        }
        
        jFrames = jumpingFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're jumping!")
        print(jFrames)
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
            jFrames,
            timePerFrame: 0.1,
            resize: false,
            restore: true)),
            withKey:"JumpingInPlaceThlen")
    }
    
    override func willExitWithNextState(nextState: GKState?) {
        sprite.removeActionForKey("JumpingInPlaceThlen")
    }
}

class PlayerFalling : GKState {
    var sprite: SKSpriteNode
    var fFrames: [SKTexture]!
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        let playerFallingAnimation = SKTextureAtlas(named: "PlayerFalling")
        var fallingFrames = [SKTexture]()
        
        let numImages = playerFallingAnimation.textureNames.count
        //remove the 2
        for var i=0; i<numImages; i++ {
            fallingFrames.append(playerFallingAnimation.textureNamed(playerFallingAnimation.textureNames[i]))
        }
        
        fFrames = fallingFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're falling! :(((")
        print(fFrames)
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
            fFrames,
            timePerFrame: 0.1,
            resize: false,
            restore: true)),
            withKey:"FallingInPlaceThlen")
    }
    
    override func willExitWithNextState(nextState: GKState?) {
        sprite.removeActionForKey("FallingInPlaceThlen")
    }
}

class PlayerIdle : GKState {
    let playerIdleAnimation = SKTextureAtlas(named: "ThlenIdle")
}