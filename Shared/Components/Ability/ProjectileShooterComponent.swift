//
//  ProjectileShooterComponent.swift
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

/// Component that makes an entity be able to shoot projectile entities
/// with the given entity template.
public final class ProjectileShooterComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 730
    
    /// Entity template that will be initialized at the time of shooting.
    public var projectileTemplate: ProjectileTemplateEntity.Type
    
    /// `true` if there was shooting in the last frame.
    public private(set) var didShoot: Bool = false
    
    /// Set to `true` to shoot a projectile.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public var shoots: Bool = false
    
    /// Closure that is called right before initializing the projectile entity template
    /// which provides initial position, initial velocity and shooting angle for the entity.
    public let projectilePropertiesCallback: () -> ProjectileShootingProperties?
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Seconds to wait between sequential shootings.
        public var restTimeBetweenShootings: TimeInterval = 0.8 // seconds
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a projectile shooter component.
    ///
    /// - Parameters:
    ///     - projectileTemplate: Template entity to initialize as the projectile entity.
    ///     - projectilePropertiesCallback: Closure that is called right before initializing
    /// the projectile entity template which provides initial position, initial velocity and
    /// shooting angle for the entity.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(projectileTemplate: ProjectileTemplateEntity.Type,
                projectilePropertiesCallback: @escaping () -> ProjectileShootingProperties?,
                configuration: Configuration = ProjectileShooterComponent.sharedConfiguration) {
        self.projectileTemplate = projectileTemplate
        self.projectilePropertiesCallback = projectilePropertiesCallback
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        shootIfNeeded()
    }
    
    public func willBeRemovedFromEntity() {
        prepareForReuse()
    }
    
    public func entityWillBeRemovedFromScene() {
        prepareForReuse()
    }
    
    // MARK: - Private
    
    private var lastShootTime: TimeInterval = 0.0
    
    private func shootIfNeeded() {
        guard shoots else {
            lastShootTime = 0
            return
        }
        guard let currentTime = currentTime else {
            return
        }
        if lastShootTime > 0 {
            guard currentTime - lastShootTime >= configuration.restTimeBetweenShootings else {
                return
            }
        }
        
        if let projectileProperties = projectilePropertiesCallback() {
            lastShootTime = currentTime
            let initialPosition = projectileProperties.position
            let initialVelocity = projectileProperties.velocity
            let shootingAngle = projectileProperties.sourceAngle
            let projectile = projectileTemplate.init(initialNodePosition: initialPosition, initialVelocity: initialVelocity, shootingAngle: shootingAngle)
            scene?.addEntity(projectile)
        }
    }
    
    private func prepareForReuse() {
        lastShootTime = 0
        shoots = false
    }
}

extension ProjectileShooterComponent: StateResettingComponent {
    public func resetStates() {
        didShoot = shoots
        
        shoots = false
    }
}
