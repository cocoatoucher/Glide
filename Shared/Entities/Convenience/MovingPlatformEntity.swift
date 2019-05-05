//
//  MovingPlatformEntity.swift
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

import Foundation
import CoreGraphics

/// Custom convenience entity for quickly creating platform entities common
/// to side scroller games.
/// This entity doesn't do anything special but brings different components
/// together to create platform entities in a convenient way.
public class MovingPlatformEntity: GlideEntity {
    let colliderSize: CGSize
    let movementAxes: MovementAxes
    let changeDirectionProfiles: [SelfChangeDirectionComponent.Profile]
    let providesOneWayCollision: Bool
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var acceleration: CGFloat = 10 // m/s²
        public var deceleration: CGFloat = 10 // m/s²
        public var maximumVerticalVelocity: CGFloat = 5.0 // m/s
        public var maximumHorizontalVelocity: CGFloat = 3.0 // m/s
        public var circularMovementRadius: CGFloat = 80.0 // points
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a moving platform entity.
    ///
    /// - Parameters:
    ///     - bottomLeftPosition: Initial bottom left position for the entity's
    /// collider frame.
    ///     - colliderSize: Size of the collider component of the entity.
    ///     - movementAxes: Axes to move for the entity's `SelfMoveComponent`.
    ///     - changeDirectionProfiles: Profiles for the entity's
    /// `SelfChangeDirectionComponent`.
    ///     - providesOneWayCollision: Profiles for the entity's
    /// `SelfChangeDirectionComponent`.
    ///     - tileSize: Tile size of the scene.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(bottomLeftPosition: TiledPoint,
                colliderSize: CGSize,
                movementAxes: MovementAxes,
                changeDirectionProfiles: [SelfChangeDirectionComponent.Profile],
                providesOneWayCollision: Bool,
                tileSize: CGSize,
                configuration: Configuration = MovingPlatformEntity.sharedConfiguration) {
        self.colliderSize = colliderSize
        self.movementAxes = movementAxes
        self.changeDirectionProfiles = changeDirectionProfiles
        self.providesOneWayCollision = providesOneWayCollision
        self.configuration = configuration
        let offsetSize = colliderSize / 2
        let offset = CGPoint(x: offsetSize.width, y: offsetSize.height)
        super.init(initialNodePosition: bottomLeftPosition.point(with: tileSize), positionOffset: offset)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        addComponent(colliderComponent)
        
        let platformComponent = PlatformComponent()
        addComponent(platformComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: providesOneWayCollision)
        addComponent(snappableComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = configuration.maximumVerticalVelocity
        kinematicsBodyConfiguration.maximumHorizontalVelocity = configuration.maximumHorizontalVelocity
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        if movementAxes.contains(.vertical) {
            setupVerticalMovement()
        }
        if movementAxes.contains(.horizontal) {
            setupHorizontalMovement()
        }
        if movementAxes.contains(.circular) {
            setupCircularMovement()
        }
        
        let moveComponent = SelfMoveComponent(movementAxes: movementAxes)
        addComponent(moveComponent)
        
        let changeDirectionComponent = SelfChangeDirectionComponent()
        changeDirectionProfiles.forEach { changeDirectionComponent.profiles.append($0) }
        addComponent(changeDirectionComponent)
    }
    
    // MARK: - Private
    
    private func setupVerticalMovement() {
        let movementStyle: MovementStyle = .accelerated
        var configuration = VerticalMovementComponent.Configuration()
        configuration.acceleration = self.configuration.acceleration
        configuration.deceleration = self.configuration.deceleration
        let verticalMovementComponent = VerticalMovementComponent(movementStyle: movementStyle, configuration: configuration)
        addComponent(verticalMovementComponent)
    }
    
    private func setupHorizontalMovement() {
        let movementStyle: MovementStyle = .accelerated
        var configuration = HorizontalMovementComponent.Configuration()
        configuration.acceleration = self.configuration.acceleration
        configuration.deceleration = self.configuration.deceleration
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: movementStyle, configuration: configuration)
        addComponent(horizontalMovementComponent)
    }
    
    private func setupCircularMovement() {
        let movementStyle: MovementStyle = .accelerated
        var configuration = CircularMovementComponent.Configuration()
        configuration.acceleration = self.configuration.acceleration
        configuration.deceleration = self.configuration.deceleration
        let circularMovementComponent = CircularMovementComponent(movementStyle: movementStyle,
                                                                  radius: self.configuration.circularMovementRadius,
                                                                  configuration: configuration)
        addComponent(circularMovementComponent)
    }
}
