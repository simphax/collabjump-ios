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
    var entityManager: EntityManager?
    var backgroundManager: BackgroundManager?
    var sessionManager: SCLSessionManager?
    var bgMusic: SKAudioNode!
    var bgImage: SKSpriteNode!
    
    var offsetFromLastPhone: CGPoint?
    
    var joinedScreen: SCLScreen?
    
    var lockBackground: Bool = false
    
    override func didMoveToView(view: SKView) {
        entityManager = EntityManager(scene: self)

        /*
        origin/background
        let player: Player = Player()
        entityManager.add(player)
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionMessage:", name:SCLSessionManagerDidReceiveMessageNotification, object: nil)
        backgroundManager = BackgroundManager(scene: self)
        backgroundManager?.setBackground("background", sliceCols: 6, sliceRows: 5, sliceSize: 1024)
        backgroundManager?.setBackgroundOffset(CGPoint(x: 0,y: 0), angle: 0.0)
        
        bgMusic = SKAudioNode(fileNamed: "music")
        bgMusic.autoplayLooped = true
        //bgMusic.avAudioNode?.engine?.mainMixerNode.volume = 0.5
        print("Scale factor : \(scaleFactor())")
    }
    
    //Får ut offset och width och height.
    func visibleSpaceRect() -> CGRect {
        let topLeftPoint = self.convertPointFromView(CGPoint(x: 0,y: 0))
        let topRightPoint = self.convertPointFromView(CGPoint(x: self.view!.bounds.width, y: 0))
        let bottomLeftPoint = self.convertPointFromView(CGPoint(x: 0,y: self.view!.bounds.height))
        let rect = CGRect(x: bottomLeftPoint.x, y: bottomLeftPoint.y, width: abs(topRightPoint.x - topLeftPoint.x), height: abs(topLeftPoint.y - bottomLeftPoint.y))
        return rect
    }
    
    func pointInVisibleSpace(point: CGPoint) -> CGPoint {
        return point + self.convertPointFromView(CGPoint(x: 0,y: self.view!.bounds.height))
    }
    
    func scaleFactor() -> CGFloat {
        let visibleRect = visibleSpaceRect()
        return self.view!.frame.height / visibleRect.height
    }
    
    func inverseScaleFactor() -> CGFloat {
        let visibleRect = visibleSpaceRect()
        return visibleRect.height / self.view!.frame.height;
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
                if let handoverMessage = message.object as? HandoverMessage {
                    print("Handover message! \(handoverMessage.playerPosition)")
                    if(offsetFromLastPhone != nil) {
                        let location = handoverMessage.playerPosition
                        
                        let player: Player = Player()
                        
                        if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                            spriteComponent.node.position = location - offsetFromLastPhone!
                        }
                        
                        entityManager!.add(player)
                    } else {
                        print("NO OFFSET")
                    }
                }
            }
            if let peerId = dict[SCLSessionManagerPeerIDUserInfoKey] as? MCPeerID {
                print(" got a message from \(peerId)")
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("gamescene touch")
        
        var rect = visibleSpaceRect()
        print("Visisble rect: \(rect))")
       /* Called when a touch begins */
        for touch in touches {
            let location = touch.locationInNode(self)

            print(" touch location \(location)")
            //let atScreen = self.pointInVisibleSpace(CGPoint(x: 0, y: 0))
            
            let player: Player = Player()
            let rpc  = RandomPositionComponent(height: 32, width: 32, visibleSpace: self.visibleSpaceRect())
            
//            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
//                spriteComponent.node.position = location
//            }
            
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(
                    x:rpc.generateAtRandomPosition().randomX,
                    y:rpc.generateAtRandomPosition().randomY
                )
                print(spriteComponent.node.position)
                //CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            }
            
            entityManager!.add(player)
            playMusic()
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let delta: CFTimeInterval = currentTime - lastUpdateTimeInterval

        if(lastUpdateTimeInterval != 0) {
            self.updateDelta(delta)
        }

        lastUpdateTimeInterval = currentTime
    }
    
    func updateDelta(deltaTime: CFTimeInterval) {
        //print("\(deltaTime)")
        entityManager!.update(deltaTime)
        if let player = entityManager!.getPlayer() {
            if let spriteNode = player.componentForClass(SpriteComponent.self)?.node {
                //print(spriteNode.position)
                if spriteNode.position.y < 0 || spriteNode.position.x > self.size.width { //self.position.y + self.size.height
                    pauseMusic()
                    entityManager!.remove(player)
                    
                    if let sessionManager = sessionManager {
                        let message: SCLSessionMessage = SCLSessionMessage(name: "Handover", object: HandoverMessage(playerPosition: spriteNode.position))
                        do {
                            try sessionManager.sendMessage(message, toPeers: sessionManager.session.connectedPeers, withMode: .Reliable)
                        } catch _ {
                            print("couldnt send message")
                        }
                    }
                }
            }
        }
        //backgroundManager?.backgroundOffset? += CGPoint(x: -deltaTime*100, y: deltaTime*100)
    }
    
    func joinedWithScreen(screen: SCLScreen) {
        
        joinedScreen = screen
        
        let localScreen = SCLScreen.mainScreen()
        if let layout = screen.layout {
            let localScreen = SCLScreen.mainScreen()
            var bgOffset = localScreen.layout.convertPoint(CGPointZero, fromScreen: screen, toScreen: localScreen)
            let rect = localScreen.rectForScreen(screen)
            print("Background offset : \(bgOffset)")
            print("Other phone rect : \(rect)")
            print("SKView size : \(self.view?.bounds.size)")
            print("Self size : \(self.size)")
            print("Screen size : \(localScreen.bounds.size)")
            print("Anchor point : \(self.anchorPoint)")
            print("Self frame : \(self.frame)")
            print("Self position : \(self.position)")
            let angle = screen.convertAngle(0.0, toCoordinateSpace: self.view)
            print("Angle : \(angle)")
            //bgOffset.y *= -1
            
            let sceneRect = self.visibleSpaceRect()
            
            bgOffset.x *= sceneRect.size.width / localScreen.bounds.width
            bgOffset.y *= sceneRect.size.height / localScreen.bounds.height
            
            var sceneBgOffset = bgOffset//self.pointInVisibleSpace(bgOffset)
            //sceneBgOffset.x -= sceneRect.origin.x
            sceneBgOffset.y *= -1
            print("Scene offset : \(sceneBgOffset)")
            if(!lockBackground) {
                backgroundManager?.setBackgroundOffset(sceneBgOffset, angle: -angle)
            } else {
                backgroundManager?.setBackgroundOffset(CGPointZero, angle: 0.0)
            }
        } else {
            backgroundManager?.setBackgroundOffset(CGPointZero, angle: 0.0)
        }

        /*
        print("Joined screens! -- offset: \(offset)")

        if(offset.x > 0) {
            let player: Player = Player()
            
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: 100, y: 100)
            }
            
            entityManager!.add(player)
            playMusic()
        }
        if(offset.x < 0) {
            offsetFromLastPhone = offset
            
        }
        */
    }
    
    func disconnected() {
        
    }
}
