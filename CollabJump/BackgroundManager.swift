//
//  SlicedSprite.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-16.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class BackgroundManager {
    
    private var scene: SKScene
    
    private var backgroundName: String?
    
    private var backgroundCols: Int?
    
    private var sliceSize: Int?
    
    var backgroundOffset: CGPoint? {
        didSet {
            
            let node = SKSpriteNode(imageNamed: "background_01")
            node.anchorPoint = CGPoint(x: 0, y: 1.0)
            node.zPosition = -1
            backgroundOffset!.y += scene.size.height
            node.position = backgroundOffset!
            scene.addChild(node)
        }
    }
    
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func setBackground(name: String, cols: Int, sliceSize: Int) {
        backgroundName = name
        backgroundCols = cols
        self.sliceSize = sliceSize
    }
    
    
}