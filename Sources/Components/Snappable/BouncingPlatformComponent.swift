//
//  BouncingPlatformComponent.swift
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

/// Component that makes an entity bounce other entities upwards that touch it
/// from above.
///
/// `PlatformComponent` is still required for the entity to carry the properties
/// of a platform if that is desired.
/// Entity which is actually bouncing should have a `KinematicsBodyComponent`.
public final class BouncingPlatformComponent: GKComponent, GlideComponent {
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Value that will be added to bouncing entity's `KinematicsBodyComponent`
        /// vertical velocity.
        public var bouncingVelocity: CGFloat = 50.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a bouncing platform component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = BouncingPlatformComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func handleNewCollision(_ collision: Contact) {
        bounceIfNeeded(collision)
    }
    
    public func handleExistingCollision(_ collision: Contact) {
        bounceIfNeeded(collision)
    }
    
    // MARK: - Private
    
    private func bounceIfNeeded(_ collision: Contact) {
        let other = collision.otherObject.colliderComponent?.entity
        if collision.otherContactSides?.contains(.bottom) == true {
            other?.component(ofType: KinematicsBodyComponent.self)?.velocity.dy += configuration.bouncingVelocity
        }
    }
}
