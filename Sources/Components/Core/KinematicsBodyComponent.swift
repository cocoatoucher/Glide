//
//  KinematicsBodyComponent.swift
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

/// Component that controls the entity's velocity and its transform's translation
/// based on that velocity
/// Collider component is not essential for this component to work.
public final class KinematicsBodyComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 960
    
    /// Gravity will be reset to the value defined in configuration in every update cycle
    /// since that is a more common scenario.
    /// Update gravity in your custom components in every cycle to keep it at a desired value.
    public var gravityInEffect: CGFloat
    /// Value of this property can be changed across update cycles.
    public var currentMaximumVerticalVelocity: CGFloat
    /// Will be reset at the end of each cycle.
    public var verticalAcceleration: CGFloat = 0
    /// Will be reset at the end of each cycle.
    public var verticalDeceleration: CGFloat = 0
    /// Will be reset at the end of each cycle.
    public var horizontalAcceleration: CGFloat = 0
    /// Will be reset at the end of each cycle.
    public var horizontalDeceleration: CGFloat = 0
    
    public private(set) var previousVelocity: CGVector = .zero
    /// Value of this property is kept across update cycles.
    public var velocity: CGVector = .zero
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var gravity: CGFloat = 37 // m/s²
        /// Maximum vertical velocity on y axis on both negative and positive directions.
        public var maximumVerticalVelocity: CGFloat = 18 // m/s
        /// Maximum horizontal velocity on x axis on both negative and positive directions.
        public var maximumHorizontalVelocity: CGFloat = 8 // m/s
        /// Convenience for being able to use metric system values in the configuration.
        public var metersToScreenPoints: CGFloat = 27.0 // 1m = 27points
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a kinematics body component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = KinematicsBodyComponent.sharedConfiguration) {
        self.configuration = configuration
        self.gravityInEffect = configuration.gravity
        self.currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        updateVerticalProposedPosition(seconds)
        updateHorizontalProposedPosition(seconds)
    }
    
    public func resetMaximumVerticalVelocity() {
        currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
    }
    
    // MARK: - Private
    
    /// Current vertical acceleration in effect as a combination of gravity,
    /// acceleration and deceleration.
    private var verticalAccelerationInEffect: CGFloat = 0
    
    /// Current horizontal acceleration in effect as a combination of assigned
    /// acceleration and deceleration.
    private var horizontalAccelerationInEffect: CGFloat = 0
    
    private func updateVerticalVelocityForColliderIfNeeded() {
        guard let collider = entity?.component(ofType: ColliderComponent.self) else {
            return
        }
        
        if collider.onGround || collider.onSlope {
            velocity.dy = fmax(0, velocity.dy)
        }
        if collider.atCeiling {
            velocity.dy = fmin(0, velocity.dy)
        }
        if
            (collider.didPushLeftJumpWall == false && collider.pushesLeftJumpWall) ||
            (collider.didPushRightJumpWall == false && collider.pushesRightJumpWall)
        {
            velocity.dy = fmax(0, velocity.dy)
        }
    }
    
    private func updateVerticalProposedPosition(_ elapsedTime: TimeInterval) {
        updateVerticalVelocityForColliderIfNeeded()
        
        if entity?.component(ofType: ColliderComponent.self)?.onSlope == true {
            return
        }
        
        if verticalAcceleration == 0 && velocity.dy != 0 {
            if velocity.dy > 0 {
                verticalAccelerationInEffect = -verticalDeceleration
            } else {
                verticalAccelerationInEffect = verticalDeceleration
            }
        } else {
            verticalAccelerationInEffect = verticalAcceleration
        }
        
        var newVerticalVelocity = velocity.dy
        let totalAcceleration = verticalAccelerationInEffect + -abs(gravityInEffect)
        
        if let collider = entity?.component(ofType: ColliderComponent.self) {
            if collider.onSlope == false {
                newVerticalVelocity = velocity.dy + totalAcceleration * CGFloat(elapsedTime)
            }
        } else {
            newVerticalVelocity = velocity.dy + totalAcceleration * CGFloat(elapsedTime)
        }
        
        if gravityInEffect == 0 {
            if newVerticalVelocity * velocity.dy < 0 {
                velocity.dy = 0
            } else {
                velocity.dy = newVerticalVelocity
            }
        } else {
            velocity.dy = newVerticalVelocity
        }
        
        if velocity.dy < 0 {
            velocity.dy = fmax(-abs(currentMaximumVerticalVelocity), velocity.dy)
        } else if velocity.dy > 0 {
            velocity.dy = fmin(abs(currentMaximumVerticalVelocity), velocity.dy)
        }
        
        let amountYRaw = (velocity.dy * CGFloat(elapsedTime)) + (0.5 * totalAcceleration * pow(CGFloat(elapsedTime), 2))
        let amountY = amountYRaw * configuration.metersToScreenPoints
        transform?.proposedPosition.y += amountY
    }
    
    private func updateHorizontalVelocityForColliderIfNeeded() {
        guard let collider = entity?.component(ofType: ColliderComponent.self) else {
            return
        }
        
        if collider.pushesLeftWall == true {
            velocity.dx = fmax(0, velocity.dx)
        }
        if collider.pushesRightWall == true {
            velocity.dx = fmin(0, velocity.dx)
        }
    }
    
    private func updateHorizontalProposedPosition(_ elapsedTime: TimeInterval) {
        updateHorizontalVelocityForColliderIfNeeded()
        
        guard let transform = transform else {
            return
        }
        
        if horizontalAcceleration == 0 && velocity.dx != 0 {
            if velocity.dx > 0 {
                horizontalAccelerationInEffect = -horizontalDeceleration
            } else {
                horizontalAccelerationInEffect = horizontalDeceleration
            }
        } else {
            horizontalAccelerationInEffect = horizontalAcceleration
        }
        
        let newHorizontalVelocity = velocity.dx + horizontalAccelerationInEffect * CGFloat(elapsedTime)
        
        if newHorizontalVelocity * velocity.dx < 0 {
            velocity.dx = 0
        } else {
            velocity.dx = newHorizontalVelocity
        }
        
        if horizontalAccelerationInEffect < 0 {
            velocity.dx = fmax(-configuration.maximumHorizontalVelocity, velocity.dx)
        } else if horizontalAccelerationInEffect > 0 {
            velocity.dx = fmin(configuration.maximumHorizontalVelocity, velocity.dx)
        }
        
        let amounXRaw = velocity.dx * CGFloat(elapsedTime)
        let amountX = (amounXRaw * configuration.metersToScreenPoints)
        transform.proposedPosition.x += amountX
        
        if let collider = entity?.component(ofType: ColliderComponent.self) {
            if collider.onSlope {
                let proposedPositionOnSlope = self.proposedPositionOnSlope(amountX,
                                                                           currentPosition: transform.currentPosition,
                                                                           currentProposedPosition: transform.proposedPosition,
                                                                           collider: collider)
                if let proposedPositionOnSlope = proposedPositionOnSlope {
                    transform.proposedPosition = proposedPositionOnSlope
                }
            }
        }
    }
    
    private func proposedPositionOnSlope(_ horizontalTranslation: CGFloat,
                                         currentPosition: CGPoint,
                                         currentProposedPosition: CGPoint,
                                         collider: ColliderComponent) -> CGPoint? {
        
        guard let scene = scene else {
            return nil
        }
        guard let slopeContext = collider.slopeContext else {
            return nil
        }
        
        let hypotenusanTranslation = abs(horizontalTranslation)
        let yChange = sqrt(pow(hypotenusanTranslation, 2) / (pow(CGFloat(slopeContext.inclination), 2) + 1))
        let translationSign: CGFloat = (currentProposedPosition.x >= currentPosition.x) ? 1 : -1
        let inverseInclination: CGFloat = slopeContext.isInverse ? -1 : 1
        
        let xAmount = (yChange * CGFloat(slopeContext.inclination)) * translationSign
        let yAmount = (yChange * translationSign)
        
        var distanceTaken = CGVector(dx: xAmount, dy: yAmount)
        
        var finalProposedPosition: CGPoint = .zero
        finalProposedPosition.x = currentPosition.x + xAmount
        finalProposedPosition.y = (currentPosition.y + yAmount * inverseInclination) - 1
        
        if let distanceAndLerpPositionOnSlope = distanceTakenOnSlope(translationSign,
                                                                     currentPosition: currentPosition,
                                                                     collider: collider,
                                                                     slopeContext: slopeContext,
                                                                     finalProposedPosition: finalProposedPosition,
                                                                     hypotenusanTranslation: hypotenusanTranslation,
                                                                     tileSize: scene.tileSize) {
            distanceTaken = distanceAndLerpPositionOnSlope.distance
            transform?.intermediaryProposedPositions = [distanceAndLerpPositionOnSlope.intermediaryPosition]
        }
        
        if translationSign > 0 {
            finalProposedPosition.x = currentPosition.x + ceil(distanceTaken.dx)
            finalProposedPosition.y = (currentPosition.y + ceil(distanceTaken.dy) * inverseInclination) - 1
        } else {
            finalProposedPosition.x = currentPosition.x + floor(distanceTaken.dx)
            finalProposedPosition.y = (currentPosition.y + floor(distanceTaken.dy) * inverseInclination) - 1
        }
        return finalProposedPosition
    }
    
    private func distanceTakenOnSlope(_ translationSign: CGFloat,
                                      currentPosition: CGPoint,
                                      collider: ColliderComponent,
                                      slopeContext: SlopeContext,
                                      finalProposedPosition: CGPoint,
                                      hypotenusanTranslation: CGFloat,
                                      tileSize: CGSize) -> (intermediaryPosition: CGPoint, distance: CGVector)? {
        
        if translationSign > 0 && slopeContext.isInverse == false {
            
            let rightmostTileFrame = slopeContext.rightmostTilePosition.singleTiledRect(with: tileSize)
            let bottomRight = collider.bottomHitPoints(at: finalProposedPosition).1
            if bottomRight.maxX > rightmostTileFrame.maxX {
                let colliderPositionY = collider.size.height / 2 - collider.offset.y
                let lerpPositionY = rightmostTileFrame.maxY + colliderPositionY
                var lerpPosition = CGPoint(x: rightmostTileFrame.maxX,
                                           y: lerpPositionY)
                lerpPosition.x -= collider.size.width / 2 - collider.bottomHitPointsOffsets.right - 1
                
                let xAmountToCorner = lerpPosition.x - currentPosition.x
                let yAmountToCorner = lerpPosition.y - currentPosition.y
                
                let hypoten = sqrt(pow(xAmountToCorner, 2) + pow(yAmountToCorner, 2))
                let xAmount = (xAmountToCorner + (hypotenusanTranslation - hypoten))
                
                return (intermediaryPosition: lerpPosition, distance: CGVector(dx: xAmount, dy: yAmountToCorner))
            }
        } else if translationSign < 0 && slopeContext.isInverse {
            
            let leftmostTileFrame = slopeContext.leftmostTilePosition.singleTiledRect(with: tileSize)
            let bottomLeft = collider.bottomHitPoints(at: finalProposedPosition).0
            if bottomLeft.minX < leftmostTileFrame.minX {
                let colliderPositionY = collider.size.height / 2 - collider.offset.y
                var lerpPosition = CGPoint(x: leftmostTileFrame.minX,
                                           y: leftmostTileFrame.maxY + colliderPositionY)
                lerpPosition.x += collider.size.width / 2 - collider.bottomHitPointsOffsets.left
                
                let xAmountToCorner = lerpPosition.x - currentPosition.x
                let yAmountToCorner = lerpPosition.y - currentPosition.y
                
                let hypoten = sqrt(pow(xAmountToCorner, 2) + pow(yAmountToCorner, 2))
                let xAmount = (xAmountToCorner + ((hypotenusanTranslation - hypoten) * translationSign))
                
                return (intermediaryPosition: lerpPosition, distance: CGVector(dx: xAmount, dy: yAmountToCorner))
            }
        }
        
        return nil
    }
}

extension KinematicsBodyComponent: StateResettingComponent {
    public func resetStates() {
        previousVelocity = velocity
        gravityInEffect = configuration.gravity
        currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
        horizontalAcceleration = 0
        horizontalAccelerationInEffect = 0
        verticalAcceleration = 0
        verticalAccelerationInEffect = 0
    }
}
