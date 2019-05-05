//
//  SelfChangeDirectionComponent.swift
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

/// Component that makes a self moving entity change its movement direction based on
/// preset conditions.
///
/// Required components:
/// - `SelfMoveComponent` with appropriate axes depending on the given profiles
/// - `ColliderComponent` depending on the given profiles
/// - `KinematicsBodyComponent` depending on the given profiles
public final class SelfChangeDirectionComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 590
    
    /// Configurations that include information about conditions of changing direction
    /// for this component.
    public var profiles: [Profile] = []
    
    // MARK: - Private
    
    /// Profile that the component is currently using to change direction.
    private var desiredProfile: Profile?
    
    /// Direction that the component is currently trying to achieve.
    private var desiredDirection: Direction?
    
    /// `true` if the `desiredProfile` has a positive `delay` value for changing direction.
    private var isChangingDirectionWithDelay: Bool {
        return (desiredProfile?.delay ?? 0) > 0
    }
    
    /// Value to keep track of change direction profile `delay`.
    private var timeElapsedSinceStartOfDirectionChange: TimeInterval = 0.0
    
    /// Value to keep track of the time passed for a profile with `timeInterval` condition.
    private var timeIntervalProfileTimer: TimeInterval = 0
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        if isChangingDirectionWithDelay {
            timeElapsedSinceStartOfDirectionChange += seconds
            if timeElapsedSinceStartOfDirectionChange >= desiredProfile?.delay ?? 0 {
                performChangeDirection()
            }
            return
        }
        
        changeDirectionIfNeeded(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var skipsChecksAfterPerformChangeDirection: Bool = false
    
    private func changeDirectionIfNeeded(deltaTime seconds: TimeInterval) {
        guard let scene = scene else {
            return
        }
        
        for profile in profiles {
            switch profile.condition {
            case .wallContact:
                performWallContactDirectionChange(profile: profile)
            case .gapContact:
                performGapContactDirectionChange(profile: profile)
            case let .timeInterval(value):
                performTimeIntervalDirectionChange(profile: profile, timeInterval: value, timePassed: seconds)
            case let .patrolArea(rect):
                performPatrolAreaDirectionChange(patrolArea: rect, profile: profile)
            case let .tiledPatrolArea(rect):
                performPatrolAreaDirectionChange(patrolArea: rect.rect(with: scene.tileSize), profile: profile)
            case let .displacement(displacementFactor):
                performDisplacementDirectionChange(profile: profile, displacementFactor: displacementFactor)
            }
        }
    }
    
    private func startChangeDirection(for profile: Profile, to direction: Direction? = nil) {
        desiredProfile = profile
        if let direction = direction {
            desiredDirection = direction
        } else {
            let moveComponent = entity?.component(ofType: SelfMoveComponent.self)
            let currentDirection = moveComponent?.movementDirection(for: profile.axes) ?? .stationary
            desiredDirection = !currentDirection
        }
        
        if profile.delay > 0 {
            entity?.component(ofType: SelfMoveComponent.self)?.setMovementDirection(.stationary, for: profile.axes)
        } else {
            skipsChecksAfterPerformChangeDirection = true
            performChangeDirection()
        }
    }
    
    private func performChangeDirection() {
        if let axes = desiredProfile?.axes {
            let moveComponent = entity?.component(ofType: SelfMoveComponent.self)
            moveComponent?.setMovementDirection(desiredDirection ?? .stationary, for: axes)
        }
        desiredProfile = nil
        desiredDirection = nil
        timeElapsedSinceStartOfDirectionChange = 0.0
    }
    
    private func performWallContactDirectionChange(profile: Profile) {
        guard skipsChecksAfterPerformChangeDirection == false else {
            skipsChecksAfterPerformChangeDirection = false
            return
        }
        let collider = entity?.component(ofType: ColliderComponent.self)
        if collider?.pushesLeftWall == true || collider?.pushesRightWall == true {
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile)
        }
    }
    
    private func performGapContactDirectionChange(profile: Profile) {
        guard skipsChecksAfterPerformChangeDirection == false else {
            skipsChecksAfterPerformChangeDirection = false
            return
        }
        let collider = entity?.component(ofType: ColliderComponent.self)
        if collider?.wasOnGap == false && collider?.onGap == true {
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile)
        }
    }
    
    private func performTimeIntervalDirectionChange(profile: Profile,
                                                    timeInterval: TimeInterval,
                                                    timePassed: TimeInterval) {
        timeIntervalProfileTimer += timePassed
        if timeIntervalProfileTimer >= timeInterval {
            timeIntervalProfileTimer = 0
            
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile)
        }
    }
    
    private func performPatrolAreaDirectionChange(patrolArea rect: CGRect, profile: Profile) {
        if profile.axes.contains(.horizontal) {
            if changeHorizontalDirectionIfNeeded(leftBoundary: rect.minX,
                                                 rightBoundary: rect.maxX,
                                                 profile: profile) {
                return
            }
        }
        
        if profile.axes.contains(.vertical) {
            if changeVerticalDirectionIfNeeded(downwardBoundary: rect.minY,
                                               upwardBoundary: rect.maxY,
                                               profile: profile) {
                return
            }
        }
    }
    
    private func performDisplacementDirectionChange(profile: Profile,
                                                    displacementFactor: CGFloat) {
        guard let transform = entity?.component(ofType: TransformNodeComponent.self) else {
            return
        }
        
        if profile.axes.contains(.horizontal) {
            if processHorizontalDisplacementDirectionChange(transform: transform,
                                                            profile: profile,
                                                            displacementFactor: displacementFactor) {
                return
            }
        }
        
        if profile.axes.contains(.vertical) {
            if processVerticalDisplacementDirectionChange(transform: transform,
                                                          profile: profile,
                                                          displacementFactor: displacementFactor) {
                return
            }
        }
        
        if profile.axes.contains(.circular) {
            if processCircularDisplacementDirectionChange(displacementFactor: displacementFactor,
                                                          profile: profile) {
                return
            }
        }
    }
    
    private func processHorizontalDisplacementDirectionChange(transform: TransformNodeComponent,
                                                              profile: Profile,
                                                              displacementFactor: CGFloat) -> Bool {
        if displacementFactor > 0 {
            if changeHorizontalDirectionIfNeeded(leftBoundary: transform.initialPosition.x,
                                                 rightBoundary: transform.initialPosition.x + displacementFactor,
                                                 profile: profile) {
                return true
            }
        } else {
            if changeHorizontalDirectionIfNeeded(leftBoundary: transform.initialPosition.x + displacementFactor,
                                                 rightBoundary: transform.initialPosition.x,
                                                 profile: profile) {
                return true
            }
        }
        return false
    }
    
    private func processVerticalDisplacementDirectionChange(transform: TransformNodeComponent,
                                                            profile: Profile,
                                                            displacementFactor: CGFloat) -> Bool {
        if displacementFactor > 0 {
            if changeVerticalDirectionIfNeeded(downwardBoundary: transform.initialPosition.y,
                                               upwardBoundary: transform.initialPosition.y + displacementFactor,
                                               profile: profile) {
                return true
            }
        } else {
            if changeVerticalDirectionIfNeeded(downwardBoundary: transform.initialPosition.y + displacementFactor,
                                               upwardBoundary: transform.initialPosition.y,
                                               profile: profile) {
                return true
            }
        }
        return false
    }
    
    private func processCircularDisplacementDirectionChange(displacementFactor: CGFloat,
                                                            profile: Profile) -> Bool {
        guard let circularMovement = entity?.component(ofType: CircularMovementComponent.self) else {
            return false
        }
        
        let displacementInRadians = displacementFactor * CGFloat.pi / 180
        if displacementInRadians > 0 {
            if changeCircularDirectionIfNeeded(circularMovement: circularMovement,
                                               lowerAngle: displacementInRadians,
                                               upperAngle: 0,
                                               profile: profile) {
                return true
            }
        } else {
            if changeCircularDirectionIfNeeded(circularMovement: circularMovement,
                                               lowerAngle: 0,
                                               upperAngle: displacementInRadians,
                                               profile: profile) {
                return true
            }
        }
        return false
    }
    
    private func changeHorizontalDirectionIfNeeded(leftBoundary: CGFloat,
                                                   rightBoundary: CGFloat,
                                                   profile: Profile) -> Bool {
        guard let transform = transform else {
            return false
        }
        
        let horizontalMovement = entity?.component(ofType: HorizontalMovementComponent.self)
        if transform.proposedPosition.x >= rightBoundary {
            if case .negative? = horizontalMovement?.movementDirection {
                return false
            }
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                transform.proposedPosition.x = rightBoundary
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile, to: .negative)
            return true
        } else if transform.proposedPosition.x <= leftBoundary {
            if case .positive? = horizontalMovement?.movementDirection {
                return false
            }
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                transform.proposedPosition.x = leftBoundary
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile, to: .positive)
            return true
        }
        return false
    }
    
    private func changeVerticalDirectionIfNeeded(downwardBoundary: CGFloat,
                                                 upwardBoundary: CGFloat,
                                                 profile: Profile) -> Bool {
        guard let transform = transform else {
            return false
        }
        
        let verticalMovement = entity?.component(ofType: VerticalMovementComponent.self)
        
        if transform.proposedPosition.y >= upwardBoundary {
            if case .negative? = verticalMovement?.movementDirection {
                return false
            }
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                transform.proposedPosition.y = upwardBoundary
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dy = 0
            }
            startChangeDirection(for: profile, to: .negative)
            return true
        } else if transform.proposedPosition.y <= downwardBoundary {
            if case .positive? = verticalMovement?.movementDirection {
                return false
            }
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                transform.proposedPosition.y = downwardBoundary
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dy = 0
            }
            startChangeDirection(for: profile, to: .positive)
            return true
        }
        
        return false
    }
    
    private func changeCircularDirectionIfNeeded(circularMovement: CircularMovementComponent,
                                                 lowerAngle: CGFloat,
                                                 upperAngle: CGFloat,
                                                 profile: Profile) -> Bool {
        if circularMovement.currentAngle >= lowerAngle {
            if case .clockwise = circularMovement.movementDirection {
                return false
            }
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                circularMovement.currentAngle = lowerAngle
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile, to: .negative)
            return true
        } else if circularMovement.currentAngle <= upperAngle {
            if case .counterClockwise = circularMovement.movementDirection {
                return false
            }
            if profile.shouldKinematicsBodyStopOnDirectionChange {
                circularMovement.currentAngle = upperAngle
                entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
            }
            startChangeDirection(for: profile, to: .positive)
            return true
        }
        
        return false
    }
    
}

extension SelfChangeDirectionComponent {
    /// Condition variants for changing direction.
    public enum Condition {
        /// Change direction if collider hits walls.
        /// `ColliderComponent`and `ColliderTileHolderComponent` are required for this condition.
        case wallContact
        /// Change direction if collider contacts gaps on the collision tile map.
        /// `ColliderComponent`and `ColliderTileHolderComponent` are required for this condition.
        case gapContact
        /// Change direction after a given time.
        case timeInterval(TimeInterval)
        /// Change direction after a given distance in screen points.
        case displacement(CGFloat)
        /// Change direction when boundaries of a given patrol area is contacted.
        /// Origin of transform's node is checked against the patrol area boundaries.
        /// There should be enough space outside the boundaries and any obstacles
        /// for this condition to work.
        case patrolArea(CGRect)
        /// Change direction when boundaries of a given patrol area is contacted.
        case tiledPatrolArea(TiledRect)
    }
}

extension SelfChangeDirectionComponent {
    /// Structure that keeps additional information about changing direction.
    public struct Profile {
        let condition: Condition
        let axes: MovementAxes
        let delay: TimeInterval
        let shouldKinematicsBodyStopOnDirectionChange: Bool
        
        // MARK: - Initialize
        
        /// Create a profile for change direction component.
        ///
        /// - Parameters:
        ///     - condition: Condition for changing direction.
        ///     - axes: Axes to change direction on.
        ///     - delay: Seconds to wait before changing direction
        ///     - shouldKinematicsBodyStopOnDirectionChange: `true` if the velocity of `KinematicsBodyComponent`. Set this to `true` for best results with `timeInterval`
        /// and `gapContact` conditions. Greater acceleration and deceleration values should
        /// be used for best results when this value is set to `true`.
        /// should be set to zero on the relative axes when the change direction happens.
        public init(condition: Condition,
                    axes: MovementAxes,
                    delay: TimeInterval,
                    shouldKinematicsBodyStopOnDirectionChange: Bool) {
            self.condition = condition
            self.axes = axes
            self.delay = delay
            self.shouldKinematicsBodyStopOnDirectionChange = shouldKinematicsBodyStopOnDirectionChange
        }
    }
}
