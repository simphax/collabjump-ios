//
//  BgOffsetMessage.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-09.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit
import ScreenLayout

class BgOffsetMessage: NSObject, NSSecureCoding {
    
    var offset: CGPoint
    var peer: MCPeerID
    
    init(offset: CGPoint, peer: MCPeerID) {
        self.offset = offset
        self.peer = peer
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.offset = aDecoder.decodeCGPointForKey("offset")
        self.peer = aDecoder.decodeObjectForKey("peer") as! MCPeerID
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGPoint(offset, forKey: "offset")
        aCoder.encodeObject(peer, forKey: "peer")
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}