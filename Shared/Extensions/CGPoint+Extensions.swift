//
//  CGPoint+Extensions.swift
//  glide
//
//  Based on https://github.com/raywenderlich/SKTUtils
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

import CoreGraphics
import SpriteKit

public extension CGPoint {
    
    /// Creates a new CGPoint given a CGVector.
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    /// Creates a new CGPoint given a CGSize.
    init(size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
    
    /// Given an angle in radians, creates a vector of length 1.0 and returns the
    /// result as a new CGPoint. An angle of 0 is assumed to point to the right.
    init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }
    
    var glideRound: CGPoint {
        return CGPoint(x: x.glideRound, y: y.glideRound)
    }
    
    /// Adds (dx, dy) to the point.
    mutating func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        x += dx
        y += dy
        return self
    }
    
    /// Returns the length (magnitude) of the vector described by the CGPoint.
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    /// Returns the squared length of the vector described by the CGPoint.
    func lengthSquared() -> CGFloat {
        return x*x + y*y
    }
    
    /// Normalizes the vector described by the CGPoint to length 1.0 and returns
    /// the result as a new CGPoint.
    func normalized() -> CGPoint {
        let len = length()
        return len>0 ? self / len : CGPoint.zero
    }
    
    /// Normalizes the vector described by the CGPoint to length 1.0.
    mutating func normalize() -> CGPoint {
        self = normalized()
        return self
    }
    
    /// Calculates the distance between two CGPoints. Pythagoras!
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    
    /// Returns the angle in radians of the vector described by the CGPoint.
    /// The range of the angle is -π to π; an angle of 0 points to the right.
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    /// Returns a frame with given size centered around the CGPoint.
    func centeredFrame(withSize size: CGSize) -> CGRect {
        return CGRect(x: x - size.width / 2, y: y - size.height / 2, width: size.width, height: size.height)
    }
    
    // MARK: - Smooth Critical Damping
    
    /// Update current point towards a given destination point using critically damped
    /// spring model.
    /// Game Programming Gems 4, Andrew Kirmse.
    ///
    /// - Parameters:
    ///     - destination: Point to reach.
    ///     - velocity: Current velocity of update.
    ///     - deltaTime: Time passed between current and last frame.
    ///     - smoothness: Constant of smoothness.
    func smoothCD(destination: CGPoint,
                  velocity: inout CGPoint,
                  deltaTime seconds: CGFloat,
                  smoothness: CGFloat) -> CGPoint {
        let omega = 2.0 / smoothness
        let x = omega * seconds
        let exp = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
        let delta = self - destination
        let temp = (velocity + (delta * omega)) * seconds
        velocity = (velocity - (temp * omega)) * exp
        return destination + ((delta + temp) * exp)
    }
    
    /// Update current point towards a given destination point not exceeding given
    /// maximum delta.
    ///
    /// - Parameters:
    ///     - destination: Point to reach.
    ///     - maximumDelta: Maximum distance to take towards destination.
    /// Returns the current point if a negative value is provided.
    func approach(destination: CGPoint, maximumDelta: CGFloat) -> CGPoint {
        guard maximumDelta > 0 else {
            return self
        }
        let delta = destination - self
        let distance = distanceTo(destination)
        if distance == 0 {
            return self
        }
        if distance <= maximumDelta {
            return destination
        }
        let sign = delta / distance
        return self + sign * maximumDelta
    }
    
    /// Returns the angle of line starting from this point to a given point
    /// in degrees.
    func angleOfLine(to point: CGPoint) -> CGFloat {
        let delta = self - point
        return delta.angle * 180 / CGFloat.pi
    }
}

// MARK: - CGPoint & CGPoint

public func dot (left: CGPoint, right: CGPoint) -> CGFloat {
    return left.x * right.x + left.y * right.y
}

/// Adds two CGPoint values and returns the result as a new CGPoint.
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/// Increments a CGPoint with the value of another.
public func += (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left + right
}

/// Subtracts two CGPoint values and returns the result as a new CGPoint.
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/// Decrements a CGPoint with the value of another.
public func -= (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Multiplies two CGPoint values and returns the result as a new CGPoint.
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/// Multiplies a CGPoint with another.
public func *= (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left * right
}

/// Divides two CGPoint values and returns the result as a new CGPoint.
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/// Divides a CGPoint by another.
public func /= (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left / right
}

// MARK: - CGPoint & CGFloat

/// Multiplies the x and y fields of a CGPoint with the same scalar value and
/// returns the result as a new CGPoint.
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/// Multiplies the x and y fields of a CGPoint with the same scalar value.
public func *= (point: inout CGPoint, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    point = point * scalar
}

/// Divides the x and y fields of a CGPoint by the same scalar value and returns
/// the result as a new CGPoint.
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/// Divides the x and y fields of a CGPoint by the same scalar value.
public func /= (point: inout CGPoint, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    point = point / scalar
}

// MARK: - CGPoint & CGVector

/// Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/// Increments a CGPoint with the value of a CGVector.
public func += (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left + right
}

/// Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/// Decrements a CGPoint with the value of a CGVector.
public func -= (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
public func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/// Multiplies a CGPoint with a CGVector.
public func *= (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left * right
}

/// Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
public func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/// Divides a CGPoint by a CGVector.
public func /= (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left / right
}
