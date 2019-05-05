//
//  InputResponder.swift
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

import AppKit

public class InputResponder {
    public static func keyDown(with event: NSEvent) {
        Input.shared.keyDown(with: event.keyCode)
    }
    
    public static func keyUp(with event: NSEvent) {
        Input.shared.keyUp(with: event.keyCode)
    }
    
    public static func flagsChanged(with event: NSEvent) {
        // Caps lock
        if event.modifierFlags.contains(.capsLock) {
            Input.shared.keyDown(with: KeyCode.capsLock.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.capsLock.rawValue)
        }
        
        // Shift
        if event.modifierFlags.rawValue == 131330 {
            Input.shared.keyDown(with: KeyCode.leftShift.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.leftShift.rawValue)
        }
        
        if event.modifierFlags.rawValue == 131332 {
            Input.shared.keyDown(with: KeyCode.rightShift.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.rightShift.rawValue)
        }
        
        // Ctrl
        if event.modifierFlags.rawValue == 262401 {
            Input.shared.keyDown(with: KeyCode.leftControl.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.leftControl.rawValue)
        }
        
        if event.modifierFlags.rawValue == 270592 {
            Input.shared.keyDown(with: KeyCode.rightControl.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.rightControl.rawValue)
        }
        
        // Alt
        if event.modifierFlags.rawValue == 524576 {
            Input.shared.keyDown(with: KeyCode.leftAlt.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.leftAlt.rawValue)
        }
        
        if event.modifierFlags.rawValue == 524608 {
            Input.shared.keyDown(with: KeyCode.rightAlt.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.rightAlt.rawValue)
        }
        
        // Command
        if event.modifierFlags.rawValue == 1048840 {
            Input.shared.keyDown(with: KeyCode.leftCommand.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.leftCommand.rawValue)
        }
        
        if event.modifierFlags.rawValue == 1048848 {
            Input.shared.keyDown(with: KeyCode.rightCommand.rawValue)
        } else {
            Input.shared.keyUp(with: KeyCode.rightCommand.rawValue)
        }
    }
    
    public static func mouseDown(with event: NSEvent) {
        Input.shared.mouseDown(with: event)
    }
    
    public static func mouseUp(with event: NSEvent) {
        Input.shared.mouseUp(with: event)
    }
}
