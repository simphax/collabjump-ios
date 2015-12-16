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
    
    private var scene: GameScene
    
    private var backgroundName: String?
    
    private var sliceCols: Int?
    
    private var sliceSize: Int?
    
    private var backgroundNodes: [SKSpriteNode]
    
    var backgroundOffset: CGPoint? {
        didSet {
            
            backgroundNodes.removeAll()
            
            if(backgroundOffset != nil && sliceSize != nil && backgroundName != nil) {
                let sliceCol = Int(floor(abs(backgroundOffset!.x) / CGFloat(sliceSize!)))
                let sliceRow = Int(floor(abs(backgroundOffset!.y) / CGFloat(sliceSize!)))
                
                print("sliceCol: \(sliceCol), sliceRow: \(sliceRow)")
                
                var firstOffsetX = backgroundOffset!.x + CGFloat(sliceSize! * sliceCol);
                var firstOffsetY = backgroundOffset!.y - CGFloat(sliceSize! * sliceRow);
                
                
                var spriteCols = 1;
                var spriteRows = 1;
                
                while(firstOffsetX + CGFloat(sliceSize! * spriteCols) < scene.size.width) {
                    spriteCols++;
                }
                
                while(-firstOffsetY + CGFloat(sliceSize! * spriteRows) < scene.size.height) {
                    spriteRows++;
                }
                
                print("Background cols: \(spriteCols), rows: \(spriteRows)")
                print("Image 1 pos: \(firstOffsetX), \(firstOffsetY)")
                
                for(var spriteCol=0; spriteCol<spriteCols; spriteCol++) {
                    for(var spriteRow=0; spriteRow<spriteRows; spriteRow++) {
                        
                        let imageIndex = (sliceRow + spriteRow) * sliceCols! + (sliceCol + spriteCol);
                        print("Image index: \(imageIndex)")
                        
                        var bgOffsetX = backgroundOffset!.x + CGFloat(sliceSize! * (sliceCol + spriteCol));
                        var bgOffsetY = backgroundOffset!.y - CGFloat(sliceSize! * (sliceRow + spriteRow));
                        
                        let node = SKSpriteNode(imageNamed: "\(backgroundName!)\(imageIndex)")
                        node.anchorPoint = CGPoint(x: 0, y: 1.0)
                        node.zPosition = -1
                        bgOffsetY += scene.size.height
                        node.position = scene.pointInVisibleSpace(CGPoint(x: bgOffsetX, y:bgOffsetY));
                        backgroundNodes.append(node)
                        scene.addChild(node)
                    }
                }
            }
        }
    }
    
    
    init(scene: GameScene) {
        self.scene = scene
        backgroundNodes = []
    }
    
    func setBackground(name: String, sliceCols: Int, sliceSize: Int) {
        backgroundName = name
        self.sliceCols = sliceCols
        self.sliceSize = sliceSize
    }
    
    
}