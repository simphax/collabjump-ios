//
//  HandoverMessage.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-16.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class HandoverMessage: NSObject, NSSecureCoding {
    
    var playerPosition: CGPoint
    
    init(playerPosition: CGPoint) {
        self.playerPosition = playerPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        playerPosition = aDecoder.decodeCGPointForKey("playerPosition")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGPoint(playerPosition, forKey: "playerPosition")
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}
