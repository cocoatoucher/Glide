//
//  JetpackOperatorComponent.swift
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

/// Component that makes an entity be able to gain positive vertical speed
/// while on air.
///
/// Required components:
/// - `KinematicsBodyComponent`
public final class JetpackOperatorComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 740
    
    /// `true` if the component was operating jetpack in the last frame.
    public private(set) var wasOperatingJetpack: Bool = false
    
    /// Set to `true` to start operating jetpack given that the other conditions are met.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public internal(set) var isOperatingJetpack: Bool = false
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var gravity: CGFloat = 10.0 // m/s²
        /// Acceleration value to apply while jetpacking is active.
        public var verticalAcceleration: CGFloat = 30.0 // m/s
        /// Maximum vertical velocity this component's entity can have during paragliding.
        public var maximumVerticalVelocity: CGFloat = 8.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a jetpack operator component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = JetpackOperatorComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        startOperatingJetpackIfNeeded()
    }
    
    // MARK: - Private
    
    private func startOperatingJetpackIfNeeded() {
        guard
            let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self)
            else {
                return
        }
        
        if isOperatingJetpack {
            kinematicsBodyComponent.gravityInEffect = configuration.gravity
            kinematicsBodyComponent.verticalAcceleration = configuration.verticalAcceleration
            kinematicsBodyComponent.currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
        }
    }
}

extension JetpackOperatorComponent: StateResettingComponent {
    public func resetStates() {
        wasOperatingJetpack = isOperatingJetpack
    }
}
