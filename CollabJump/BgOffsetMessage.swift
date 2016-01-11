//
//  BgOffsetMessage.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-09.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class BgOffsetMessage: NSObject, NSSecureCoding {
    
    var offset: CGPoint
    
    init(offset: CGPoint) {
        self.offset = offset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.offset = aDecoder.decodeCGPointForKey("offset")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGPoint(offset, forKey: "offset")
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}