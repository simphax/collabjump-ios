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
    let componentHeight: CGFloat
    let componentWidth: CGFloat
    let deviceWidth: CGFloat
    let deviceHeight: CGFloat
    
    init(height: CGFloat, width: CGFloat, visibleSpace: CGRect) {
        componentHeight = height
        componentWidth = width
        
        deviceWidth = visibleSpace.width
        deviceHeight = visibleSpace.height //UIScreen.mainScreen().bounds.size.height
    }
    
    
    func generateAtRandomPosition () -> (randomX: CGFloat, randomY: CGFloat) {
        
        let randomPosition = CGRect(x: (CGFloat(arc4random()) % deviceWidth),
                                y: (CGFloat(arc4random()) % (deviceHeight - 350)),
                                width: componentWidth,
                                height: componentHeight)
       
        var randomX = randomPosition.origin.x
        var randomY = randomPosition.origin.y
        
        if randomX < componentWidth {
            randomX = componentWidth/2
        }
        
        if randomX > deviceWidth - randomX {
            randomX = deviceWidth - (componentWidth/2)
        }
        
        if  randomY < componentHeight {
            randomY += componentHeight*2
        }
        
        if  randomY > deviceHeight - randomY {
            randomY = deviceHeight - (componentHeight * 1.5)
        }
        
        print("THIS IS RANDOMX: \(randomX) THIS IS RANDOM Y: \(randomY)")
        
        return (randomX, randomY)

    }
}