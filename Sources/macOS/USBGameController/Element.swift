//
//  CheckmarkSelectedView.swift
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

#if os(macOS)
import Foundation

extension USBGameController.Device {
    
    internal class Element {
        let properties: [String: AnyObject]
        let usage: Usage
        let subElements: [Element]

        var cookie: IOHIDElementCookie? {
            return (properties[kIOHIDElementCookieKey] as? NSNumber)?.uint32Value
        }

        var maxValue: Int {
            return (properties[kIOHIDElementMaxKey] as? NSNumber)?.intValue ?? 0
        }

        var minValue: Int {
            return (properties[kIOHIDElementMinKey] as? NSNumber)?.intValue ?? 0
        }
        
        var baseValue: Int {
            var half = Float((maxValue - minValue) / 2)
            half.round(.toNearestOrAwayFromZero)
            let result = Int(half)
            return result
        }
        
        var threshold: Int {
            return (maxValue - baseValue) / 2
        }

        init(properties: [String: AnyObject]) {
            self.properties = properties
            usage = Usage(properties: properties, variant: .element)

            let subElements = properties[kIOHIDElementKey] as? [[String: AnyObject]]
            self.subElements = subElements?.map { Element(properties: $0) } ?? []
        }
    }
}
#endif
