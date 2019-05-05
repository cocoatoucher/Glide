//
//  StackView.swift
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
import AppKit.NSStackView
public typealias StackViewType = NSStackView
#else
import UIKit.UIStackView
public typealias StackViewType = UIStackView
#endif

public enum StackViewOrientation: Int {
    case horizontal
    case vertical
    
    #if os(OSX)
    var underlying: NSUserInterfaceLayoutOrientation {
        switch self {
        case .vertical:
            return NSUserInterfaceLayoutOrientation.vertical
        case .horizontal:
            return NSUserInterfaceLayoutOrientation.horizontal
        }
    }
    
    #else
    var underlying: NSLayoutConstraint.Axis {
        switch self {
        case .vertical:
            return NSLayoutConstraint.Axis.vertical
        case .horizontal:
            return NSLayoutConstraint.Axis.horizontal
        }
    }
    #endif
}

open class StackView: StackViewType {
    open var orientationAndAxis: StackViewOrientation {
        set {
            #if os(OSX)
            orientation = newValue.underlying
            #else
            axis = newValue.underlying
            #endif
        }
        get {
            #if os(OSX)
            return StackViewOrientation(rawValue: orientation.rawValue) ?? .horizontal
            #else
            return StackViewOrientation(rawValue: axis.rawValue) ?? .horizontal
            #endif
        }
    }
}
