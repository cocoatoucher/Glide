//
//  ProjectileWeaponEntity.swift
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

class ProjectileWeaponEntity: GlideEntity {
    
    override init(initialNodePosition: CGPoint, positionOffset: CGPoint) {
        direction = .positive
        super.init(initialNodePosition: initialNodePosition, positionOffset: positionOffset)
        name = "Projectile Weapon"
    }
    
    override func setup() {
        let size = CGSize(width: 32, height: 32)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: size)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.weapons
        addComponent(spriteNodeComponent)
        
        let projectileWeaponComponent = ProjectileWeaponComponent()
        addComponent(projectileWeaponComponent)
        
        setupTextures(size: size)
    }
    
    var direction: Direction
    
    override func willUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let kinematicsBody = component(ofType: KinematicsBodyComponent.self)
        kinematicsBody?.gravityInEffect = 0.0
    }
    
    // swiftlint:disable:next function_body_length
    func setupTextures(size: CGSize) {
        let weapon0Action = TextureAnimation.Action(textureFormat: "rifle_0_%d",
                                                    numberOfFrames: 1,
                                                    timePerFrame: 1)
        let weapon0Animation = TextureAnimation(triggerName: "angle0",
                                                offset: .zero,
                                                size: size,
                                                action: weapon0Action,
                                                loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: weapon0Animation)
        addComponent(animatorComponent)
        
        let weapon45Action = TextureAnimation.Action(textureFormat: "rifle_45_%d",
                                                     numberOfFrames: 1,
                                                     timePerFrame: 0.1)
        let weapon45Animation = TextureAnimation(triggerName: "angle45",
                                                 offset: .zero,
                                                 size: size,
                                                 action: weapon45Action,
                                                 loops: true)
        animatorComponent.addAnimation(weapon45Animation)
        
        let weapon90Action = TextureAnimation.Action(textureFormat: "rifle_90_%d",
                                                     numberOfFrames: 1,
                                                     timePerFrame: 1)
        let weapon90Animation = TextureAnimation(triggerName: "angle90",
                                                 offset: .zero,
                                                 size: size,
                                                 action: weapon90Action,
                                                 loops: true)
        animatorComponent.addAnimation(weapon90Animation)
        
        let weapon135Action = TextureAnimation.Action(textureFormat: "rifle_135_%d",
                                                      numberOfFrames: 1,
                                                      timePerFrame: 1)
        let weapon135Animation = TextureAnimation(triggerName: "angle135",
                                                  offset: .zero,
                                                  size: size,
                                                  action: weapon135Action,
                                                  loops: true)
        animatorComponent.addAnimation(weapon135Animation)
        
        let weapon180Action = TextureAnimation.Action(textureFormat: "rifle_180_%d",
                                                      numberOfFrames: 1,
                                                      timePerFrame: 1)
        let weapon180Animation = TextureAnimation(triggerName: "angle180",
                                                  offset: .zero,
                                                  size: size,
                                                  action: weapon180Action,
                                                  loops: true)
        animatorComponent.addAnimation(weapon180Animation)
        
        let weapon225Action = TextureAnimation.Action(textureFormat: "rifle_225_%d",
                                                      numberOfFrames: 1,
                                                      timePerFrame: 1)
        let weapon225Animation = TextureAnimation(triggerName: "angle225",
                                                  offset: .zero,
                                                  size: size,
                                                  action: weapon225Action,
                                                  loops: true)
        animatorComponent.addAnimation(weapon225Animation)
        
        let weapon270Action = TextureAnimation.Action(textureFormat: "rifle_270_%d",
                                                      numberOfFrames: 1,
                                                      timePerFrame: 1)
        let weapon270Animation = TextureAnimation(triggerName: "angle270",
                                                  offset: .zero,
                                                  size: size,
                                                  action: weapon270Action,
                                                  loops: true)
        animatorComponent.addAnimation(weapon270Animation)
        
        let weapon315Action = TextureAnimation.Action(textureFormat: "rifle_315_%d",
                                                      numberOfFrames: 1,
                                                      timePerFrame: 1)
        let weapon315Animation = TextureAnimation(triggerName: "angle315",
                                                  offset: .zero,
                                                  size: size,
                                                  action: weapon315Action,
                                                  loops: true)
        animatorComponent.addAnimation(weapon315Animation)
    }
    
}

extension RoundedAngle {
    var projectileStartPosition: CGPoint {
        switch self {
        case .angle0:
            return CGPoint(x: 10, y: 0)
        case .angle45:
            return CGPoint(x: 5, y: 5)
        case .angle90:
            return CGPoint(x: 0, y: 10)
        case .angle135:
            return CGPoint(x: -5, y: 5)
        case .angle180:
            return CGPoint(x: -10, y: 0)
        case .angle225:
            return CGPoint(x: -5, y: -5)
        case .angle270:
            return CGPoint(x: 0, y: -10)
        case .angle315:
            return CGPoint(x: 5, y: -5)
        default:
            return .zero
        }
    }
}

class ProjectileWeaponComponent: GKComponent, GlideComponent {
    
    var weaponPosition: RoundedAngle = .angle0 {
        didSet {
            entity?.component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "angle\(weaponPosition.stringValue)")
        }
    }
    
    var shootingAngle: CGFloat {
        if transform?.headingDirection == .left {
            return weaponPosition.degrees - 180
        }
        return weaponPosition.degrees
    }
    
    var lastMousePosition: CGPoint = .zero
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        if
            let headingDirection = transform?.parentTransform?.headingDirection,
            let previousHeadingDirection = transform?.parentTransform?.previousHeadingDirection
        {
            if headingDirection != previousHeadingDirection {
                weaponPosition = weaponPosition.horizontalMirrored
            }
        }
        
        if Input.shared.inputMethod != .native {
            processInput()
        } else {
            #if os(OSX)
            let diff = Input.shared.mousePosition - lastMousePosition
            
            if diff.y < -30 {
                rotateWeaponCounterclockwise()
            } else if diff.y > 30 {
                rotateWeaponClockwise()
            }
            #endif
        }
    }
    
    #if os(OSX)
    private func rotateWeaponClockwise() {
        weaponPosition = weaponPosition.nextClockwise
        lastMousePosition = Input.shared.mousePosition
    }
    
    private func rotateWeaponCounterclockwise() {
        weaponPosition = weaponPosition.nextCounterclockwise
        lastMousePosition = Input.shared.mousePosition
    }
    #endif
    
    private func processInput() {
        let horizontalProfile = "Player1_Horizontal_Alt"
        let verticalProfile = "Player1_Vertical_Alt"
        
        guard
            abs(Input.shared.profileValue(horizontalProfile)) > 0.2 ||
            abs(Input.shared.profileValue(verticalProfile)) > 0.2
        else {
            return
        }
        
        if
            Input.shared.profileValue(horizontalProfile) > 0.2 &&
            abs(Input.shared.profileValue(verticalProfile)) <= 0.2
        {
            weaponPosition = .angle0
        } else if
            Input.shared.profileValue(horizontalProfile) > 0.2 &&
            Input.shared.profileValue(verticalProfile) > 0.2
        {
            weaponPosition = .angle45
        } else if
            abs(Input.shared.profileValue(horizontalProfile)) <= 0.2 &&
            Input.shared.profileValue(verticalProfile) > 0.2
        {
            weaponPosition = .angle90
        } else if
            Input.shared.profileValue(horizontalProfile) < -0.2 &&
            Input.shared.profileValue(verticalProfile) > 0.2
        {
            weaponPosition = .angle135
        } else if
            Input.shared.profileValue(horizontalProfile) < -0.2 &&
            abs(Input.shared.profileValue(verticalProfile)) <= 0.2
        {
            weaponPosition = .angle180
        } else if
            Input.shared.profileValue(horizontalProfile) < -0.2 &&
            Input.shared.profileValue(verticalProfile) < -0.2
        {
            weaponPosition = .angle225
        } else if
            abs(Input.shared.profileValue(horizontalProfile)) <= 0.2 &&
            Input.shared.profileValue(verticalProfile) < -0.2
        {
            weaponPosition = .angle270
        } else if
            Input.shared.profileValue(horizontalProfile) > 0.2 &&
            Input.shared.profileValue(verticalProfile) < -0.2
        {
            weaponPosition = .angle315
        }
    }
}
