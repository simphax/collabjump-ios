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




func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x+right.x,y: left.y+right.y)
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var entityManager: EntityManager?
    var backgroundManager: BackgroundManager!
    var sessionManager: SCLSessionManager?
    
    var bgMusic: SKAudioNode!
    var bgImage: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
       
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8)
        physicsWorld.contactDelegate = self
        
        entityManager = EntityManager(scene: self)
        
        
        let player: Player = Player()
        let platform: Platform = Platform()
        
        let PlatformCategory:UInt32 = 1 << 1
        let PlayerCategory:UInt32 = 1 << 0
        
        // Player
        if let spriteComponent = player.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGRectGetMidX(self.frame) - 100, y: CGRectGetMidY(self.frame))
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOfSize: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.categoryBitMask = PlayerCategory
            spriteComponent.node.physicsBody?.contactTestBitMask = PlatformCategory
            spriteComponent.node.physicsBody?.collisionBitMask = PlatformCategory
            spriteComponent.node.physicsBody?.allowsRotation = false
            //spriteComponent.node.physicsBody?.friction = 0.0
            spriteComponent.node.physicsBody?.dynamic = true
            spriteComponent.node.physicsBody?.mass = 1
            spriteComponent.node.physicsBody?.affectedByGravity = true
            
            
        }
        
        // Platform
        if let spriteComponent = platform.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 300)
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOfSize: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.categoryBitMask = PlatformCategory
            spriteComponent.node.physicsBody?.contactTestBitMask = PlayerCategory
            spriteComponent.node.physicsBody?.collisionBitMask = PlayerCategory
            spriteComponent.node.physicsBody?.allowsRotation = false
            //spriteComponent.node.physicsBody?.friction = 0.01
            spriteComponent.node.physicsBody?.dynamic = false
            spriteComponent.node.physicsBody?.restitution = 0.0
            spriteComponent.node.physicsBody?.mass = 20
            spriteComponent.node.physicsBody?.affectedByGravity = false
        }
        
        
        entityManager!.add(player)
        entityManager!.add(platform)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionMessage:", name:SCLSessionManagerDidReceiveMessageNotification, object: nil)
        
        backgroundManager = BackgroundManager(scene: self)
        backgroundManager?.setBackground("background", sliceCols: 6, sliceSize: 1024)
        
        backgroundManager!.backgroundOffset = CGPoint(x: -920,y: 500)
        
        bgMusic = SKAudioNode(fileNamed: "music")
        bgMusic.autoplayLooped = true
        //bgMusic.avAudioNode?.engine?.mainMixerNode.volume = 0.5
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let player = Player()
        let spriteComponent = player.componentForClass(SpriteComponent.self)
        spriteComponent!.node.physicsBody?.velocity = CGVectorMake(5.0, 0.0)
        
        print("CONTACT")
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
    
    func pointInVisibleSpace(point: CGPoint) -> CGPoint {
        return point + self.convertPointFromView(CGPoint(x: 0,y: self.view!.bounds.height))
    }
    
    func playMusic() {
        if(bgMusic.parent == nil) {
            addChild(bgMusic)
        }
    }
    
    func pauseMusic() {
        bgMusic.removeFromParent()
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
                    
                    entityManager!.add(player)
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
            
//            entityManager!.add(player)
//            playMusic()
            
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
        entityManager!.update(deltaTime)
        if let player = entityManager!.getPlayer() {
            if let spriteNode = player.componentForClass(SpriteComponent.self)?.node {
                print(spriteNode.position)
                if spriteNode.position.y < 0 { //self.position.y + self.size.height
                    pauseMusic()
                    entityManager!.remove(player)
                }
            }
        }
    }
}
