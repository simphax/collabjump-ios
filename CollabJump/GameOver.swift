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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
        gameScene.pauseButton.hidden = true
        gameScene.physicsWorld.speed = 0.0
        gameScene.lockBackground = true
        gameScene.pauseMusic()
        
        if(gameScene.hostingGame) {
            button = ButtonNode(color: UIColor.whiteColor(), size: CGSize(width: 200, height: 40))
            button?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2 - 80)
            button?.buttonIdentifier = .Restart
            button?.userInteractionEnabled = true
            
            gameScene.addChild(button!)
        }
        
        label = SKLabelNode(fontNamed: "Titillium Web")
        label?.fontSize = 20
        label?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
        label?.text = "GAME OVER"
        gameScene.addChild(label!)
    }
    
    override func willExitWithNextState(nextState: GKState) {
        label?.removeFromParent()
        button?.removeFromParent()
    }
}