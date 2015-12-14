//
//  GameScene.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-01.
//  Copyright (c) 2015 Simon Nilsson. All rights reserved.
//

import SpriteKit
import ScreenLayout
import GameKit

class GameScene: SKScene {
    
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var entityManager: EntityManager!
    var sessionManager: SCLSessionManager?
    
    override func didMoveToView(view: SKView) {
        
        entityManager = EntityManager(scene: self)
        
        let player: Player = Player()
        
        if let spriteComponent = player.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        }
        
        entityManager.add(player)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionMessage:", name:SCLSessionManagerDidReceiveMessageNotification, object: nil)
    }
    
    func sessionMessage(notif: NSNotification) {
        print("session message \(notif)")
        
        if let dict = notif.userInfo as? [String: AnyObject] {
            
            if let message = dict[SCLSessionManagerMessageUserInfoKey] as? SCLSessionMessage {
                if let positionMessage = message.object as? PositionMessage {
                    print(" position message! \(positionMessage.position)")
                    let location = positionMessage.position
                    
                    let player: Player = Player()
                    
                    if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                        spriteComponent.node.position = location
                    }
                    
                    entityManager.add(player)
                }
            }
            if let peerId = dict[SCLSessionManagerPeerIDUserInfoKey] as? MCPeerID {
                print(" got a message from \(peerId)")
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("gamescene touch")
       /* Called when a touch begins */
        for touch in touches {
            let location = touch.locationInNode(self)
            print(" touch location \(location)")
            
            let player: Player = Player()
            
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                spriteComponent.node.position = location
            }
            
            if let jumpSfx = player.componentForClass(JumpSfxComponent.self) {
                jumpSfx.play()
            }
            if let musicSfx = player.componentForClass(MusicSfxComponent.self) {
                musicSfx.play()
            }
            
            entityManager.add(player)
            
            if let sessionManager = sessionManager {
                let message: SCLSessionMessage = SCLSessionMessage(name: "ThlemPosition", object: PositionMessage(position: touch.locationInNode(self)))
                do {
                    try sessionManager.sendMessage(message, toPeers: sessionManager.session.connectedPeers, withMode: .Reliable)
                } catch _ {
                    print("couldnt send message")
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        self.updateDelta(delta)
    }
    
    func updateDelta(deltaTime: CFTimeInterval) {
        entityManager.update(deltaTime)
    }
}
