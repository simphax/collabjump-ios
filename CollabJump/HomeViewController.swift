//
//  HomeViewController.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2016-01-07.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier! == "startGame") {
            if let gameViewController = segue.destinationViewController as? GameViewController {
                gameViewController.hostingGame = true
            }
        }
    }
}