//
//  RandomPositionComponent.swift
//  CollabJump
//
//  Created by Alexander Yeh on 10/12/15.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class RandomPositionComponent: GKComponent {
    var screenSize: CGRect
    let componentHeight: CGFloat
    let componentWidth: CGFloat
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    
    var componentHeightOffset: CGFloat
    var componentWidthOffset: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        //Takes in the frame (We might have to call a function for this?)
        componentHeight = height
        componentWidth = width
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        componentHeightOffset = componentHeight/2
        componentWidthOffset = componentWidth/2
        
        
        
        //TODO: Margins, so that for instance a platform component does not end up at the top of the screen.
    }
    
    
    func generateAtRandomPosition () {
        //generates "the most random". We might have to limit it so some part of the object don't fall outside the screen.
        //let randomPosition2 = CGRect
        var randomPosition = CGRect(x: (CGFloat(arc4random()) % screenWidth),
                                y: (CGFloat(arc4random()) % screenHeight),
                                width: componentHeight,
                                height: componentWidth)
        
        //The component is not allowed to fall outside the screen. Therefore add the offsets.
        
        if randomPosition.origin.x < componentWidthOffset {
            randomPosition.origin.x = componentWidthOffset
        }
        if (randomPosition.origin.x + componentWidthOffset) > randomPosition.origin.x {
            randomPosition.origin.x = randomPosition.origin.x - componentWidthOffset
        }
        
        if randomPosition.origin.y < componentHeightOffset {
            randomPosition.origin.y = componentHeightOffset
        }
        if (randomPosition.origin.y + componentHeightOffset) > randomPosition.origin.y {
            randomPosition.origin.y = randomPosition.origin.y - componentHeightOffset
        }
        
        
        
        
        //let randomPosition = CGPointMake(CGFloat(arc4random()) % thisHeight, CGFloat(arc4random()) % thisWidth)
        //let sprite = SKSpriteNode()
        //sprite.position = randomPosition
    }
}