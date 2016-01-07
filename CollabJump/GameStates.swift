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
    
}

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
        label?.fontSize = 25
        label?.text = "WAITING FOR PLAYERS"
        label?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
        
        button = ButtonNode(color: UIColor.whiteColor(), size: CGSize(width: 200, height: 40))
        button?.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2 - 80)
        button?.buttonIdentifier = .Start
        button?.userInteractionEnabled = true
        
        gameScene.addChild(label!)
        gameScene.addChild(button!)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
        label?.removeFromParent()
        button?.removeFromParent()
    }
}



class DisjoinedScreen : GameState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
    }
}

class JoinedScreen : GameState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinEnableMessageKey, object: self)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
}

class Paused : GameState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
    }
}

class GameOver : GameState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName(screenJoinDisableMessageKey, object: self)
    }
}