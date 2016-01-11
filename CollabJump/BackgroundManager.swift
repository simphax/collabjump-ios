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
    
    private var backgroundNodes: [SKSpriteNode]
    
    private var blackOverlay: SKShapeNode?
    
    private var lastSliceCol: Int = 0
    private var lastSliceRow: Int = 0
    private var lastSpriteCols: Int = 1
    private var lastSpriteRows: Int = 1
    
    private var backgroundOffset: CGPoint?
    private var backgroundAngle: CGFloat?
    
    private var gridCalculator: GridCalculator?
    
    private var hidden = true
    
    init(scene: GameScene) {
        self.scene = scene
        backgroundNodes = []
    }
    
    func setBackground(name: String, sliceCols: Int, sliceRows: Int, sliceSize: Int) {
        backgroundName = name
        self.gridCalculator = GridCalculator(cellSize: sliceSize, gridCols: sliceCols, gridRows: sliceRows)
        
        blackOverlay = SKShapeNode(rect: CGRectMake(0, 0, self.scene.size.width, self.scene.size.height))
        blackOverlay?.fillColor = UIColor.blackColor()
        blackOverlay?.zPosition = -5
        var fadeIn = SKAction.fadeInWithDuration(0.0)
        blackOverlay?.runAction(fadeIn)
        scene.addChild(blackOverlay!)
    }
    
    func setBackgroundOffset(offset: CGPoint, angle: CGFloat) {
        print("setbgoffset!!!!")
        if(offset != backgroundOffset) {
            if(backgroundName != nil && gridCalculator != nil) {
                for backgroundNode in backgroundNodes {
                    backgroundNode.removeFromParent()
                }
                backgroundNodes.removeAll()

                let viewportRect = self.scene.visibleSpaceRect()
                print("viewPortRect: ",viewportRect)
                
                let degrees = gridCalculator!.radiansToDegrees(angle)
                print("Degrees: \(degrees)")
                
                var backgroundPosition = offset
                backgroundPosition.y += scene.size.height
                
                let backgrounds: [GridCell] = gridCalculator!.getCells(backgroundPosition, anchorPoint: CGPoint(x:0,y:1), angleDeg: Int(degrees), viewRect: viewportRect)
                
                print("backgrounds: \(backgrounds)")
                
                for background in backgrounds {
                    let node = SKSpriteNode(texture: SKTexture(imageNamed: "\(backgroundName!)\(background.index)"))
                    node.zRotation = background.angle
                    node.anchorPoint = CGPoint(x: 0, y: 0)
                    
                    let scenePoint = background.rect.origin
                    print("Scene point \(scenePoint)")
                    node.position = scenePoint;
                    
                    node.zPosition = -10
                    
                    backgroundNodes.append(node)
                    scene.addChild(node)
                }
                
            }
        }
        
        backgroundOffset = offset
        backgroundAngle = angle
    }
    
    func hideBackground() {
        if !hidden {
            hidden = true
            let fadeIn = SKAction.fadeInWithDuration(0.3)
            blackOverlay?.runAction(fadeIn)
        }
    }
    
    func showBackground() {
        if hidden {
            hidden = false
            let fadeOut = SKAction.fadeOutWithDuration(0.3)
            blackOverlay?.runAction(fadeOut)
            
            for backgroundNode in backgroundNodes {
                let scale: CGFloat = 0.6
                let scaleStart = SKAction.scaleTo(scale, duration: 0)
                var startPosition = backgroundNode.position
                //If the scale is c and the anchor is (a,b), then the new point is (cx+(1-c)a,cy+(1-c)b)
                startPosition.x = scale * startPosition.x + (1 - scale) * (self.scene.size.width/2)
                startPosition.y = scale * startPosition.y + (1 - scale) * (self.scene.size.height/2)
                let moveStart = SKAction.moveTo(startPosition, duration: 0)
                let endPosition = backgroundNode.position
                let scaleUp = SKAction.scaleTo(1.0, duration: 0.3)
                let moveEnd = SKAction.moveTo(endPosition, duration: 0.3)
                let group = SKAction.group([scaleUp,moveEnd])
                let sequence = SKAction.sequence([scaleStart, moveStart, group])
                backgroundNode.runAction(sequence)
            }
        }
    }
    
    func isHidden() -> Bool {
        return hidden
    }
}