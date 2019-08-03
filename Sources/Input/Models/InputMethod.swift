//
//  InputMethod.swift
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

public extension Notification.Name {
    /// Notification posted when recognized input method changes.
    /// React to this to update your input related UI/game elements.
    static let InputMethodDidChange = Notification.Name("InputMethodDidChange")
}

/// Represents main type of input method currently recognized by an input controller.
public enum InputMethod {
    /// No game controllers are currently connected. Represents touch inputs on iOS,
    /// mouse and keyboard events on macOS. This case doesn't exist on tvOS where
    /// at least one game controller is always connected (Siri Remote).
    case native
    /// At least one game controller is connected.
    case gameController
    
    #if os(iOS)
    /// `true` if the touch inputs are enabled.
    public var isTouchesEnabled: Bool {
        switch self {
        case .gameController:
            return false
        case .native:
            return true
        }
    }
    #endif
    
    /// `true` if the focus highlights should be indicated on UI elements.
    public var shouldDisplayFocusOnUI: Bool {
        switch self {
        case .gameController:
            return true
        case .native:
            #if os(iOS)
            return false
            #else
            return true
            #endif
        }
    }
}
