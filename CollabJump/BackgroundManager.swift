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
    
    private var backgroundOffset: CGPoint?
    private var backgroundAngle: CGFloat?
    
    init(scene: GameScene) {
        self.scene = scene
        backgroundNodes = []
    }
    
    func setBackground(name: String, sliceCols: Int, sliceSize: Int) {
        backgroundName = name
        self.sliceCols = sliceCols
        self.sliceSize = sliceSize
    }
    
    func setBackgroundOffset(offset: CGPoint, angle: CGFloat) {
        if(offset != backgroundOffset) {
            if(sliceSize != nil && backgroundName != nil) {
                let sliceCol = Int(floor(abs(offset.x) / CGFloat(sliceSize!)))
                let sliceRow = Int(floor(abs(offset.y) / CGFloat(sliceSize!)))
                
                print("sliceCol: \(sliceCol), sliceRow: \(sliceRow)")
                
                let firstOffsetX = offset.x + CGFloat(sliceSize! * sliceCol)
                let firstOffsetY = offset.y - CGFloat(sliceSize! * sliceRow)
                
                var spriteCols = 1
                var spriteRows = 1
                
                if(angle > 0) {
                    while(-firstOffsetY + CGFloat(sliceSize! * spriteCols) < scene.size.height) {
                        spriteCols++
                    }
                    
                    while(-firstOffsetX + CGFloat(sliceSize! * spriteRows) < scene.size.width) {
                        spriteRows++
                    }
                }
                else {
                    while(firstOffsetX + CGFloat(sliceSize! * spriteCols) < scene.size.width) {
                        spriteCols++
                    }
                    
                    while(-firstOffsetY + CGFloat(sliceSize! * spriteRows) < scene.size.height) {
                        spriteRows++
                    }
                }
                
                print("Background cols: \(spriteCols), rows: \(spriteRows)")
                print("First offset: \(firstOffsetX), \(firstOffsetY)")
                
                //If we should display the same sprites, just move them.
                if(backgroundOffset != nil && lastSliceCol == sliceCol && lastSliceRow == sliceCol && lastSpriteCols == spriteCols && lastSpriteRows == spriteRows) {
                    let difference: CGPoint = (offset - backgroundOffset!)
                    print("difference \(difference)")
                    for backgroundNode in backgroundNodes {
                        backgroundNode.position += difference
                    }
                    backgroundOffset = offset
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
                        var bgOffsetX: CGFloat = 0
                        var bgOffsetY: CGFloat = 0
                        if(angle > 0) {
                            bgOffsetX = offset.x - CGFloat(sliceSize! * (sliceRow + spriteRow)) - CGFloat(sliceSize!) + CGFloat(sliceSize!) / 2.0
                            bgOffsetY = offset.y - CGFloat(sliceSize! * (sliceCol + spriteCol)) - CGFloat(sliceSize!) + CGFloat(sliceSize!) / 2.0
                            //bgOffsetY -= scene.size.height
                        } else {
                            bgOffsetX = offset.x + CGFloat(sliceSize! * (sliceCol + spriteCol)) + CGFloat(sliceSize!) / 2.0
                            bgOffsetY = offset.y - CGFloat(sliceSize! * (sliceRow + spriteRow)) - CGFloat(sliceSize!) / 2.0
                        }
                        bgOffsetY += scene.size.height
                        
                        let node = SKSpriteNode(texture: SKTexture(imageNamed: "\(backgroundName!)\(imageIndex)"))
                        //node.xScale = scene.inverseScaleFactor()
                        //node.yScale = scene.inverseScaleFactor()
                        node.zRotation = -angle
                        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        
                        
                        let scenePoint = scene.pointInVisibleSpace(CGPoint(x: bgOffsetX, y: bgOffsetY))
                        print("Offset \(bgOffsetX),\(bgOffsetY)")
                        print("Scene point \(scenePoint)")
                        node.position = scenePoint;
                        
                        //node.zRotation = -angle
                        node.zPosition = -1
                        
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
        
        backgroundOffset = offset
        backgroundAngle = angle
    }
}