//
//  RoundedAngle.swift
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

/// Represents an angle on a circle which is rounded to multiples of 45 degrees.
public enum RoundedAngle {
    case angle0
    case angle45
    case angle90
    case angle135
    case angle180
    case angle225
    case angle270
    case angle315
    case other(CGFloat)
    
    public init?(degrees: CGFloat) {
        if degrees < 22.5 && degrees >= 0 {
            self = .angle180
        } else if degrees >= -22.5 && degrees <= 0 {
            self = .angle180
        } else if degrees < -22.5 && degrees >= -67.5 {
            self = .angle135
        } else if degrees < -67.5 && degrees >= -112.5 {
            self = .angle90
        } else if degrees < -112.5 && degrees >= -157.5 {
            self = .angle45
        } else if degrees < -157.5 && degrees >= -180 {
            self = .angle0
        } else if degrees >= 157.5 && degrees <= 180.0 {
            self = .angle0
        } else if degrees < 157.5 && degrees >= 112.5 {
            self = .angle315
        } else if degrees < 112.5 && degrees >= 67.5 {
            self = .angle270
        } else if degrees < 67.5 && degrees >= 22.5 {
            self = .angle225
        } else {
            self = .other(degrees)
        }
    }
    
    public var degrees: CGFloat {
        switch self {
        case .angle0:
            return 180
        case .angle45:
            return -135
        case .angle90:
            return -90
        case .angle135:
            return -45
        case .angle180:
            return 0
        case .angle225:
            return 45
        case .angle270:
            return 90
        case .angle315:
            return 135
        case .other(let degrees):
            return degrees
        }
    }
    
    public var stringValue: String {
        switch self {
        case .angle0:
            return "0"
        case .angle45:
            return "45"
        case .angle90:
            return "90"
        case .angle135:
            return "135"
        case .angle180:
            return "180"
        case .angle225:
            return "225"
        case .angle270:
            return "270"
        case .angle315:
            return "315"
        case .other(let degrees):
            return "\(degrees)"
        }
    }
    
    public var horizontalMirrored: RoundedAngle {
        switch self {
        case .angle0:
            return .angle180
        case .angle45:
            return .angle135
        case .angle90:
            return .angle90
        case .angle135:
            return .angle45
        case .angle180:
            return .angle0
        case .angle225:
            return .angle315
        case .angle270:
            return .angle270
        case .angle315:
            return .angle225
        case .other:
            return .angle0
        }
    }
    
    public var nextCounterclockwise: RoundedAngle {
        switch self {
        case .angle0:
            return .angle45
        case .angle45:
            return .angle90
        case .angle90:
            return .angle135
        case .angle135:
            return .angle180
        case .angle180:
            return .angle225
        case .angle225:
            return .angle270
        case .angle270:
            return .angle315
        case .angle315:
            return .angle0
        case .other:
            return .angle0
        }
    }
    
    public var nextClockwise: RoundedAngle {
        switch self {
        case .angle0:
            return .angle315
        case .angle45:
            return .angle0
        case .angle90:
            return .angle45
        case .angle135:
            return .angle90
        case .angle180:
            return .angle135
        case .angle225:
            return .angle180
        case .angle270:
            return .angle225
        case .angle315:
            return .angle270
        case .other:
            return .angle0
        }
    }
    
    public var direction: CGVector {
        switch self {
        case .angle0:
            return CGVector(dx: 1, dy: 0)
        case .angle45:
            return CGVector(dx: 1, dy: 1)
        case .angle90:
            return CGVector(dx: 0, dy: 1)
        case .angle135:
            return CGVector(dx: -1, dy: 1)
        case .angle180:
            return CGVector(dx: -1, dy: 0)
        case .angle225:
            return CGVector(dx: -1, dy: -1)
        case .angle270:
            return CGVector(dx: 0, dy: -1)
        case .angle315:
            return CGVector(dx: 1, dy: -1)
        case .other:
            return .zero
        }
    }
}
