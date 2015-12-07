//
//  GameScene.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-01.
//  Copyright (c) 2015 Simon Nilsson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var entityManager: EntityManager!
    
    override func didMoveToView(view: SKView) {
        
        entityManager = EntityManager(scene: self)
        
        let player: Player = Player()
        
        if let spriteComponent = player.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        }
        
        entityManager.add(player)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        self.updateDelta(delta)
    }
    
    func updateDelta(deltaTime: CFTimeInterval) {
        entityManager.update(deltaTime)
    }
}
