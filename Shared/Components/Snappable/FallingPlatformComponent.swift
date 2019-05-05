//
//  FallingPlatformComponent.swift
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

/// Component that makes an entity fall off via gravity after a specified
/// time getting touched by another entity from above.
///
/// `PlatformComponent` is required for this component to work with gravity.
public final class FallingPlatformComponent: GKComponent, GlideComponent, RespawnableEntityComponent {
    
    // MARK: - RespawnableEntityComponent
    public var respawnedEntity: ((_ numberOfRespawnsLeft: Int) -> GlideEntity)?
    public internal(set) var numberOfRespawnsLeft = Int.max
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Velocity that will be set to bouncing entity's `KinematicsBodyComponent`.
        public var delayToFallAfterTouch: TimeInterval = 0.5 // seconds
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a falling platform component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = FallingPlatformComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        if isWaitingToFall {
            timer += seconds
            if timer >= configuration.delayToFallAfterTouch {
                entity?.component(ofType: PlatformComponent.self)?.isGravityEnabled = true
                entity?.component(ofType: ColliderComponent.self)?.isEnabled = false
            }
        } else if didGetContact == true {
            isWaitingToFall = true
        }
    }
    
    public func handleNewCollision(_ collision: Contact) {
        provideContactIfNeeded(collision)
    }
    
    public func handleExistingCollision(_ collision: Contact) {
        provideContactIfNeeded(collision)
    }
    
    // MARK: - Private
    
    private var timer: TimeInterval = 0.0
    private var isWaitingToFall: Bool = false
    private var didGetContact: Bool = false
    private var getsContact: Bool = false
    
    private func provideContactIfNeeded(_ collision: Contact) {
        if collision.otherContactSides?.contains(.bottom) == true {
            getsContact = true
        }
    }
    
}

extension FallingPlatformComponent: StateResettingComponent {
    public func resetStates() {
        didGetContact = getsContact
        getsContact = false
    }
}

extension FallingPlatformComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return entity?.component(ofType: ColliderComponent.self)?.isOutsideCollisionMapBounds ?? false
    }
}
