//
//  SpiderEntity.swift
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
import CoreGraphics
import Foundation

class SpiderEntity: GlideEntity {
    
    let spriteSize = CGSize(width: 16, height: 16)
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: spriteSize / 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        name = "Spider"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: spriteSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.npc,
                                                  size: spriteSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (3, 3),
                                                  rightHitPointsOffsets: (3, 3),
                                                  topHitPointsOffsets: (3, 3),
                                                  bottomHitPointsOffsets: (3, 3))
        addComponent(colliderComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 3.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        var horizontalMovementConfiguration = HorizontalMovementComponent.sharedConfiguration
        horizontalMovementConfiguration.acceleration = 3.0
        horizontalMovementConfiguration.deceleration = 5.0
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: horizontalMovementConfiguration)
        addComponent(horizontalMovementComponent)
        
        let moveComponent = SelfMoveComponent(movementAxes: .horizontal)
        addComponent(moveComponent)
        
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
        
        setupTextureAnimations()
    }
    
    // swiftlint:disable:next function_body_length
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = spriteSize
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "spider_idle_%d",
                                                 numberOfFrames: 5,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        // Walk
        let walkAction = TextureAnimation.Action(textureFormat: "spider_walk_%d",
                                                 numberOfFrames: 6,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let walkAnimation = TextureAnimation(triggerName: "Walk",
                                             offset: .zero,
                                             size: animationSize,
                                             action: walkAction,
                                             loops: true)
        animatorComponent.addAnimation(walkAnimation)
        
        // React
        let reactAction = TextureAnimation.Action(textureFormat: "spider_react_%d",
                                                  numberOfFrames: 9,
                                                  timePerFrame: timePerFrame,
                                                  shouldGenerateNormalMaps: false)
        let reactAnimation = TextureAnimation(triggerName: "React",
                                              offset: .zero,
                                              size: animationSize,
                                              action: reactAction,
                                              loops: false)
        animatorComponent.addAnimation(reactAnimation)
        
        // Reacted state
        let reactedAction = TextureAnimation.Action(textureFormat: "spider_react_8",
                                                    numberOfFrames: 1,
                                                    timePerFrame: timePerFrame,
                                                    shouldGenerateNormalMaps: false)
        let reactedAnimation = TextureAnimation(triggerName: "ReactedState",
                                                offset: .zero,
                                                size: animationSize,
                                                action: reactedAction,
                                                loops: true)
        animatorComponent.addAnimation(reactedAnimation)
    }
    
    override func didUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let textureAnimator = component(ofType: TextureAnimatorComponent.self)
        
        guard let entityObserver = component(ofType: EntityObserverComponent.self) else {
            return
        }
        
        if entityObserver.didObserveEntities.isEmpty && entityObserver.observesEntities.isEmpty == false {
            textureAnimator?.enableAnimation(with: "React")
        } else if entityObserver.didObserveEntities.isEmpty == false && entityObserver.observesEntities.isEmpty == false {
            textureAnimator?.enableAnimation(with: "ReactedState")
        } else {
            guard let kinematicsBody = component(ofType: KinematicsBodyComponent.self) else {
                return
            }
            
            if kinematicsBody.velocity.dx < 0 {
                transform.headingDirection = .left
                textureAnimator?.enableAnimation(with: "Walk")
            } else if kinematicsBody.velocity.dx > 0 {
                transform.headingDirection = .right
                textureAnimator?.enableAnimation(with: "Walk")
            } else {
                textureAnimator?.enableAnimation(with: "Idle")
            }
        }
    }
    
}
