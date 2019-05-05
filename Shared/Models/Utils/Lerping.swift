//
//  Lerping.swift
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

public extension CGPoint {
    
    /// Returns interpolated points from current point to the given destination.
    /// maximumDelta specifies maximum distance between each interpolated point.
    func interpolatedPoints(to destination: CGPoint, maximumDelta: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        let steps = self.numberOfInterpolatedPoints(to: destination, maximumDelta: maximumDelta)
        if steps == 0 {
            return [destination]
        }
        var time: CGFloat = 1.0 / CGFloat(steps)
        for _ in 0..<steps {
            points.append(self.lerp(destination: destination, time: time))
            time += CGFloat(1.0 / CGFloat(steps))
        }
        return points
    }
    
    /// Performs a linear interpolation from current point to the given point.
    func lerp(destination: CGPoint, time: CGFloat) -> CGPoint {
        return self + ((destination - self) * time)
    }
    
    private func numberOfInterpolatedPoints(to destination: CGPoint, maximumDelta: CGFloat) -> Int {
        let yDiff = abs(destination.y - self.y)
        let xDiff = abs(destination.x - self.x)
        var numberOfSteps: Int = 0
        
        if yDiff > xDiff {
            if abs(yDiff) > maximumDelta {
                numberOfSteps = Int(ceil(abs(yDiff) / maximumDelta))
            }
        } else {
            if abs(xDiff) > maximumDelta {
                numberOfSteps = Int(ceil(abs(xDiff) / maximumDelta))
            }
        }
        
        return numberOfSteps
    }
}
