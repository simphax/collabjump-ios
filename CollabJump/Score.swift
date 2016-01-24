//
//  Score.swift
//  CollabJump
//
//  Created by Alexander Yeh on 11/01/16.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation

class Score {
    var score = 0
    func updateScore() -> (Int) {
        score++
        return score
    }
}