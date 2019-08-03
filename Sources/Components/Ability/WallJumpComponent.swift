//
//  WallJumpComponent.swift
//  glide
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

import GameplayKit

/// Component that makes an entity gain horizontal and vertical velocity
/// from collision collider tiles which support wall jumping.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class WallJumpComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 780
    
    /// `true` if there was jumping in the last frame.
    public private(set) var jumped: Bool = false
    
    /// Set to `true` to perform a jump given that the other conditions are met.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public var jumps: Bool = false
    
    /// `true` if the conditions are met for jumping.
    public var canJump: Bool {
        guard let collider = entity?.component(ofType: ColliderComponent.self) else {
            return false
        }
        return collider.pushesRightJumpWall || collider.pushesLeftJumpWall
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var wallJumpHorizontalVelocity: CGFloat = 10.0 // m/s²
        public var wallJumpVerticalVelocity: CGFloat = 22.0 // m/s²
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a wall jump component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = WallJumpComponent.sharedConfiguration) {
        self.configuration = configuration
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performWallJumpIfNeeded()
    }
    
    // MARK: - Private
    
    private func performWallJumpIfNeeded() {
        guard
            let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self),
            let colliderComponent = entity?.component(ofType: ColliderComponent.self)
            else {
                return
        }
        
        if jumps {
            
            colliderComponent.finishGroundContact()
            
            if colliderComponent.pushesLeftJumpWall {
                kinematicsBodyComponent.velocity.dx = abs(configuration.wallJumpHorizontalVelocity)
                kinematicsBodyComponent.velocity.dy = abs(configuration.wallJumpVerticalVelocity)
            } else if colliderComponent.pushesRightJumpWall {
                kinematicsBodyComponent.velocity.dx = -abs(configuration.wallJumpHorizontalVelocity)
                kinematicsBodyComponent.velocity.dy = abs(configuration.wallJumpVerticalVelocity)
            }
            
            kinematicsBodyComponent.resetMaximumVerticalVelocity()
        }
    }
}

extension WallJumpComponent: StateResettingComponent {
    public func resetStates() {
        jumped = jumps
        
        jumps = false
    }
}
