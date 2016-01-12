//
//  GameOver.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-09.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class GameOver : GameState {
    
    var label: SKLabelNode?
    var button: ButtonNode?
    var redBg: SKShapeNode?
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
        gameScene.pauseButton.hidden = true
        gameScene.physicsWorld.speed = 0.0
        gameScene.lockBackground = true
        gameScene.pauseMusic()
        
        redBg = SKShapeNode(rect: CGRect(origin: CGPointZero,size: gameScene.size))
        redBg?.strokeColor = UIColor.redColor()
        redBg?.fillColor = UIColor.redColor()
        redBg?.zPosition = 5
        
        gameScene.addChild(redBg!)
        
        let hide = SKAction.fadeOutWithDuration(0)
        let fadeIn = SKAction.fadeInWithDuration(2)
        let sequence = SKAction.sequence([hide,fadeIn])
        redBg?.runAction(sequence)
        
        
        if(gameScene.hostingGame) {
            button = ButtonNode(imageNamed: "restartbtn")
            button?.size = CGSize(width: 187, height: 60)
            button?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2 - 70)
            button?.buttonIdentifier = .Restart
            button?.userInteractionEnabled = true
            button?.zPosition = 10
            
            gameScene.addChild(button!)
        }
        
        label = SKLabelNode(fontNamed: "Titillium Web")
        label?.fontSize = 20
        label?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
        label?.text = "GAME OVER"
        label?.zPosition = 10
        gameScene.addChild(label!)
    }
    
    override func willExitWithNextState(nextState: GKState) {
        label?.removeFromParent()
        button?.removeFromParent()
        redBg?.removeFromParent()
    }
}