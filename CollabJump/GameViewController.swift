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

class PositionMessage: NSObject, NSSecureCoding {
    
    var position: CGPoint
    
    init(position: CGPoint) {
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        position = aDecoder.decodeCGPointForKey("position")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGPoint(position, forKey: "position")
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}

class GameViewController: SCLPinchViewController {
    
    var lastConnectedPeerID: MCPeerID?

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
            
            skView.presentScene(scene)
        }
   
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.sessionManager.startPeerInvitationsWithServiceType("pinchcanvas", errorHandler: { (error) -> Void in
            print("invitations failed with error: \(error)")
        })
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

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
        case .Connecting:
            print("peer connecting: \(peerID)")
        case .Connected:
            print("peer connected: \(peerID)")
            
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
        print("layoutDidChangeForScreens")
    }
}
