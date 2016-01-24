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
    
    private var backgroundNodes: Set<SKSpriteNode> = []
    private var toRemove: Set<SKSpriteNode> = []
    
    private var blackOverlay: SKShapeNode?
    
    private var lastSliceCol: Int = 0
    private var lastSliceRow: Int = 0
    private var lastSpriteCols: Int = 1
    private var lastSpriteRows: Int = 1
    
    private var backgroundOffset: CGPoint = CGPointZero
    private var backgroundAngle: CGFloat = 0.0
    
    private var sliceSize: CGFloat?
    
    private var gridCalculator: GridCalculator?
    
    private var hidden = true
    
    private var previousBgCells: [GridCell] = []
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func setBackground(name: String, sliceCols: Int, sliceRows: Int, sliceSize: Int) {
        backgroundName = name
        self.gridCalculator = GridCalculator(cellSize: sliceSize, gridCols: sliceCols, gridRows: sliceRows)
        
        self.sliceSize = CGFloat(sliceSize)
        
        blackOverlay = SKShapeNode(rect: CGRectMake(0, 0, self.scene.size.width, self.scene.size.height))
        blackOverlay?.fillColor = UIColor.blackColor()
        blackOverlay?.strokeColor = UIColor.blackColor()
        blackOverlay?.zPosition = -5
        let fadeIn = SKAction.fadeInWithDuration(0.0)
        blackOverlay?.runAction(fadeIn)
        scene.addChild(blackOverlay!)
    }
    
    func setBackgroundOffset(offset: CGPoint, angle: CGFloat) {
        
        for backgroundNode in toRemove {
            backgroundNode.removeFromParent()
            backgroundNodes.remove(backgroundNode)
        }
        
        print("setbgoffset!!!!")
        if(offset != backgroundOffset) {
            
            print("old offset \(backgroundOffset)")
            print("new offset \(offset)")
            var offsetDelta = CGPointZero
            offsetDelta.x = offset.x - backgroundOffset.x
            offsetDelta.y = offset.y - backgroundOffset.y
            print("offsetDelta \(offsetDelta)")
            
            if(backgroundName != nil && gridCalculator != nil) {
                
                let viewportRect = self.scene.visibleSpaceRect()
                print("viewPortRect: ",viewportRect)
                
                let degrees = gridCalculator!.radiansToDegrees(angle)
                print("Degrees: \(degrees)")
                
                var backgroundPosition = offset
                backgroundPosition.y += scene.size.height
                
                let bgCells: [GridCell] = gridCalculator!.getCells(backgroundPosition, anchorPoint: CGPoint(x:0,y:1), angleDeg: Int(degrees), viewRect: viewportRect)
                
                print("backgrounds: \(bgCells)")
                
                var indexes = Set<Int>()
                var previousIndexes = Set<Int>()
                
                for background in bgCells {
                    indexes.insert(background.index)
                }
                for background in previousBgCells {
                    previousIndexes.insert(background.index)
                }
                
                let removedIndexes = previousIndexes.subtract(indexes)
                let addedIndexes = indexes.subtract(previousIndexes)
                let movedIndexes = indexes.intersect(previousIndexes)
                
                for backgroundNode in backgroundNodes {
                    print("backgroundNode.name \(backgroundNode.name)")
                    let stringId = backgroundNode.name?.stringByReplacingOccurrencesOfString(backgroundName!, withString: "")
                    let index = Int(stringId!)
                    if removedIndexes.contains(index!) {
                        if hidden {
                            backgroundNode.removeFromParent()
                            backgroundNodes.remove(backgroundNode)
                        } else {
                            let moveAction = SKAction.moveBy(CGVector(dx: offsetDelta.x, dy: offsetDelta.y), duration: 0.15)
                            let rotateAction = SKAction.rotateToAngle(angle, duration: 0.15)
                            moveAction.timingMode = .EaseOut
                            rotateAction.timingMode = .EaseOut
                            backgroundNode.runAction(moveAction)
                            backgroundNode.runAction(rotateAction)
                            toRemove.insert(backgroundNode)
                        }
                    }
                    if movedIndexes.contains(index!) {
                        if hidden {
                            for background in bgCells {
                                if background.index == index {
                                    backgroundNode.position = background.rect.origin
                                    backgroundNode.zRotation = background.angle
                                }
                            }
                        } else {
                            let moveAction = SKAction.moveBy(CGVector(dx: offsetDelta.x, dy: offsetDelta.y), duration: 0.15)
                            let rotateAction = SKAction.rotateToAngle(angle, duration: 0.15)
                            moveAction.timingMode = .EaseOut
                            rotateAction.timingMode = .EaseOut
                            backgroundNode.runAction(moveAction)
                            backgroundNode.runAction(rotateAction)
                        }
                    }
                }
                
                for index in addedIndexes {
                    for background in bgCells {
                        if index == background.index {
                            let name = "\(backgroundName!)\(background.index)"
                            let node = SKSpriteNode(texture: SKTexture(imageNamed: name))
                            node.name = name
                            node.zRotation = background.angle
                            node.anchorPoint = CGPoint(x: 0, y: 0)
                            
                            var scenePoint = background.rect.origin
                            if !hidden {
                                scenePoint = background.rect.origin - offsetDelta
                                node.zRotation = backgroundAngle
                            }
                            print("Added at screen point \(scenePoint)")
                            node.position = scenePoint
                            node.size.width = sliceSize!
                            node.size.height = sliceSize!
                            
                            node.zPosition = -10
                            
                            backgroundNodes.insert(node)
                            scene.addChild(node)
                            
                            if !hidden {
                                print("Scene point after animation \(background.rect.origin)")
                                let moveAction = SKAction.moveBy(CGVector(dx: offsetDelta.x, dy: offsetDelta.y), duration: 0.15)
                                let rotateAction = SKAction.rotateToAngle(angle, duration: 0.15)
                                moveAction.timingMode = .EaseOut
                                rotateAction.timingMode = .EaseOut
                                node.runAction(moveAction)
                                node.runAction(rotateAction)
                            }
                            
                        }
                    }
                }
                
                previousBgCells = bgCells
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
                let scaleUp = SKAction.scaleTo(1.0, duration: 0.2)
                let moveEnd = SKAction.moveTo(endPosition, duration: 0.2)
                scaleUp.timingMode = .EaseOut
                moveEnd.timingMode = .EaseOut
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