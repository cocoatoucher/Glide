//
//  BirdEntity.swift
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

class BirdEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 24, height: 24)
    let isWalking: Bool
    
    init(initialNodePosition: CGPoint) {
        self.isWalking = Int.random(in: 0 ..< 2) == 0
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // swiftlint:disable:next function_body_length
    override func setup() {
        name = "Bird"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        spriteNodeComponent.offset = CGPoint(x: 0, y: -3)
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.npc,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
        addComponent(colliderComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumHorizontalVelocity = CGFloat.random(in: 2.0 ..< 6.0)
        if isWalking == false {
            kinematicsBodyConfiguration.gravity = 0
        }
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        var horizontalMovementConfiguration = HorizontalMovementComponent.sharedConfiguration
        horizontalMovementConfiguration.acceleration = CGFloat.random(in: 3 ..< 7.0)
        horizontalMovementConfiguration.deceleration = CGFloat.random(in: 3 ..< 10.0)
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: horizontalMovementConfiguration)
        addComponent(horizontalMovementComponent)
        
        let moveComponent = SelfMoveComponent(movementAxes: .horizontal)
        addComponent(moveComponent)
        
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
        
        let magicAnimationEntity = DemoEntityFactory.magicAnimationEntity(at: .zero)
        
        let removeAfterIntervalComponent = RemoveAfterTimeIntervalComponent(expireTime: 5.0) { [weak self] () -> GlideEntity? in
            guard let self = self else { return nil }
            magicAnimationEntity.transform.currentPosition = self.transform.node.position
            return magicAnimationEntity
        }
        addComponent(removeAfterIntervalComponent)
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .wallContact,
                                                           axes: .horizontal,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        addComponent(selfChangeDirectionComponent)
        
        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let random = Int.random(in: 0 ..< 7)
        
        var texturePrefix: String
        if isWalking {
            texturePrefix = String(format: "bird_%d_walk", random)
        } else {
            texturePrefix = String(format: "bird_%d_fly", random)
        }
        
        let animationSize = CGSize(width: 32, height: 32)
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "\(texturePrefix)_%d",
                                                 numberOfFrames: 3,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let kinematicsBody = component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        if kinematicsBody.velocity.dx < 0 {
            transform.headingDirection = .left
        } else if kinematicsBody.velocity.dx > 0 {
            transform.headingDirection = .right
        }
    }
    
}
