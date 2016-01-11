//
//  GameViewController.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-01.
//  Copyright (c) 2015 Simon Nilsson. All rights reserved.
//

import UIKit
import SpriteKit
import ScreenLayout

let screenJoinEnableMessageKey = "com.simphax.CollabJump.enableScreenJoinGesture"
let screenJoinDisableMessageKey = "com.simphax.CollabJump.disableScreenJoinGesture"

class GameViewController: SCLPinchViewController {
    
    var lastConnectedPeerID: MCPeerID?
    var gameScene: GameScene?
    
    var hostingGame = false
    var hostingGameId = "collabjumpAlex"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            scene.sessionManager = self.sessionManager
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = self.view.frame.size
            print("Scale : \(scene.xScale)")
            print("Frame : \(self.view.frame)")
            print("Size : \(scene.size)")
           
            if hostingGame {
                scene.lockBackground = true
                scene.hostingGame = true
            } else {
            }
            
            skView.presentScene(scene)
            gameScene = scene
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableJoinGesture", name: screenJoinEnableMessageKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableJoinGesture", name: screenJoinDisableMessageKey, object: nil)
    }
    
    func enableJoinGesture() {
        print("Enabling join gesture")
        layoutManager.enabled = true;
        motionManager.enabled = true;
    }
    
    func disableJoinGesture() {
        print("Disabling join gesture")
        layoutManager.enabled = false;
        motionManager.enabled = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        layoutManager.gestureRecognizer.cancelsTouchesInView = false

        self.sessionManager.startPeerInvitationsWithServiceType(hostingGameId, errorHandler: { (error) -> Void in
            print("invitations failed with error: \(error)")
        })
    }
/*
    override func shouldAutorotate() -> Bool {
        return true
    }
*/
/*
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func sessionManager(manager: SCLSessionManager!, didReceiveScreen screen: SCLScreen!) {
        
    }
    
    // remote peer changed state
    override func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case .NotConnected:
            print("peer not connected: \(peerID)")
            gameScene?.peerDisconnected(peerID)
        case .Connecting:
            print("peer connecting: \(peerID)")
            gameScene?.peerConnecting(peerID)
        case .Connected:
            print("peer connected: \(peerID)")
            gameScene?.peerConnected(peerID)
            lastConnectedPeerID = peerID
            let message: SCLSessionMessage = SCLSessionMessage(name: "hello", object: nil)
            do {
                try self.sessionManager.sendMessage(message, toPeers: [peerID], withMode: .Reliable)
            } catch _ {
                print("couldnt send message")
            }
        }
    }
    
    override func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        print("session did receive data \(data)")
    }
    
    // screen layout changed
    override func layoutDidChangeForScreens(affectedScreens: [AnyObject]!) {
        print("layoutDidChangeForScreens-----------------------------")
        print("\(affectedScreens)")
        
        let localScreen = SCLScreen.mainScreen()
        if (localScreen.layout != nil) {
            if let screens = localScreen.layout.screens as? [SCLScreen] {
                var i = 0
                var closestScreen: SCLScreen?
                var minOffset: CGPoint?
                for screen in screens {
                    let offset = localScreen.layout.convertPoint(CGPointZero, fromScreen: localScreen, toScreen: screen)
                    if(offset != CGPointZero) {
                        if(minOffset == nil || (abs(offset.x) + abs(offset.y)) < (abs(minOffset!.x) + abs(minOffset!.y))) {
                            minOffset = offset
                            closestScreen = screen
                        }
                    }
                    
                    print("Offset to \(i): \(offset)")
                    i++
                }
                
                if(closestScreen != nil && minOffset != nil) {
                    //minOffset!.y += localScreen.bounds.height
                    //var sceneSpaceOffset = gameScene!.convertPointFromView(minOffset!)
                    //sceneSpaceOffset.y *= -1
                    gameScene?.joinedWithScreen(closestScreen!)
                }
            }
        }
        print("-----------------------------")
    }
}
