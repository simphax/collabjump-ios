//
//  GameViewController.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-01.
//  Copyright (c) 2015 Simon Nilsson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, MosaicDelegate {

    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
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
        
        MosaicClient.sharedClient().attachToView(self.view)
        MosaicClient.sharedClient().delegate = self
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
    
    func debugLog(msg: String) {
        if(debugLabel.text == nil) {
            debugLabel.text = ""
        }
        debugLabel.text = msg + "\n" + debugLabel.text!
        debugPrint(msg)
    }
    
//MARK: MosaicDelegate
    
    func mosaicDidConnect() {
        debugLog("mosaicDidConnect")
    }
    
    func mosaicDidDisconnect() {
        debugLog("mosaicDidDisconnect")
    }
    
    func mosaicStateUpdated(state: NSData!) {
        debugLog("mosaicStateUpdated" + String(state))
    }
    
    func mosaicFrameUpdated(frame: CGRect) {
        debugLog("mosaicStateUpdated" + String(frame))
    }
    
    func mosaicSwipeOccurred(swipe: MosaicSwipe) {
        debugLog("mosaicSwipeOccurred" + String(swipe))
    }
}
