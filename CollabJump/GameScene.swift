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
    
    let gameOverDistance: CGFloat = 200

    var lastUpdateTimeInterval: CFTimeInterval = 0
    var entityManager: EntityManager?
    var backgroundManager: BackgroundManager!
    var sessionManager: SCLSessionManager?
    var bgMusic: SKAudioNode!
    var bgImage: SKSpriteNode!
    
    // For the collisionbitmasks
    let PlayerCategory:UInt32 = 0 << 1
    let PlatformCategory:UInt32 = 1 << 1
    
    var pauseButton: ButtonNode!
    
    var offsetFromLastPhone: CGPoint?
    var bgOffset: CGPoint = CGPoint(x: -200,y: 200)
    
    var joinedScreen: SCLScreen?
    var bgOffsetJoinedScreen: CGPoint?
    
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
                        y: (platformNode?.position.y)! + 100 )
                spriteComponent.node.physicsBody?.categoryBitMask = PlayerCategory
                spriteComponent.node.physicsBody?.collisionBitMask = PlatformCategory
                spriteComponent.node.physicsBody?.contactTestBitMask = PlatformCategory
                platformNode!.physicsBody?.categoryBitMask = PlatformCategory
                platformNode!.physicsBody?.collisionBitMask = PlayerCategory
                platformNode!.physicsBody?.contactTestBitMask = PlayerCategory
                
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

        backgroundManager?.setBackgroundOffset(bgOffset, angle: 0.0)
        bgMusic = SKAudioNode(fileNamed: "music")
        bgMusic.autoplayLooped = true
        //bgMusic.avAudioNode?.engine?.mainMixerNode.volume = 0.5
        
        print("Scale factor : \(scaleFactor())")

        stateMachine?.enterState(WaitingForPlayers.self)
    
        if !hostingGame {
            backgroundManager?.hideBackground()
        } else {
            backgroundManager.showBackground()
        }
    }
    
    func buttonTriggered(button: ButtonNode) {
        print("button triggered")
        if button.buttonIdentifier == .Start {
            backgroundManager?.showBackground()
            print("Start!")
            if let sessionManager = sessionManager {
                print("Sending start game message")
                let startGameMessage = StartGameMessage()
                let message: SCLSessionMessage = SCLSessionMessage(name: "StartGame", object: startGameMessage)
                do {
                    //TODO: Don't start if we have no one connected
                    startGame(startGameMessage)
                    try sessionManager.sendMessage(message, toPeers: sessionManager.session.connectedPeers, withMode: .Reliable)
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
                    pauseGame(pauseGameMessage)
                    try sessionManager.sendMessage(message, toPeers: gameSessionPeers, withMode: .Reliable)
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
   
//        let player = entityManager?.getPlayer()
//        let spriteComponent = player!.componentForClass(SpriteComponent.self)
//        spriteComponent?.node.physicsBody?.velocity.dx = 60 * physicsWorld.speed
        
        playMusic()

        print("CONTACT")
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {

//        let player = entityManager?.getPlayer()
//        let spriteComponent = player!.componentForClass(SpriteComponent.self)
//        spriteComponent?.node.physicsBody?.velocity.dx = 600 * physicsWorld.speed
        
        pauseMusic()

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
                if let message = message.object as? GameOverMessage {
                    gameOver(message)
                }
                if let message = message.object as? BgOffsetMessage {
                    bgOffsetMessage(message)
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
        let rpc = RandomPositionComponent(height: platformHeight, width: platformWidth, visibleSpace: self.visibleSpaceRect())
        
        if let spriteComponent = platform.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = rpc.generateAtRandomPosition()
            print(spriteComponent.node.position)
            //CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        }
        entityManager!.add(platform)
    }
    
    func handoverMessage(message: HandoverMessage) {
        print("Handover message! \(message.playerPosition)")
        if(joinedScreen != nil) {
            let localScreen = SCLScreen.mainScreen()
            let localLocation = convertPointFromView(localScreen.layout.convertPoint(message.playerPosition, fromScreen: joinedScreen, toScreen: localScreen))
            
            let player: Player = Player()
            
            if let spriteComponent = player.componentForClass(SpriteComponent.self) {
                spriteComponent.node.position = localLocation
            }
            
            entityManager!.add(player)
            
            self.joinedScreen = nil
            self.bgOffsetJoinedScreen = nil
            self.lockBackground = true
            stateMachine?.enterState(DisjoinedScreen.self)
        } else {
            print("NO joinedScreen")
        }
    }
    
    func startGame(message: StartGameMessage) {
        if joinedScreen == nil {
            stateMachine?.enterState(DisjoinedScreen.self)
        } else {
            stateMachine?.enterState(JoinedScreen.self)
        }
        print("start game")
        if let sessionManager = sessionManager {
            gameSessionPeers = sessionManager.session.connectedPeers
        }
    }
    
    func pauseGame(message: PauseGameMessage) {
        stateMachine?.enterState(Paused.self)
        print("pause game")
    }
    
    func gameOver(message: GameOverMessage) {
        stateMachine?.enterState(GameOver.self)
    }
    
    func bgOffsetMessage(message: BgOffsetMessage) {
        bgOffsetJoinedScreen = message.offset
        
    }
    
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

                    
                    spriteNode.physicsBody?.applyImpulse(CGVectorMake(200.0, CGFloat(600.0)))
                    
                    //spriteNode.physicsBody?.velocity.dx = 500.0

                    self.hasJumped = true
                    print("***JUMP***")
                    spriteNode.runAction(SoundManager.sharedInstance.soundJump)
                }

                if hasJumped == true {
                    // do nothing to affect speed in x
                }
                else {
                spriteNode.physicsBody!.velocity.dx = 50 * physicsWorld.speed
                }
            }
        }
        
        if !lockBackground && backgroundManager != nil && joinedScreen != nil && bgOffsetJoinedScreen != nil {
            if joinedScreen!.layout != nil {
                let localScreen = SCLScreen.mainScreen()
                var bgOffsetJoinedScreenView : CGPoint = bgOffsetJoinedScreen!
                //bgOffsetJoinedScreenView.y -= joinedScreen!.bounds.height
                bgOffsetJoinedScreenView.y *= -1
                
                print("bgOffsetJoinedScreenView : \(bgOffsetJoinedScreenView)")
                let joinedScreenOffset = localScreen.layout.convertPoint(bgOffsetJoinedScreenView, fromScreen: joinedScreen, toScreen: localScreen)
                var viewBgOffset = joinedScreenOffset
                let joinedScreenRect = localScreen.rectForScreen(joinedScreen)
                print("joinedScreenOffset : \(joinedScreenOffset)")
                print("Other phone rect : \(joinedScreenRect)")
                print("SKView size : \(self.view?.bounds.size)")
                print("Self size : \(self.size)")
                print("Screen size : \(localScreen.bounds.size)")
                print("Anchor point : \(self.anchorPoint)")
                print("Self frame : \(self.frame)")
                print("Self position : \(self.position)")
                let angle = joinedScreen!.convertAngle(0.0, toCoordinateSpace: self.view)
                print("Angle : \(angle)")
                //bgOffset.y *= -1
                
                offsetFromLastPhone = joinedScreenOffset
                
                let sceneRect = self.visibleSpaceRect()
                
                viewBgOffset.x *= sceneRect.size.width / localScreen.bounds.width
                viewBgOffset.y *= sceneRect.size.height / localScreen.bounds.height
                
                var sceneBgOffset = viewBgOffset//self.pointInVisibleSpace(bgOffset)
                //sceneBgOffset.x -= sceneRect.origin.x
                sceneBgOffset.y *= -1
                print("Scene offset : \(sceneBgOffset)")
                
                bgOffset = sceneBgOffset
                backgroundManager?.setBackgroundOffset(bgOffset, angle: -angle)
                
                backgroundManager?.showBackground()
                
                bgOffsetJoinedScreen = nil
            } else {
                backgroundManager?.setBackgroundOffset(CGPointZero, angle: 0.0)
            }
        }
    }
    
    func testPlayerHandover() {
        //print("Shall we hand over player the the next phone?")
        if let player = entityManager!.getPlayer() {
            if let spriteNode = player.componentForClass(SpriteComponent.self)?.node {
                if spriteNode.position.y < -gameOverDistance || spriteNode.position.x > self.size.width + gameOverDistance {
                    
                    if let sessionManager = sessionManager {
                        print("Sending gameover message")
                        let gameOverMessage = GameOverMessage()
                        let message: SCLSessionMessage = SCLSessionMessage(name: "GameOver", object: gameOverMessage)
                        do {
                            try sessionManager.sendMessage(message, toPeers: gameSessionPeers, withMode: .Reliable)
                            gameOver(gameOverMessage)
                            entityManager!.remove(player)
                        } catch _ {
                            print("couldnt send message")
                        }
                    }
                } else if spriteNode.position.y < 0 || spriteNode.position.x > self.size.width { //self.position.y + self.size.height
                    if let joinedScreen = joinedScreen {
                        if let sessionManager = sessionManager {
                            print("Sending handover message")
                            let message: SCLSessionMessage = SCLSessionMessage(name: "Handover", object: HandoverMessage(playerPosition: convertPointToView(spriteNode.position)))
                            do {
                                try sessionManager.sendMessage(message, toPeers: [joinedScreen.peerID], withMode: .Reliable)
                                pauseMusic()
                                entityManager!.remove(player)
                                lockBackground = false
                                self.joinedScreen = nil
                                self.bgOffsetJoinedScreen = nil
                                self.lockBackground = false
                                stateMachine?.enterState(DisjoinedScreen.self)
                            } catch _ {
                                print("couldnt send message")
                            }
                        }
                    //Is it game over?
                    }
                }
            }
        }
    }
    
    func shouldLockBackground() -> Bool {
        return entityManager?.getPlayer() != nil
    }
    
    func joinedWithScreen(screen: SCLScreen) {
        joinedScreen = screen
        
        if let sessionManager = sessionManager {
            print("Sending bg offset message")
            let bgOffsetMessage = BgOffsetMessage(offset: bgOffset)
            let message: SCLSessionMessage = SCLSessionMessage(name: "BgOffset", object: bgOffsetMessage)
            do {
                try sessionManager.sendMessage(message, toPeers: [screen.peerID], withMode: .Reliable)
            } catch _ {
                print("couldnt send message")
            }
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
