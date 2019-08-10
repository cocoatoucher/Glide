//
//  MagicianEntity.swift
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

class MagicianEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 24, height: 28)
    var couldShoot: Bool = false
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    override func setup() {
        name = "Magician"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.npc,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (10, 10),
                                                  rightHitPointsOffsets: (10, 10),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
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
        
        setupShooterComponents()
        
        setupTextureAnimations()
    }
    
    func setupShooterComponents() {
        let shootOnObserve = SelfShootOnObserveComponent(entityTagsToShoot: ["Player"])
        addComponent(shootOnObserve)
        
        let projectileShooterComponent = ProjectileShooterComponent(projectileTemplate: BulletEntity.self, projectilePropertiesCallback: { [weak self, weak shootOnObserve] in
            
            guard let self = self else { return nil }
            guard let shootsAtEntity = shootOnObserve?.shootsAtEntity else { return nil }
            guard let scene = self.scene else { return nil }
            
            let angle = self.transform.currentPosition.angleOfLine(to: shootsAtEntity.transform.currentPosition)
            
            if angle > -90 && angle < 90 {
                self.transform.headingDirection = .left
            } else {
                self.transform.headingDirection = .right
            }
            
            guard angle < 0 else {
                return nil
            }
            
            self.couldShoot = true
            
            let properties = ProjectileShootingProperties(position: self.transform.node.convert(.zero, to: scene),
                                                          sourceAngle: angle)
            return properties
        })
        addComponent(projectileShooterComponent)
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = CGSize(width: 64, height: 64)
        let animationOffset = CGPoint(x: 0, y: 2)
        
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "shooter_idle_%d",
                                                 numberOfFrames: 12,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: animationOffset,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        // Walk
        let walkAction = TextureAnimation.Action(textureFormat: "shooter_walk_%d",
                                                 numberOfFrames: 12,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let walkAnimation = TextureAnimation(triggerName: "Walk",
                                             offset: animationOffset,
                                             size: animationSize,
                                             action: walkAction,
                                             loops: true)
        animatorComponent.addAnimation(walkAnimation)
        
        // Shoot
        let attackAction = TextureAnimation.Action(textureFormat: "shooter_attack_%d",
                                                   numberOfFrames: 12,
                                                   timePerFrame: 0.05,
                                                   shouldGenerateNormalMaps: false)
        let attackAnimation = TextureAnimation(triggerName: "Attack",
                                               offset: animationOffset,
                                               size: animationSize,
                                               action: attackAction,
                                               loops: false)
        attackAnimation.addTriggerToInterruptNonLoopingAnimation("Attack")
        
        animatorComponent.addAnimation(attackAnimation)
    }
    
    override func didUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let textureAnimator = component(ofType: TextureAnimatorComponent.self)
        if component(ofType: ProjectileShooterComponent.self)?.shoots == true {
            if couldShoot {
                textureAnimator?.enableAnimation(with: "Attack")
            } else {
                textureAnimator?.enableAnimation(with: "Idle")
            }
            return
        } else if component(ofType: SelfSpawnEntitiesComponent.self)?.didSpawn == true {
            textureAnimator?.enableAnimation(with: "Attack")
            return
        }
        
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
    
    override func resetStates(currentTime: TimeInterval, deltaTime: TimeInterval) {
        couldShoot = false
    }
    
}
