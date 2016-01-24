//
//  GameOverMessage.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-09.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverMessage: NSObject, NSSecureCoding {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
}