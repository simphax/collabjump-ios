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
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
        
        label = SKLabelNode(fontNamed: "Titillium Web")
        label?.fontSize = 20
        label?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
        updateLabelText()
        gameScene.addChild(label!)
        
        if(gameScene.hostingGame) {
            button = ButtonNode(color: UIColor.whiteColor(), size: CGSize(width: 200, height: 40))
            button?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2 - 80)
            button?.buttonIdentifier = .Start
            button?.userInteractionEnabled = true
            
            gameScene.addChild(button!)
        }
        
        gameScene.pauseButton.hidden = true
        
        gameScene.physicsWorld.speed = 0.0
        
        let animationAtlas = SKTextureAtlas(named: "Tutorial")
        
        let numImages = animationAtlas.textureNames.count
        
        for var i=0; i<numImages; i++ {
            print(animationAtlas.textureNames[i])
            print("tutorial\(i).png")
            tutorialAnimationFrames.append(animationAtlas.textureNamed("tutorial\(i).png"))
        }
        if !gameScene.hostingGame {
            tutorialNode = SKSpriteNode(texture: tutorialAnimationFrames[0])
            tutorialNode!.position.x = gameScene.size.width / 2
            tutorialNode!.position.y = gameScene.size.height / 2
            var ratio = tutorialNode!.size.width/tutorialNode!.size.height
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
                    if !tutorialAnimationStarted {
                        tutorialAnimationStarted = true
                        
                        tutorialNode?.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(
                            tutorialAnimationFrames,
                            timePerFrame: 0.04,
                            resize: false,
                            restore: true)),
                            withKey:"TutorialAnimation")
                    }
                }
            }
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updateLabelText()
        
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
        
        if let platform = gameScene.entityManager?.getPlatform() {
            if let platformSprite = platform.componentForClass(SpriteComponent.self) {
                platformSprite.node.hidden = false
            }
        }
    }
}
