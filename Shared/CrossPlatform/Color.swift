//
//  DisplayLinkObserver.swift
//  glide
//
//  Based on https://github.com/soffes/X
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

#if os(OSX)
import AppKit.NSColor
public typealias Color = NSColor

extension NSColor {
    public convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
}
#else
import UIKit.UIColor
public typealias Color = UIColor
#endif

extension Color {
    
    #if !os(OSX)
    public var redComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(&value, green: nil, blue: nil, alpha: nil)
        return value
    }
    
    public var greenComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(nil, green: &value, blue: nil, alpha: nil)
        return value
    }
    
    public var blueComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(nil, green: nil, blue: &value, alpha: nil)
        return value
    }
    
    public var alphaComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &value)
        return value
    }
    #endif
}
