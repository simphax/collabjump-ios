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
    var screenSize: CGPoint
    let componentHeight: CGFloat
    let componentWidth: CGFloat
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    let deviceWidth: CGFloat
    let deviceHeight: CGFloat
    
    var componentHeightOffset: CGFloat
    var componentWidthOffset: CGFloat
    
    init(height: CGFloat, width: CGFloat, atScreen: CGPoint) {
        //Takes in the frame (We might have to call a function for this?)
        componentHeight = height
        componentWidth = width
        
        //ADD THE SCREEN SIZE ON THE SCREEN WIDTH AND SCREENHEIGHT
        deviceWidth = UIScreen.mainScreen().bounds.size.width
        deviceHeight = UIScreen.mainScreen().bounds.size.height
        
        screenSize = atScreen
        screenWidth = screenSize.x + deviceWidth
        screenHeight = screenSize.y + deviceHeight
        
        componentHeightOffset = componentHeight/2
        componentWidthOffset = componentWidth/2
        
        //TODO: Margins, so that for instance a platform component does not end up at the top of the screen.
        //I think this is done past self. DONE. Was not done.
        // rotate blocks randomize as well.
    }
    
    
    func generateAtRandomPosition () -> (randomX: CGFloat, randomY: CGFloat) {
        //generates "the most random". We might have to limit it so some part of the object don't fall outside the screen.
        //let randomPosition2 = CGRect
        let randomPosition = CGRect(x: (CGFloat(arc4random()) % screenWidth),
                                y: (CGFloat(arc4random()) % screenHeight),
                                width: componentHeight,
                                height: componentWidth)
        
        //The component is not allowed to fall outside the screen. Therefore add the offsets.
        var randomX = randomPosition.origin.x
        var randomY = randomPosition.origin.y
        
        if randomX < componentWidth {
            randomX = componentWidth
        }
        
        if  randomX < (randomX + componentWidth){
            randomX = randomX - componentWidth
        }
        
        if  randomY < componentHeight {
            randomY = componentHeight
        }
        
        if  randomY < (randomY + componentHeight){
            randomY = randomY - componentHeight
        }
        
        //print(randomX)
        //print(randomY)
        return (randomX, randomY)
        
        
        //let randomPosition = CGPointMake(CGFloat(arc4random()) % thisHeight, CGFloat(arc4random()) % thisWidth)
        //let sprite = SKSpriteNode()
        //sprite.position = randomPosition
    }
}