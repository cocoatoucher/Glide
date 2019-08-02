//
//  Stick.swift
//  glide
//
//  Ported from https://www.dribin.org/dave/software/#ddhidlib
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

extension USBGameController.Device {
    internal class Stick {
        
        var xAxisElement: Element?
        var yAxisElement: Element?
        var stickElements: [Element] = []
        var povElements: [Element] = []

        var allElements: [Element] {
            return ([xAxisElement] + [yAxisElement] + stickElements + povElements).compactMap { $0 }
        }

        func attemptToAddElement(_ element: Element) -> Bool {
            guard element.usage.page == kHIDPage_GenericDesktop else {
                return false
            }

            switch Int(element.usage.id) {
            case kHIDUsage_GD_X:
                if xAxisElement == nil {
                    xAxisElement = element
                } else {
                    stickElements.append(element)
                }
            case kHIDUsage_GD_Y:
                if yAxisElement == nil {
                    yAxisElement = element
                } else {
                    stickElements.append(element)
                }
            case kHIDUsage_GD_Z,
                 kHIDUsage_GD_Rx,
                 kHIDUsage_GD_Ry,
                 kHIDUsage_GD_Rz:
                stickElements.append(element)
            case kHIDUsage_GD_Hatswitch:
                povElements.append(element)
            default:
                return false
            }
            return true
        }
    }
}
