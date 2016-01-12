//
//  RestartGameMessage.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-12.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class RestartGameMessage: NSObject, NSSecureCoding {
    
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