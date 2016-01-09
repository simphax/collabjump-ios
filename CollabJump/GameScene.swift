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

class GameScene: SKScene, ButtonNodeResponderType, SKPhysicsContactDelegate {

    var lastUpdateTimeInterval: CFTimeInterval = 0
    var entityManager: EntityManager?
    var backgroundManager: BackgroundManager!
    var sessionManager: SCLSessionManager?
    var bgMusic: SKAudioNode!
    var bgImage: SKSpriteNode!
    
    var pauseButton: ButtonNode!
    
    var offsetFromLastPhone: CGPoint?
    
    var joinedScreen: SCLScreen?
    
    var lockBackground: Bool = false
    var hostingGame: Bool = false
    
    var stateMachine: GKStateMachine?
    
    var gameSessionPeers: [MCPeerID]?
    
    override func didMoveToView(view: SKView) {
        
        stateMachine = GKStateMachine(states: [WaitingForPlayers(gameScene: self), DisjoinedScreen(gameScene: self), JoinedScreen(gameScene: self), Paused(gameScene: self), GameOver(gameScene: self)])
       
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8)
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0
        
        entityManager = EntityManager(scene: self)
        randomPlatform()
        let platform = entityManager!.getPlatform()
        let platformNode = platform!.componentForClass(SpriteComponent.self)?.node
        
        if hostingGame {
            let player: Player = Player()
            
            // Player
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: (platformNode?.position.x)! - (platformNode?.size.width)!/2 ,
                        y: (platformNode?.position.y)! * 1.5 )
                
            }
            
            entityManager!.add(player)
        }
        
        pauseButton = ButtonNode(color: UIColor.whiteColor(), size: CGSizeMake(30, 30))
        pauseButton.position = CGPoint(x: self.size.width - 40, y: self.size.height - 40)
        pauseButton.buttonIdentifier = .Pause
        pauseButton.userInteractionEnabled = true
        addChild(pauseButton)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionMessage:", name:SCLSessionManagerDidReceiveMessageNotification, object: nil)
        backgroundManager = BackgroundManager(scene: self)
        backgroundManager?.setBackground("background", sliceCols: 6, sliceRows: 5, sliceSize: 1024)

        backgroundManager?.setBackgroundOffset(CGPoint(x: 0,y: 0), angle: 0.0)
        bgMusic = SKAudioNode(fileNamed: "music")
        bgMusic.autoplayLooped = true
        //bgMusic.avAudioNode?.engine?.mainMixerNode.volume = 0.5
        
        print("Scale factor : \(scaleFactor())")

        stateMachine?.enterState(WaitingForPlayers.self)
    
        if !hostingGame {
            backgroundManager?.hideBackground()
        }
    }
    
    func buttonTriggered(button: ButtonNode) {
        print("button triggered")
        if button.buttonIdentifier == .Start {
            print("Start!")
            if let sessionManager = sessionManager {
                print("Sending start game message")
                let startGameMessage = StartGameMessage()
                let message: SCLSessionMessage = SCLSessionMessage(name: "StartGame", object: startGameMessage)
                do {
                    startGame(startGameMessage)
                    try sessionManager.sendMessage(message, toPeers: sessionManager.session.connectedPeers, withMode: .Reliable)
                    gameSessionPeers = sessionManager.session.connectedPeers
                    
                } catch _ {
                    print("couldnt send message")
                }
            }
        }
        if button.buttonIdentifier == .Pause {
            print("Pause!")
            if let sessionManager = sessionManager {
                print("Sending pause game message")
                let pauseGameMessage = PauseGameMessage()
                let message: SCLSessionMessage = SCLSessionMessage(name: "PauseGame", object: pauseGameMessage)
                do {
                    try sessionManager.sendMessage(message, toPeers: gameSessionPeers, withMode: .Reliable)
                    pauseGame(pauseGameMessage)
                    stateMachine?.enterState(DisjoinedScreen.self)
                } catch _ {
                    print("couldnt send message")
                }
            }
        }
    }
    
    func pointInVisibleSpace(point: CGPoint) -> CGPoint? {
        if let view = self.view {
            return point + self.convertPointFromView(CGPoint(x: 0,y: view.bounds.height))
        } else {
            return nil
        }
    }
    
    
    //Får ut offset och width och height.
    func visibleSpaceRect() -> CGRect {
        let topLeftPoint = self.convertPointFromView(CGPoint(x: 0,y: 0))
        let topRightPoint = self.convertPointFromView(CGPoint(x: self.view!.bounds.width, y: 0))
        let bottomLeftPoint = self.convertPointFromView(CGPoint(x: 0,y: self.view!.bounds.height))
        let rect = CGRect(x: bottomLeftPoint.x, y: bottomLeftPoint.y, width: abs(topRightPoint.x - topLeftPoint.x), height: abs(topLeftPoint.y - bottomLeftPoint.y))
        return rect
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
   
        print("CONTACT")
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {

        print("END CONTACT")
        
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
                if let message = message.object as? HandoverMessage {
                    handoverMessage(message)
                }
                if let message = message.object as? StartGameMessage {
                    startGame(message)
                }
                if let message = message.object as? PauseGameMessage {
                    pauseGame(message)
                }
            }
            if let peerId = dict[SCLSessionManagerPeerIDUserInfoKey] as? MCPeerID {
                print(" got a message from \(peerId)")
            }
        }
    }
    //Calls on Platform and gets the size height and width, then gets a random position for the platform which gets placed.
    func randomPlatform () {
        let platform: Platform = Platform()
        let platformSpriteComponent = platform.componentForClass(SpriteComponent.self)
        let platformHeight = platformSpriteComponent!.node.size.height
        let platformWidth = platformSpriteComponent!.node.size.width
        let rpc  = RandomPositionComponent(height: platformHeight, width: platformWidth, visibleSpace: self.visibleSpaceRect())
        
        if let spriteComponent = platform.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(
                x:rpc.generateAtRandomPosition().randomX,
                y:rpc.generateAtRandomPosition().randomY
            )
            print(spriteComponent.node.position)
            //CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        }
        entityManager!.add(platform)
    }
    
    func handoverMessage(message: HandoverMessage) {
        print("Handover message! \(message.playerPosition)")
        if(offsetFromLastPhone != nil) {
            let localScreen = SCLScreen.mainScreen()
            let localLocation = convertPointFromView(localScreen.layout.convertPoint(message.playerPosition, fromScreen: joinedScreen, toScreen: localScreen))
            
            let player: Player = Player()
            
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                spriteComponent.node.position = localLocation
            }
            
            entityManager!.add(player)
            
            playMusic()
        } else {
            print("NO OFFSET")
        }
    }
    
    func startGame(message: StartGameMessage) {
        stateMachine?.enterState(DisjoinedScreen.self)
        
    }
    
    func pauseGame(message: PauseGameMessage) {
        stateMachine?.enterState(Paused.self)
    }
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("gamescene touch")
        /*
        var rect = visibleSpaceRect()
        print("Visisble rect: \(rect))")
       /* Called when a touch begins */
        for touch in touches {
            let location = touch.locationInNode(self)

            print(" touch location \(location)")
            let player: Player = Player()
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                
                spriteComponent.node.position = location
            }
            
//            playMusic()
            
        }
        */
    }
*/
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let delta: CFTimeInterval = currentTime - lastUpdateTimeInterval

        if(lastUpdateTimeInterval != 0) {
            self.updateDelta(delta)
        }

        lastUpdateTimeInterval = currentTime
  
        self.updateDelta(delta)
    }
    
    var hasJumped = false
    
    func updateDelta(deltaTime: CFTimeInterval) {
        
        stateMachine?.updateWithDeltaTime(deltaTime)
        
        //print("\(deltaTime)")
        entityManager?.update(deltaTime)
        
        testPlayerHandover()
        //backgroundManager?.backgroundOffset? += CGPoint(x: -deltaTime*100, y: deltaTime*100)
        
        
        if let player = entityManager!.getPlayer() {
            if let spriteNode = player.componentForClass(SpriteComponent.self)?.node {
                let platform = entityManager!.getPlatform()
                let platformNode = platform!.componentForClass(SpriteComponent.self)?.node
                
                if hasJumped == false && spriteNode.position.x > platformNode!.position.x + (platformNode?.size.width)!/2 - (spriteNode.size.width)/2{
                    
                    spriteNode.physicsBody?.applyImpulse(CGVectorMake(0.0, CGFloat(500.0)))
                    //spriteNode.physicsBody?.velocity.dx = 5.0
                    self.hasJumped = true
                    print("***JUMP***")
                    
                    
                }
                spriteNode.physicsBody!.velocity.dx += 6 * physicsWorld.speed
            }
        }
    }
    
    func testPlayerHandover() {
        //print("Shall we hand over player the the next phone?")
        if let player = entityManager!.getPlayer() {
            if let spriteNode = player.componentForClass(SpriteComponent.self)?.node {
                if spriteNode.position.y < 0 || spriteNode.position.x > self.size.width { //self.position.y + self.size.height
                    if let joinedScreen = joinedScreen {
                        if let sessionManager = sessionManager {
                            print("Sending handover message")
                            let message: SCLSessionMessage = SCLSessionMessage(name: "Handover", object: HandoverMessage(playerPosition: convertPointToView(spriteNode.position)))
                            do {
                                try sessionManager.sendMessage(message, toPeers: [joinedScreen.peerID], withMode: .Reliable)
                                pauseMusic()
                                entityManager!.remove(player)
                                lockBackground = false
                            } catch _ {
                                print("couldnt send message")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func joinedWithScreen(screen: SCLScreen) {
        joinedScreen = screen
        
        if let layout = screen.layout {
            let localScreen = SCLScreen.mainScreen()
            let joinedScreenOffset = localScreen.layout.convertPoint(CGPointZero, fromScreen: screen, toScreen: localScreen)
            var bgOffset = joinedScreenOffset
            let joinedScreenRect = localScreen.rectForScreen(screen)
            print("Background offset : \(bgOffset)")
            print("Other phone rect : \(joinedScreenRect)")
            print("SKView size : \(self.view?.bounds.size)")
            print("Self size : \(self.size)")
            print("Screen size : \(localScreen.bounds.size)")
            print("Anchor point : \(self.anchorPoint)")
            print("Self frame : \(self.frame)")
            print("Self position : \(self.position)")
            let angle = screen.convertAngle(0.0, toCoordinateSpace: self.view)
            print("Angle : \(angle)")
            //bgOffset.y *= -1
            
            offsetFromLastPhone = joinedScreenOffset
            
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
            backgroundManager?.showBackground()
            /*
            if(joinedScreenOffset.x >= self.size.width) {
                delay(2.0) {
                    let location = CGPoint(x: self.size.width/2, y: self.size.height/2)
                    
                    let player: Player = Player()
                    
                    if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                        spriteComponent.node.position = location
                    }
                    
                    self.entityManager!.add(player)
                    self.playMusic()
                }
            }
            */
        } else {
            backgroundManager?.setBackgroundOffset(CGPointZero, angle: 0.0)
        }
        
        testPlayerHandover()
        
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
    
    func peerDisconnected(peerID: MCPeerID) {
        if hostingGame && (stateMachine?.currentState is DisjoinedScreen || stateMachine?.currentState is JoinedScreen) {
            if let gameSessionPeers = gameSessionPeers {
                if gameSessionPeers.contains(peerID) {
                    if let sessionManager = sessionManager {
                        let pauseGameMessage = PauseGameMessage()
                        let message: SCLSessionMessage = SCLSessionMessage(name: "PauseGame", object: pauseGameMessage)
                        do {
                            pauseGame(pauseGameMessage)
                            try sessionManager.sendMessage(message, toPeers: gameSessionPeers, withMode: .Reliable)
                        } catch _ {
                            print("couldnt send message")
                        }
                    }
                }
            }
        }
    }
    
    func peerConnecting(peerID: MCPeerID) {
        
    }
    
    func peerConnected(peerID: MCPeerID) {
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
