//
//  SimplePlayerEntity.swift
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
import GameplayKit

class SimplePlayerEntity: GlideEntity {
    
    static let colliderSize = CGSize(width: 18, height: 30)
    let playerIndex: Int
    
    convenience init(initialNodePosition: CGPoint, playerIndex: Int) {
        self.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: SimplePlayerEntity.colliderSize / 2), playerIndex: playerIndex)
    }
    
    init(initialNodePosition: CGPoint, positionOffset: CGPoint, playerIndex: Int) {
        self.playerIndex = playerIndex
        super.init(initialNodePosition: initialNodePosition, positionOffset: positionOffset)
        name = "Player"
        tag = "Player"
    }
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        spriteNodeComponent.offset = CGPoint(x: 0, y: 3)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.player
        addComponent(spriteNodeComponent)
        
        let playerComponent = SimplePlayerComponent()
        addComponent(playerComponent)
        
        let kinematicsBodyComponent = KinematicsBodyComponent()
        addComponent(kinematicsBodyComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.player,
                                                  size: SimplePlayerEntity.colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (10, 10),
                                                  rightHitPointsOffsets: (10, 10),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
        addComponent(colliderComponent)
        
        let playableCharacterComponent = PlayableCharacterComponent(playerIndex: playerIndex)
        addComponent(playableCharacterComponent)
        
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated)
        addComponent(horizontalMovementComponent)
        
        let jumpComponent = JumpComponent()
        addComponent(jumpComponent)
        
        let snapperComponent = SnapperComponent()
        addComponent(snapperComponent)
        
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
        
        setupTextureAnimations()
    }
    
    // swiftlint:disable:next function_body_length
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.15
        
        let animationSize = CGSize(width: 50, height: 37)
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "adventurer_idle_%d_v1",
                                                 numberOfFrames: 4,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: true)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        // Run
        let runAction = TextureAnimation.Action(textureFormat: "adventurer_run_%d",
                                                numberOfFrames: 6,
                                                timePerFrame: timePerFrame,
                                                shouldGenerateNormalMaps: true)
        let runAnimation = TextureAnimation(triggerName: "Run",
                                            offset: .zero,
                                            size: animationSize,
                                            action: runAction,
                                            loops: true)
        animatorComponent.addAnimation(runAnimation)
        // Jump
        let jumpAction = TextureAnimation.Action(textureFormat: "adventurer_jump_%d",
                                                 numberOfFrames: 4,
                                                 timePerFrame: 0.05,
                                                 shouldGenerateNormalMaps: true)
        let jumpAnimation = TextureAnimation(triggerName: "Jump",
                                             offset: .zero,
                                             size: animationSize,
                                             action: jumpAction,
                                             loops: false)
        animatorComponent.addAnimation(jumpAnimation)
        // On air
        let onAirAction = TextureAnimation.Action(textureFormat: "adventurer_onair_%d",
                                                  numberOfFrames: 2,
                                                  timePerFrame: timePerFrame,
                                                  shouldGenerateNormalMaps: true)
        let onAirAnimation = TextureAnimation(triggerName: "OnAir",
                                              offset: .zero,
                                              size: animationSize,
                                              action: onAirAction,
                                              loops: true)
        animatorComponent.addAnimation(onAirAnimation)
    }
    
}

class SimplePlayerComponent: GKComponent, GlideComponent {
    
    var hasDieAnimationFinished: Bool = false
    var didPlayDieAnimation: Bool = false
    var focusOffset: CGPoint = .zero
    
    let dieAction = SKAction.textureAnimation(textureFormat: "adventurer_die_%d",
                                              numberOfFrames: 7,
                                              timePerFrame: 0.15,
                                              loops: false,
                                              isReverse: false,
                                              textureAtlas: nil,
                                              shouldGenerateNormalMaps: true)
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
        
        let collider = entity?.component(ofType: ColliderComponent.self)
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        let horizontalMovementComponent = entity?.component(ofType: HorizontalMovementComponent.self)
        
        if collider?.isOnAir == false &&
            horizontalMovementComponent?.movementDirection == .stationary &&
            jumpComponent?.jumps == false {
            textureAnimatorComponent?.enableAnimation(with: "Idle")
        }
        
        if collider?.isOnAir == false &&
            horizontalMovementComponent?.movementDirection != .stationary &&
            jumpComponent?.jumps == false {
            textureAnimatorComponent?.enableAnimation(with: "Run")
        }
        
        if jumpComponent?.jumps == true {
            textureAnimatorComponent?.enableAnimation(with: "Jump")
        }
        
        if collider?.isOnAir == true &&
            jumpComponent?.jumps == false {
            textureAnimatorComponent?.enableAnimation(with: "OnAir")
        }
    }
    
    func didSkipUpdate() {
        let isDead = entity?.component(ofType: HealthComponent.self)?.isDead
        let isColliderAlive = entity?.component(ofType: ColliderComponent.self)?.shouldEntityBeUpdated
        if didPlayDieAnimation == false && (isDead == true || isColliderAlive == false) {
            didPlayDieAnimation = true
            entity?.component(ofType: SpriteNodeComponent.self)?.node.removeAllActions()
            entity?.component(ofType: SpriteNodeComponent.self)?.node.run(dieAction, completion: { [weak self] in
                self?.hasDieAnimationFinished = true
            })
        }
    }
    
    func handleNewContact(_ contact: Contact) {
        guard let otherCategoryMask = contact.otherObject.colliderComponent?.categoryMask else {
            return
        }
        
        if otherCategoryMask == DemoCategoryMask.enemy {
            if
                contact.otherObject.colliderComponent?.entity?.component(ofType: BlinkerComponent.self) == nil ||
                contact.otherObject.colliderComponent?.entity?.component(ofType: BlinkerComponent.self)?.blinks == false
            {
                
                if entity?.component(ofType: HealthComponent.self)?.applyDamage(1) == true {
                    entity?.component(ofType: BouncerComponent.self)?.bounce(withImpactSides: contact.contactSides)
                }
            }
        } else if otherCategoryMask == DemoCategoryMask.weapon {
            if contact.otherObject.colliderComponent?.transform?.parentTransform != transform {
                entity?.component(ofType: HealthComponent.self)?.applyDamage(1)
            }
        }
    }
}

extension SimplePlayerComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return hasDieAnimationFinished
    }
}

extension SimplePlayerComponent: CameraFocusingComponent {}
