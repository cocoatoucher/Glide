//
//  HorizontalMovementComponent.swift
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

/// Component that is used to move its entity's kinematics body in the horizontal axis
/// with the given movement style.
///
/// Required components: `KinematicsBodyComponent`.
public final class HorizontalMovementComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 900
    
    public let movementStyle: MovementStyle
    
    public private(set) var previousMovementDirection: Direction = .stationary
    public var movementDirection: Direction = .stationary
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Velocity value if the `movementStyle` is `fixedVelocity`.
        public var fixedVelocity: CGFloat = 10 // m/s²
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
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(movementStyle: MovementStyle,
                configuration: Configuration = HorizontalMovementComponent.sharedConfiguration) {
        self.movementStyle = movementStyle
        self.configuration = configuration
        self.movementDirection = .positive
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        updateKinematicsBody()
    }
    
    // MARK: - Private
    
    private func updateKinematicsBody() {
        guard let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        switch movementStyle {
        case .fixedVelocity:
            switch movementDirection {
            case .negative:
                kinematicsBodyComponent.velocity.dx = -abs(configuration.fixedVelocity)
            case .positive:
                kinematicsBodyComponent.velocity.dx = abs(configuration.fixedVelocity)
            case .stationary:
                kinematicsBodyComponent.velocity.dx = 0.0
            }
        case .accelerated:
            kinematicsBodyComponent.horizontalDeceleration = abs(configuration.deceleration)
            
            switch movementDirection {
            case .negative:
                kinematicsBodyComponent.horizontalAcceleration = -abs(configuration.acceleration)
            case .positive:
                kinematicsBodyComponent.horizontalAcceleration = abs(configuration.acceleration)
            case .stationary:
                kinematicsBodyComponent.horizontalAcceleration = 0
            }
        }
    }
}

extension HorizontalMovementComponent: StateResettingComponent {
    public func resetStates() {
        previousMovementDirection = movementDirection
        
        movementDirection = .stationary
    }
}
