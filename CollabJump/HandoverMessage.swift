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
    var playerVelocity: CGVector
    var musicTime: Double
    
    init(playerPosition: CGPoint, playerVelocity: CGVector, musicTime: Double) {
        self.playerPosition = playerPosition
        self.playerVelocity = playerVelocity
        self.musicTime = musicTime
    }
    
    required init?(coder aDecoder: NSCoder) {
        playerPosition = aDecoder.decodeCGPointForKey("playerPosition")
        playerVelocity = aDecoder.decodeCGVectorForKey("playerVelocity")
        musicTime = aDecoder.decodeDoubleForKey("musicTime")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGPoint(playerPosition, forKey: "playerPosition")
        aCoder.encodeCGVector(playerVelocity, forKey: "playerVelocity")
        aCoder.encodeDouble(musicTime, forKey: "musicTime")
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}
