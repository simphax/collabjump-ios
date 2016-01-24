//
//  ScoreMessage.swift
//  CollabJump
//
//  Created by Alexander Yeh on 12/01/16.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreMessage: NSObject, NSSecureCoding {
    
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