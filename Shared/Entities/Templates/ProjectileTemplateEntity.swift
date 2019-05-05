//
//  ProjectileTemplateEntity.swift
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

/// Template entity to be used a base class for projectile entities
/// which are initialized and added to scene by `ProjectileShooterComponent`.
/// An example is a bullet of a pistol.
open class ProjectileTemplateEntity: GlideEntity {
    
    /// Initial shooting angle value in degrees.
    public let shootingAngle: CGFloat
    
    /// Initial velocity in m/s.
    public let initialVelocity: CGVector
    
    // MARK: - Initialize
    
    /// Create a projectile template entity.
    ///
    ///
    /// - Parameters:
    ///     - initialNodePosition: Initial position for the transform of the entity.
    ///     - shootingAngle: Angle for the direction of shooting in degrees.
    public required init(initialNodePosition: CGPoint,
                         initialVelocity: CGVector,
                         shootingAngle: CGFloat) {
        self.shootingAngle = shootingAngle
        self.initialVelocity = initialVelocity
        super.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
