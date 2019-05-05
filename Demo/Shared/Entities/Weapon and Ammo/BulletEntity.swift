//
//  BulletEntity.swift
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

class BulletEntity: ProjectileTemplateEntity {
    
    let colliderSize = CGSize(width: 10, height: 8)
    
    required init(initialNodePosition: CGPoint, initialVelocity: CGVector, shootingAngle: CGFloat) {
        super.init(initialNodePosition: initialNodePosition, initialVelocity: initialVelocity, shootingAngle: shootingAngle)
        name = "Bullet"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 12, height: 12))
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.weapons
        addComponent(spriteNodeComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 1.0)
        addComponent(healthComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 30.0
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 30.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        let baseVelocity: CGFloat = 12.0
        if let roundedAngle = RoundedAngle(degrees: shootingAngle) {
            spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "bullet_\(roundedAngle.stringValue)")
            kinematicsBodyComponent.velocity = roundedAngle.direction * baseVelocity + CGVector(dx: initialVelocity.dx, dy: 0)
        }
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.projectile,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (2, 2),
                                                  rightHitPointsOffsets: (2, 2),
                                                  topHitPointsOffsets: (3, 3),
                                                  bottomHitPointsOffsets: (3, 3))
        addComponent(colliderComponent)
        
        var horizontalMovementConfiguration = HorizontalMovementComponent.sharedConfiguration
        horizontalMovementConfiguration.acceleration = 20.0
        horizontalMovementConfiguration.deceleration = 0.0
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: horizontalMovementConfiguration)
        addComponent(horizontalMovementComponent)
        
        let bulletComponent = BulletComponent()
        addComponent(bulletComponent)
    }
    
}

class BulletComponent: GKComponent, GlideComponent {
    
    var didPlayDieAnimation: Bool = false
    let explosionAnimationEntity = DemoEntityFactory.explosionAnimationEntity(at: .zero)
    
    func willUpdate(deltaTime seconds: TimeInterval) {
        entity?.component(ofType: KinematicsBodyComponent.self)?.gravityInEffect = 0
    }
    
    func handleNewContact(_ contact: Contact) {
        destroyIfNeeded(contact)
    }
    
    func handleExistingContact(_ contact: Contact) {
        destroyIfNeeded(contact)
    }
    
    func destroyIfNeeded(_ contact: Contact) {
        if case .colliderTile(let isEmptyTile) = contact.otherObject, isEmptyTile == false {
            entity?.component(ofType: HealthComponent.self)?.applyDamage(1.0)
        }
    }
    
    func didSkipUpdate() {
        guard didPlayDieAnimation == false else {
            return
        }
        
        didPlayDieAnimation = true
        if let transform = transform {
            explosionAnimationEntity.transform.currentPosition = transform.node.position
            scene?.addEntity(explosionAnimationEntity)
        }
    }
}

extension BulletComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return didPlayDieAnimation
    }
}
