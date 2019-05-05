//
//  JumpComponent.swift
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

/// Component that makes an entity gain a momentary vertical speed while on ground.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class JumpComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 790
    
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
        let isSnapping = entity?.component(ofType: SnapperComponent.self)?.isSnapping == true
        let canJumpFromCorner = configuration.isCornerJumpsEnabled && collider.onCornerJump
        let onGround = collider.onGround || collider.onSlope || canJumpFromCorner || isSnapping
        return onGround
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var jumpingVelocity: CGFloat = 13.0 // m/s
        public var fasterVerticalVelocityDiff: CGFloat = 1.0 // m/s
        public var serialJumpThreshold: TimeInterval = 0.2 // s
        public var isCornerJumpsEnabled: Bool = true
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a jump component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = JumpComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performJumpIfNeeded()
    }
    
    // MARK: - Private
    
    private func performJumpIfNeeded() {
        guard
            let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self),
            let collider = entity?.component(ofType: ColliderComponent.self)
            else {
                return
        }
        
        guard jumped == false && jumps else {
            return
        }
        
        collider.finishGroundContact()
        
        kinematicsBody.velocity.dy = configuration.jumpingVelocity
        if abs(kinematicsBody.velocity.dx) > 0 {
            kinematicsBody.velocity.dy += configuration.fasterVerticalVelocityDiff
        }
    }
}

extension JumpComponent: StateResettingComponent {
    public func resetStates() {
        jumped = jumps
        
        jumps = false
    }
}
