//
//  EagleEntity.swift
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
import GameplayKit

class EagleEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 41, height: 21)
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        name = "Eagle"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.npc,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (10, 10),
                                                  bottomHitPointsOffsets: (10, 10))
        addComponent(colliderComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 5.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        var verticalMovementConfiguration = VerticalMovementComponent.sharedConfiguration
        verticalMovementConfiguration.acceleration = 80.0
        verticalMovementConfiguration.deceleration = 50.0
        let verticalMovementComponent = VerticalMovementComponent(movementStyle: .accelerated, configuration: verticalMovementConfiguration)
        addComponent(verticalMovementComponent)
        
        let moveComponent = SelfMoveComponent(movementAxes: .vertical)
        addComponent(moveComponent)
        
        let eagleComponent = EagleComponent()
        addComponent(eagleComponent)
        
        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = colliderSize
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "eagle_idle_%d",
                                                 numberOfFrames: 7,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        // Fall
        let fallAction = TextureAnimation.Action(textureFormat: "eagle_fall_%d",
                                                 numberOfFrames: 1,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: true)
        let fallAnimation = TextureAnimation(triggerName: "Fall",
                                             offset: .zero,
                                             size: animationSize,
                                             action: fallAction,
                                             loops: false)
        animatorComponent.addAnimation(fallAnimation)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let kinematicsBody = component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        if kinematicsBody.velocity.dy < 0 {
            component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "Fall")
        } else {
            component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "Idle")
        }
    }
    
}

class EagleComponent: GKComponent, GlideComponent {
    
    var hasDieAnimationFinished: Bool = false
    var didPlayDieAnimation: Bool = false
    
    let dieAction = SKAction.textureAnimation(textureFormat: "eagle_die_%d",
                                              numberOfFrames: 11,
                                              timePerFrame: 0.15,
                                              loops: false,
                                              isReverse: false,
                                              textureAtlas: nil,
                                              shouldGenerateNormalMaps: true)
    
    func didSkipUpdate() {
        let isDead = entity?.component(ofType: HealthComponent.self)?.isDead
        if didPlayDieAnimation == false && isDead == true {
            didPlayDieAnimation = true
            entity?.component(ofType: SpriteNodeComponent.self)?.node.removeAllActions()
            entity?.component(ofType: SpriteNodeComponent.self)?.node.run(dieAction, completion: { [weak self] in
                self?.hasDieAnimationFinished = true
            })
        }
    }
}

extension EagleComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return hasDieAnimationFinished
    }
}
