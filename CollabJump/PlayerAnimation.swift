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
            standingFrames.append(standingAnimatedAtlas.textureNamed("ThlenStanding_\(i).png"))
        }
        sFrames = standingFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're standing")
        print(sFrames)
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
            sFrames,
            timePerFrame: 0.03,
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
            //let thlenRunningAnimated = "ThlenRunning_\(i)"
            runningFrames.append(runningAnimatedAtlas.textureNamed("ThlenRunning_\(i).png"))
        }
        
        thlenRunningFrames = runningFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're running")
        print(thlenRunningFrames)
            sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
                    thlenRunningFrames,
                    timePerFrame: 0.03,
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
            jumpingFrames.append(jumpingAnimatedAtlas.textureNamed("ThlenJumping_\(i).png"))
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

class PlayerLanding : GKState {
    var sprite: SKSpriteNode
    var fFrames: [SKTexture]!
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        let playerLandingAnimation = SKTextureAtlas(named: "ThlenLanding")
        var fallingFrames = [SKTexture]()
        
        let numImages = playerLandingAnimation.textureNames.count
        //remove the 2
        for var i=0; i<numImages; i++ {
            fallingFrames.append(playerLandingAnimation.textureNamed("ThlenLanding_\(i).png"))
        }
        
        fFrames = fallingFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're landing... or falling to our death! :(((")
        print(fFrames)
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
            fFrames,
            timePerFrame: 0.03,
            resize: false,
            restore: true)),
            withKey:"LandingInPlaceThlen")
    }
    
    override func willExitWithNextState(nextState: GKState?) {
        sprite.removeActionForKey("LandingInPlaceThlen")
    }
}

class PlayerIdle : GKState {
    var sprite: SKSpriteNode
    var iFrames: [SKTexture]!
    init (sprite: SKSpriteNode) {
        self.sprite = sprite
        let playerIdleAnimation = SKTextureAtlas(named: "ThlenIdle")
        var idleFrames = [SKTexture]()
        let numImages = playerIdleAnimation.textureNames.count
        for var i=0; i<numImages; i++ {
            idleFrames.append(playerIdleAnimation.textureNamed("ThlenIdle_\(i).png"))
        }
        iFrames = idleFrames
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("We're chilling bra")
        print(iFrames)
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
            iFrames,
            timePerFrame: 0.03,
            resize: false,
            restore: true)),
            withKey: "IdleInPlaceThlen")
    }
    
    override func willExitWithNextState(nextState: GKState?) {
        sprite.removeActionForKey("IdleInPlaceThlen")
    }
}