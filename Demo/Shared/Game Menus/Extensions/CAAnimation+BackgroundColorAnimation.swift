//
//  CAAnimation+BackgroundColorAnimation.swift
//  glide Demo
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

import GlideEngine

extension CAAnimation {
    static func backgroundColorAnimation(from startColor: Color, to destinationColor: Color, middleColor: Color, repeatCount: Int) -> CAAnimation {
        let firstColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        firstColorAnimation.fromValue = startColor.cgColor
        firstColorAnimation.toValue = middleColor.cgColor
        firstColorAnimation.beginTime = 0.0
        firstColorAnimation.duration = 0.03
        firstColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        firstColorAnimation.isRemovedOnCompletion = false
        firstColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let secondColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        secondColorAnimation.fromValue = middleColor.cgColor
        secondColorAnimation.toValue = destinationColor.cgColor
        secondColorAnimation.beginTime = 0.03
        secondColorAnimation.duration = 0.03
        secondColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        secondColorAnimation.isRemovedOnCompletion = false
        secondColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let group = CAAnimationGroup()
        group.repeatCount = Float(repeatCount)
        group.animations = [firstColorAnimation, secondColorAnimation]
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        
        return group
    }
}
