//
//  GrenadeEntity.swift
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

class GrenadeEntity: ProjectileTemplateEntity {
    
    let colliderSize = CGSize(width: 14, height: 14)
    
    required init(initialNodePosition: CGPoint, initialVelocity: CGVector, shootingAngle: CGFloat) {
        super.init(initialNodePosition: initialNodePosition, initialVelocity: initialVelocity, shootingAngle: shootingAngle)
        name = "Grenade"
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 12, height: 12))
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.weapons
        addComponent(spriteNodeComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 3.0)
        addComponent(healthComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 20.0
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 50.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        let baseVelocity: CGFloat = 10.0
        if let roundedAngle = RoundedAngle(degrees: shootingAngle) {
            
            spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "grenade_\(roundedAngle.grenadeAngleTextureString)")
            kinematicsBodyComponent.velocity = roundedAngle.direction * baseVelocity + CGVector(dx: initialVelocity.dx, dy: 0)
        }
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.projectile,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
        addComponent(colliderComponent)
        
        var horizontalMovementConfiguration = HorizontalMovementComponent.sharedConfiguration
        horizontalMovementConfiguration.acceleration = 10.0
        horizontalMovementConfiguration.deceleration = 0.0
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: horizontalMovementConfiguration)
        addComponent(horizontalMovementComponent)
        
        let grenadeComponent = GrenadeComponent()
        addComponent(grenadeComponent)
        
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
    }
}

extension RoundedAngle {
    var grenadeAngleTextureString: String {
        switch self {
        case .angle0, .angle180:
            return "0"
        case .angle45, .angle135, .angle225, .angle315:
            return "45"
        case .angle90, .angle270:
            return "90"
        case .other:
            return ""
        }
    }
}

class GrenadeComponent: GKComponent, GlideComponent {
    
    var bouncingVelocity: CGVector?
    var postContactVelocity: CGVector?
    var didPlayDieAnimation: Bool = false
    let explosionAnimationEntity = DemoEntityFactory.explosionAnimationEntity(at: .zero)
    
    override func update(deltaTime seconds: TimeInterval) {
        if let bouncingVelocity = bouncingVelocity {
            entity?.component(ofType: KinematicsBodyComponent.self)?.velocity = bouncingVelocity
        }
    }
    
    func handleNewCollision(_ contact: Contact) {
        entity?.component(ofType: HealthComponent.self)?.applyDamage(1.0)
        guard entity?.component(ofType: HealthComponent.self)?.isDead == false else {
            return
        }
        checkContactForBouncing(contact)
    }
    
    func handleExistingCollision(_ contact: Contact) {
        guard entity?.component(ofType: HealthComponent.self)?.isDead == false else {
            return
        }
        checkContactForBouncing(contact)
    }
    
    func checkContactForBouncing(_ contact: Contact) {
        guard let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        var postContactVelocity: CGVector = .zero
        
        if contact.contactSides.contains(.bottom) {
            postContactVelocity.dy = 10.0
            if kinematicsBody.velocity.dx > 0 {
                postContactVelocity.dx = 10.0
            } else {
                postContactVelocity.dx = -10.0
            }
        } else if contact.contactSides.contains(.top) {
            postContactVelocity.dy = -10.0
            if kinematicsBody.velocity.dx > 0 {
                postContactVelocity.dx = 10.0
            } else {
                postContactVelocity.dx = -10.0
            }
        } else if contact.contactSides.contains(.left) {
            postContactVelocity.dx = 10.0
            if kinematicsBody.velocity.dy > 0 {
                postContactVelocity.dy = 10.0
            } else {
                postContactVelocity.dy = -10.0
            }
        } else {
            postContactVelocity.dx = -10.0
            if kinematicsBody.velocity.dy > 0 {
                postContactVelocity.dy = 10.0
            } else {
                postContactVelocity.dy = -10.0
            }
        }
        
        self.postContactVelocity = postContactVelocity
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

extension GrenadeComponent: StateResettingComponent {
    func resetStates() {
        bouncingVelocity = postContactVelocity
        postContactVelocity = nil
    }
}

extension GrenadeComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return didPlayDieAnimation
    }
}
