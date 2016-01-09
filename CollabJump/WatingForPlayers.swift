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
    
    unowned let gameScene: GameScene
    
    var label: SKLabelNode?
    var button: ButtonNode?
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
        
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
    }
    
    func updateLabelText() {
        if let label = label {
            let connectedCount = gameScene.sessionManager?.session.connectedPeers.count
            label.text = "\(Int(connectedCount!)) friends have joined your game"
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updateLabelText()
    }
    
    override func willExitWithNextState(nextState: GKState) {
        label?.removeFromParent()
        button?.removeFromParent()
    }
}
