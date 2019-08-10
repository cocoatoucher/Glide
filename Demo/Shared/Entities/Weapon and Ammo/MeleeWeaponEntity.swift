//
//  MeleeWeaponEntity.swift
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

class MeleeWeaponEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 10, height: 10)
    let playerIndex: Int
    
    init(initialNodePosition: CGPoint, playerIndex: Int) {
        self.playerIndex = playerIndex
        self.direction = .positive
        super.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
        name = "MeleeWeapon"
    }
    
    override func setup() {
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 20.0
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 10.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.weapon,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (3, 3),
                                                  rightHitPointsOffsets: (3, 3),
                                                  topHitPointsOffsets: (3, 3),
                                                  bottomHitPointsOffsets: (3, 3))
        addComponent(colliderComponent)
        
        let meleeWeaponComponent = MeleeWeaponComponent(playerIndex: playerIndex)
        addComponent(meleeWeaponComponent)
    }
    
    var direction: Direction
    
    override func willUpdateComponents(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let kinematicsBody = component(ofType: KinematicsBodyComponent.self)
        kinematicsBody?.gravityInEffect = 0.0
    }
    
}

class MeleeWeaponComponent: GKComponent, GlideComponent {
    
    public var attacks: Bool = false
    public var isAttacking: Bool = false
    
    let playerIndex: Int
    
    init(playerIndex: Int) {
        self.playerIndex = playerIndex
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        if Input.shared.isButtonPressed("Player\(playerIndex + 1)_Shoot") {
            attacks = true

            let bezierPath = BezierPath()
            
            if let headingDirection = transform?.parentTransform?.headingDirection {
                // These bezier paths are generated in PaintCode app.
                switch headingDirection {
                case .left:
                    bezierPath.move(to: CGPoint(x: 18.5, y: -17.5))
                    bezierPath.addCurve(to: CGPoint(x: 16.5, y: -15.5), controlPoint1: CGPoint(x: 18.5, y: -17.5), controlPoint2: CGPoint(x: 18, y: -16))
                    bezierPath.addCurve(to: CGPoint(x: -9.5, y: -12.5), controlPoint1: CGPoint(x: 10.89, y: -13.8), controlPoint2: CGPoint(x: 1.5, y: -15.5))
                    bezierPath.addCurve(to: CGPoint(x: -9.5, y: 16.5), controlPoint1: CGPoint(x: -23.58, y: -8.66), controlPoint2: CGPoint(x: -29.5, y: 11.5))
                    bezierPath.addCurve(to: CGPoint(x: 7.5, y: 3.5), controlPoint1: CGPoint(x: 0.53, y: 19.01), controlPoint2: CGPoint(x: 10.5, y: 10.5))
                case .right:
                    bezierPath.move(to: CGPoint(x: -18.5, y: -17.5))
                    bezierPath.addCurve(to: CGPoint(x: -16.5, y: -15.5), controlPoint1: CGPoint(x: -18.5, y: -17.5), controlPoint2: CGPoint(x: -18, y: -16))
                    bezierPath.addCurve(to: CGPoint(x: 9.5, y: -12.5), controlPoint1: CGPoint(x: -10.89, y: -13.8), controlPoint2: CGPoint(x: -1.5, y: -15.5))
                    bezierPath.addCurve(to: CGPoint(x: 9.5, y: 16.5), controlPoint1: CGPoint(x: 23.58, y: -8.66), controlPoint2: CGPoint(x: 29.5, y: 11.5))
                    bezierPath.addCurve(to: CGPoint(x: -7.5, y: 3.5), controlPoint1: CGPoint(x: -0.53, y: 19.01), controlPoint2: CGPoint(x: -10.5, y: 10.5))
                }
            }
            
            entity?.component(ofType: ColliderComponent.self)?.isEnabled = true
            let action = SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: false, duration: 0.5)
            transform?.runDisplacementAction(action)
        } else if transform?.isRunningDisplacementAction != true {
            entity?.component(ofType: ColliderComponent.self)?.isEnabled = false
            transform?.proposedPosition = .zero
        } else {
            entity?.component(ofType: ColliderComponent.self)?.isEnabled = true
        }
    }
}

extension MeleeWeaponComponent: StateResettingComponent {
    func resetStates() {
        attacks = false
    }
}

#if os(OSX)
extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                fatalError("Not handled bezier path type")
            }
        }
        
        return path
    }
}
#endif
