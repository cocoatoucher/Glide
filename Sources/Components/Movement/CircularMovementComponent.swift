//
//  CircularMovementComponent.swift
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

/// Component that is used to move its entity's kinematics body in both axes
/// in a circular manner. Uses kinematics body's horizontal velocity and acceleration
/// as a basis for the circular speed.
/// Overrides the horizontal properties of kinematics body and also directly manipulates
/// the position of the transform.
///
/// Required components: `KinematicsBodyComponent`.
public final class CircularMovementComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 880
    
    public let movementStyle: MovementStyle
    
    /// Radius of the circle to move the entity over
    public let radius: CGFloat
    
    public private(set) var previousMovementDirection: CircularDirection = .stationary
    public var movementDirection: CircularDirection = .stationary
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Velocity value if the `movementStyle` is `fixedVelocity`.
        public var fixedVelocity: CGFloat = 20 // m/s²
        /// Acceleration value if the `movementStyle` is `accelerated`.
        public var acceleration: CGFloat = 40 // m/s²
        /// Deceleration value if the `movementStyle` is `accelerated`.
        public var deceleration: CGFloat = 40 // m/s²
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a horizontal movement component.
    ///
    /// - Parameters:
    ///     - movementStyle: Type of movement.
    ///     - radius: Radius of the circle to move the entity over.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(movementStyle: MovementStyle,
                radius: CGFloat,
                configuration: Configuration = CircularMovementComponent.sharedConfiguration) {
        self.movementStyle = movementStyle
        self.radius = radius
        self.configuration = configuration
        self.movementDirection = .clockwise
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        updateKinematicsBody()
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        updateProposedPosition(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    /// Current angle of the entity.
    var currentAngle: CGFloat = 0.0
    
    private func updateKinematicsBody() {
        guard let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        switch movementStyle {
        case .fixedVelocity:
            switch movementDirection {
            case .clockwise:
                kinematicsBodyComponent.velocity.dx = -abs(configuration.fixedVelocity)
            case .counterClockwise:
                kinematicsBodyComponent.velocity.dx = abs(configuration.fixedVelocity)
            case .stationary:
                kinematicsBodyComponent.velocity.dx = 0.0
            }
        case .accelerated:
            kinematicsBodyComponent.horizontalDeceleration = abs(configuration.deceleration)
            
            switch movementDirection {
            case .clockwise:
                kinematicsBodyComponent.horizontalAcceleration = -abs(configuration.acceleration)
            case .counterClockwise:
                kinematicsBodyComponent.horizontalAcceleration = abs(configuration.acceleration)
            case .stationary:
                kinematicsBodyComponent.horizontalAcceleration = 0
            }
        }
    }
    
    private func updateProposedPosition(deltaTime seconds: TimeInterval) {
        guard
            let transform = transform,
            let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self)
            else {
                return
        }
        
        currentAngle += kinematicsBodyComponent.velocity.dx * CGFloat(seconds)
        
        transform.proposedPosition.x = transform.initialPosition.x + radius * cos(currentAngle)
        transform.proposedPosition.y = transform.initialPosition.y + radius * sin(currentAngle)
    }
}

extension CircularMovementComponent: StateResettingComponent {
    public func resetStates() {
        previousMovementDirection = movementDirection
        
        movementDirection = .stationary
    }
}
