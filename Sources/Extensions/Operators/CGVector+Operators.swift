//
//  CGVector+Operators.swift
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

/// Adds two CGVector values and returns the result as a new CGVector.
public func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

/// Increments a CGVector with the value of another.
public func += (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left + right
}

/// Subtracts two CGVector values and returns the result as a new CGVector.
public func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

/// Decrements a CGVector with the value of another.
public func -= (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Multiplies two CGVector values and returns the result as a new CGVector.
public func * (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}

/// Multiplies a CGVector with another.
public func *= (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left * right
}

/// Divides two CGVector values and returns the result as a new CGVector.
public func / (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

/// Divides a CGVector by another.
public func /= (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left / right
}

// MARK: - CGVector & CGFloat

/// Multiplies the x and y fields of a CGVector with the same scalar value and
/// returns the result as a new CGVector.
public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

/// Multiplies the x and y fields of a CGVector with the same scalar value.
public func *= (vector: inout CGVector, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    vector = vector * scalar
}

/// Divides the dx and dy fields of a CGVector by the same scalar value and
/// returns the result as a new CGVector.
public func / (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

/// Divides the dx and dy fields of a CGVector by the same scalar value.
public func /= (vector: inout CGVector, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    vector = vector / scalar
}
