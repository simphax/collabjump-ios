//
//  SfxComponent.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-11.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class SfxComponent: GKComponent {
    
    var name: String
    var loop: Bool
    var audioNode: SKAudioNode?
    
    init(name: String, loop: Bool) {
        self.name = name
        self.loop = loop
    }
    
    func play() {
        if(loop) {
            if(audioNode == nil) {
                if let spriteNode = self.entity?.componentForClass(SpriteComponent.self)?.node {
                    audioNode = SKAudioNode(fileNamed: "\(name)")
                    audioNode?.autoplayLooped = true
                    spriteNode.addChild(audioNode!)
                }
            }
        } else {
            if let spriteNode = self.entity?.componentForClass(SpriteComponent.self)?.node {
                let action: SKAction = SKAction.playSoundFileNamed("\(name)", waitForCompletion: false)
                spriteNode.runAction(action)
            }
        }
    }
    
    func stop() {
        if(audioNode != nil) {
            audioNode?.autoplayLooped = false;
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if(audioNode == nil) {
            if let spriteNode = self.entity?.componentForClass(SpriteComponent.self)?.node {
                audioNode = SKAudioNode(fileNamed: "\(name)")
                audioNode?.autoplayLooped = true
                spriteNode.addChild(audioNode!)
            }
        }
    }
}