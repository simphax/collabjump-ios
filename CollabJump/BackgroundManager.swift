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
    
    private var lastSliceCol: Int = 0
    private var lastSliceRow: Int = 0
    private var lastSpriteCols: Int = 1
    private var lastSpriteRows: Int = 1
    
    var backgroundOffset: CGPoint? {
        willSet(newOffset) {
            if(newOffset == backgroundOffset) {
                return;
            }
            
            if(newOffset != nil && sliceSize != nil && backgroundName != nil) {
                let sliceCol = Int(floor(abs(newOffset!.x) / CGFloat(sliceSize!)))
                let sliceRow = Int(floor(abs(newOffset!.y) / CGFloat(sliceSize!)))
                
                print("sliceCol: \(sliceCol), sliceRow: \(sliceRow)")
                
                let firstOffsetX = newOffset!.x + CGFloat(sliceSize! * sliceCol)
                let firstOffsetY = newOffset!.y - CGFloat(sliceSize! * sliceRow)
                
                var spriteCols = 1
                var spriteRows = 1
                
                while(firstOffsetX + CGFloat(sliceSize! * spriteCols) < scene.size.width) {
                    spriteCols++
                }
                
                while(-firstOffsetY + CGFloat(sliceSize! * spriteRows) < scene.size.height) {
                    spriteRows++
                }
                
                print("Background cols: \(spriteCols), rows: \(spriteRows)")
                print("First offset: \(firstOffsetX), \(firstOffsetY)")
                
                //If we should display the same sprites, just move them.
                if(backgroundOffset != nil && lastSliceCol == sliceCol && lastSliceRow == sliceCol && lastSpriteCols == spriteCols && lastSpriteRows == spriteRows) {
                    var difference: CGPoint = (newOffset! - backgroundOffset!)
                    print("difference \(difference)")
                    for backgroundNode in backgroundNodes {
                        backgroundNode.position += difference
                    }
                    return;
                }
                print("WAIT!")
                for backgroundNode in backgroundNodes {
                    backgroundNode.removeFromParent()
                }
                
                backgroundNodes.removeAll()
                
                for(var spriteCol=0; spriteCol<spriteCols; spriteCol++) {
                    for(var spriteRow=0; spriteRow<spriteRows; spriteRow++) {
                        
                        let imageIndex = (sliceRow + spriteRow) * sliceCols! + (sliceCol + spriteCol);
                        print("Image index: \(imageIndex)")
                        
                        let bgOffsetX = newOffset!.x + CGFloat(sliceSize! * (sliceCol + spriteCol));
                        var bgOffsetY = newOffset!.y - CGFloat(sliceSize! * (sliceRow + spriteRow));
                        
                        let node = SKSpriteNode(texture: SKTexture(imageNamed: "\(backgroundName!)\(imageIndex)"))
                        //node.xScale = scene.inverseScaleFactor()
                        //node.yScale = scene.inverseScaleFactor()
                        node.anchorPoint = CGPoint(x: 0, y: 1.0)
                        node.zPosition = -1
                        bgOffsetY += scene.size.height
                        node.position = scene.pointInVisibleSpace(CGPoint(x: bgOffsetX, y:bgOffsetY));
                        backgroundNodes.append(node)
                        scene.addChild(node)
                    }
                }
                
                lastSliceCol = sliceCol;
                lastSliceRow = sliceRow;
                lastSpriteCols = spriteCols;
                lastSpriteRows = spriteRows;
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