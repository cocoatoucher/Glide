//
//  Input+KeyboardAndMouse.swift
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

extension Input {
    
    // MARK: - Keyboard
    
    func keyDown(with keyCode: UInt16) {
        guard case .native = inputMethod else {
            return
        }
        
        if let keyCode = KeyCode(rawValue: keyCode) {
            addKey(keyCode)
        }
    }
    
    func keyUp(with keyCode: UInt16) {
        if let keyCode = KeyCode(rawValue: keyCode) {
            removeKey(keyCode)
        }
    }
    
    // MARK: - Mouse
    
    func mouseDown(with event: NSEvent) {
        guard case .native = inputMethod else {
            return
        }
        
        switch event.type {
        case .leftMouseDown:
            addKey(.mouse0)
        case .rightMouseDown:
            addKey(.mouse1)
        default:
            break
        }
    }
    
    func mouseUp(with event: NSEvent) {
        switch event.type {
        case .leftMouseUp:
            removeKey(.mouse0)
        case .rightMouseUp:
            removeKey(.mouse1)
        default:
            break
        }
    }
    
    func mouseMoved(with event: NSEvent) {
        mouseDelta = CGPoint(x: event.deltaX, y: event.deltaY)
        mousePosition += mouseDelta
    }
}
