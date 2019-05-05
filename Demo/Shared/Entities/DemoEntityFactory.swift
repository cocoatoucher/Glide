//
//  DemoEntityFactory.swift
//  glide Demo
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import GlideEngine
import SpriteKit

/// This is an alternative approach to implementing separate `GlideEntity` subclasses
/// for different entities.
class DemoEntityFactory {
    
    static func crateEntity(size: CGSize, bottomLeftPosition: TiledPoint, tileSize: CGSize) -> GlideEntity {
        let offset = CGPoint(x: (size / 2).width, y: (size / 2).height)
        let entity = GlideEntity(initialNodePosition: bottomLeftPosition.point(with: tileSize),
                                 positionOffset: offset)
        
        let collider = ColliderComponent(categoryMask: DemoCategoryMask.crate,
                                         size: size,
                                         offset: .zero,
                                         leftHitPointsOffsets: (5, 5),
                                         rightHitPointsOffsets: (5, 5),
                                         topHitPointsOffsets: (5, 5),
                                         bottomHitPointsOffsets: (5, 5))
        entity.addComponent(collider)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: size)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.environment
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "crate")
        entity.addComponent(spriteNodeComponent)
        
        let health = HealthComponent(maximumHealth: 1)
        entity.addComponent(health)
        
        let snappable = SnappableComponent(providesOneWayCollision: false)
        entity.addComponent(snappable)
        
        let crate = CrateComponent()
        entity.addComponent(crate)
        return entity
    }
    
    static func explosionAnimationEntity(at position: CGPoint) -> GlideEntity {
        return DemoEntityFactory.animationEntity(position: position, textureFormat: "explosion_%d", numberOfFrame: 59, offset: CGPoint(x: 0, y: 10))
    }
    
    static func magicAnimationEntity(at position: CGPoint) -> GlideEntity {
        return DemoEntityFactory.animationEntity(position: position, textureFormat: "burst_effect_%d", numberOfFrame: 49, offset: CGPoint(x: 0, y: 0))
    }
    
    private static func animationEntity(position: CGPoint, textureFormat: String, numberOfFrame: Int, offset: CGPoint) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: position)
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        spriteNodeComponent.offset = CGPoint(x: 0, y: 3)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.explosions
        entity.addComponent(spriteNodeComponent)
        
        let timePerFrame: TimeInterval = 0.03
        let animationSize = CGSize(width: 50, height: 50)
        let explodeAction = TextureAnimation.Action(textureFormat: textureFormat,
                                                    numberOfFrames: numberOfFrame,
                                                    timePerFrame: timePerFrame)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: offset,
                                             size: animationSize,
                                             action: explodeAction,
                                             loops: false)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        entity.addComponent(animatorComponent)
        
        let removeAfterTimeIntervalComponent = RemoveAfterTimeIntervalComponent(expireTime: 1.8)
        entity.addComponent(removeAfterTimeIntervalComponent)
        
        return entity
    }
}
