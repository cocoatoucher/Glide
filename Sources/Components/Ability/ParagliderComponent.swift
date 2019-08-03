//
//  ParagliderComponent.swift
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

/// Component that makes an entity be affected by a lower gravity while it is
/// falling down on air.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class ParagliderComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 750
    
    /// `true` if there was paragliding in the last frame.
    public private(set) var wasParagliding: Bool = true
    
    /// Set to `true` to perform paragliding given that the other conditions are met.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public internal(set) var isParagliding: Bool = false
    
    /// `true` if paragliding can be triggered more than once while on the air.
    public private(set) var canMultiParaglide: Bool = true
    
    /// `true` if the conditions are met for jumping.
    public private(set) var canParaglide: Bool = false
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var gravity: CGFloat = 5 // m/s²
        /// Maximum vertical velocity this component's entity can have during paragliding.
        public var maximumVerticalVelocity: CGFloat = 8.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a paraglider component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = ParagliderComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performParaglidingIfNeeded()
    }
    
    // MARK: - Private
    
    private func performParaglidingIfNeeded() {
        guard
            let collider = entity?.component(ofType: ColliderComponent.self),
            let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self)
            else {
                return
        }
        
        if collider.onGround == true {
            canParaglide = true
        }
        
        if isParagliding {
            if wasParagliding == false {
                if canMultiParaglide == false {
                    canParaglide = false
                }
                kinematicsBody.velocity.dy = 0
            }
            kinematicsBody.gravityInEffect = configuration.gravity
            kinematicsBody.currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
        }
    }
}

extension ParagliderComponent: StateResettingComponent {
    public func resetStates() {
        wasParagliding = isParagliding
        
        isParagliding = false
    }
}
