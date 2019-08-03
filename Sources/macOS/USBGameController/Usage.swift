//
//  Usage.swift
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
import IOKit
// swiftlint:disable:next duplicate_imports
import IOKit.hid

extension USBGameController.Device {
    internal struct Usage {
        
        enum Variant {
            case element
            case primary
            case device
        }
        
        let page: UInt
        let id: UInt

        init(properties: [String: AnyObject], variant: Variant) {
            switch variant {
            case .element:
                page = (properties[kIOHIDElementUsagePageKey] as? NSNumber)?.uintValue ?? 0
                id = (properties[kIOHIDElementUsageKey] as? NSNumber)?.uintValue ?? 0
            case .primary:
                page = (properties[kIOHIDPrimaryUsagePageKey] as? NSNumber)?.uintValue ?? 0
                id = (properties[kIOHIDPrimaryUsageKey] as? NSNumber)?.uintValue ?? 0
            case .device:
                page = (properties[kIOHIDDeviceUsagePageKey] as? NSNumber)?.uintValue ?? 0
                id = (properties[kIOHIDDeviceUsageKey] as? NSNumber)?.uintValue ?? 0
            }
        }
    }
}
#endif
