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
    let marginLeft: CGFloat = 50
    let marginRight: CGFloat = 50
    let marginTop: CGFloat = 200
    let marginBottom: CGFloat = 50
    
    init(height: CGFloat, width: CGFloat, visibleSpace: CGRect) {
        componentHeight = height
        componentWidth = width
        
        deviceWidth = visibleSpace.width
        deviceHeight = visibleSpace.height
    }
    
    
    func generateAtRandomPosition () -> CGPoint {
        
        let randomX = (CGFloat(arc4random()) % (deviceWidth - componentWidth - marginLeft - marginRight)) + marginLeft + componentWidth/2
        let randomY = (CGFloat(arc4random()) % (deviceHeight - componentHeight - marginTop - marginBottom)) + marginBottom + componentHeight/2

        print("THIS IS RANDOMX: \(randomX) THIS IS RANDOM Y: \(randomY)")
        
        return CGPointMake(randomX,randomY)

    }
}