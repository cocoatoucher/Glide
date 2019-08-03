//
//  OscillatingMovementComponent.swift
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

/// Component that is used to move its entity with a simple harmonic motion.
/// Manipulates the transform position directly rather than changing the kinematics body.
public final class OscillatingMovementComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 870
    
    /// Period for the simple harmonic motion.
    public let period: TimeInterval
    
    /// Axes and speed of the movement.
    /// For example, if dx value is 0, there will be no movement on the horizontal axis.
    public let axesAndSpeed: CGVector
    
    /// Create an oscillating movement component.
    ///
    /// - Parameters:
    ///     - period: Period for the simple harmonic motion.
    ///     - axes: Axes and speed of the harmonic motion.
    public init(period: TimeInterval, axesAndSpeed: CGVector) {
        self.period = period
        self.axesAndSpeed = axesAndSpeed
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        updateProposedPosition()
    }
    
    // MARK: - Private
    
    private func updateProposedPosition() {
        guard
            let transform = transform,
            let currentTime = currentTime
            else {
                return
        }
        
        let cycles = abs(CGFloat(period)) * CGFloat(currentTime) // ft
        let sinWave = sin(2.0 * CGFloat.pi * cycles) // 2pift
        
        transform.proposedPosition = transform.initialPosition + axesAndSpeed * sinWave
    }
}
