//
//  WatingForPlayers.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-09.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class WaitingForPlayers : GameState {
    
    var label: SKLabelNode?
    var button: ButtonNode?
    var tutorialAnimationStarted = false
    var tutorialAnimationRemoved = false
    var tutorialNode: SKSpriteNode?
    var tutorialAnimationFrames : [SKTexture] = []
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("waiting for players state")
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
        
        tutorialAnimationStarted = false
        tutorialAnimationRemoved = false
        
        gameScene.scoreLabel?.hidden = true
        
        label = SKLabelNode(fontNamed: "Titillium Web")
        label?.fontSize = 20
        label?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height - 40)
        updateLabelText()
        gameScene.addChild(label!)
        
        if(gameScene.hostingGame) {
            button = ButtonNode(imageNamed: "startbtn")
            button?.size = CGSize(width: 187, height: 60)
            button?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
            button?.buttonIdentifier = .Start
            button?.userInteractionEnabled = true
            
            gameScene.addChild(button!)
        }
        
        gameScene.pauseButton.hidden = true
        
        gameScene.physicsWorld.speed = 0.0
        
        
        if !gameScene.hostingGame {
            print("Create tutorial animation")
            let animationAtlas = SKTextureAtlas(named: "Tutorial")
            
            let numImages = animationAtlas.textureNames.count
            
            for var i=0; i<numImages; i++ {
                tutorialAnimationFrames.append(animationAtlas.textureNamed("tutorial\(i).png"))
            }
            tutorialNode = SKSpriteNode(texture: tutorialAnimationFrames[0])
            tutorialNode!.position.x = gameScene.size.width / 2
            tutorialNode!.position.y = gameScene.size.height / 2
            let ratio = tutorialNode!.size.width / tutorialNode!.size.height
            tutorialNode!.size.width = gameScene.size.width
            tutorialNode!.size.height = gameScene.size.width / ratio
            
            SKTextureAtlas.preloadTextureAtlases([animationAtlas], withCompletionHandler: {})
            
            gameScene.addChild(tutorialNode!)
            
            if let platform = gameScene.entityManager?.getPlatform() {
                if let platformSprite = platform.componentForClass(SpriteComponent.self) {
                    platformSprite.node.hidden = true
                }
            }
        }
    }
    
    func updateLabelText() {
        if let label = label {
            let connectedCount = gameScene.sessionManager?.session.connectedPeers.count
            
            if(gameScene.hostingGame) {
                label.text = "\(Int(connectedCount!)) friends have joined your game"
            } else {
                if(connectedCount == 0) {
                    label.text = "Connecting animation..."
                } else {
                    label.text = ""
                }
            }
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updateLabelText()
        let connectedCount = gameScene.sessionManager?.session.connectedPeers.count
        if !gameScene.hostingGame && connectedCount > 0 && !tutorialAnimationStarted && tutorialAnimationFrames.count > 0 {
            if let tutorialNode = tutorialNode {
                tutorialAnimationStarted = true
                print("Start tutorial animation")
                tutorialNode.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
                    tutorialAnimationFrames,
                    timePerFrame: 0.04,
                    resize: false,
                    restore: true)),
                    withKey:"TutorialAnimation")
            }
        }
        if tutorialAnimationStarted && gameScene.joinedScreens.count > 0 && !tutorialAnimationRemoved {
            tutorialAnimationRemoved = true
            tutorialNode?.removeFromParent()
            if let platform = gameScene.entityManager?.getPlatform() {
                if let platformSprite = platform.componentForClass(SpriteComponent.self) {
                    platformSprite.node.hidden = false
                }
            }
        }
    }
    
    override func willExitWithNextState(nextState: GKState) {
        tutorialAnimationStarted = false
        tutorialAnimationRemoved = false
        label?.removeFromParent()
        button?.removeFromParent()
        tutorialNode?.removeFromParent()
        tutorialAnimationFrames = []
        
        gameScene.scoreLabel?.hidden = false
        
        if let platform = gameScene.entityManager?.getPlatform() {
            if let platformSprite = platform.componentForClass(SpriteComponent.self) {
                platformSprite.node.hidden = false
            }
        }
    }
}
