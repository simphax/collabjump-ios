//
//  EntityManager.swift
//  CollabJump
//
//  Created by Simon Nilsson on 2015-12-07.
//  Copyright © 2015 Simon Nilsson. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    let scene: SKScene
    var toRemove = Set<GKEntity>()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let physicsSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        return [physicsSystem, animationSystem]
    }()
    
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        for componentSystem in componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    func remove(entity: GKEntity?) {
        if let entity = entity {
            if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
                spriteNode.removeFromParent()
            }
            
            entities.remove(entity)
            toRemove.insert(entity)
        }
    }
    
    func update(deltaTime: CFTimeInterval) {
        // 1
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
        
        // 2
        for curRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponentWithEntity(curRemove)
            }
        }
        toRemove.removeAll()
    }
    
    func getPlayer() -> GKEntity? {
        for entity in entities {
            if let entity = entity as? Player {
                return entity
            }
        }
        return nil
    }
    func getPlatform() -> GKEntity? {
        for entity in entities {
            if let entity = entity as? Platform {
                return entity
            }
        }
        return nil
    }
    
}