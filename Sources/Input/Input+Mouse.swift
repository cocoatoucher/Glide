//
//  Input+Mouse.swift
//  glide
//
//  Copyright (c) 2020 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
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
import GameController

extension Input {
    func setupMouse() {
        gameControllerObserver.mouseConnectionChangedHandler = { [weak self] connectedMouse in
            guard let self = self else { return }
            
            if let mouse = connectedMouse {
                self.connectMouse(mouse)
            } else {
                self.disconnectMouse()
            }
        }
        
        if let mouse = gameControllerObserver.connectedMouse {
            connectMouse(mouse)
        }
    }
    
    private func connectMouse(_ mouse: GCMouse) {
        connectedMouse = mouse
        
        mouse.mouseInput?.leftButton.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if pressed {
                self.addKey(.mouseLeft, value: value)
            } else {
                self.removeKey(.mouseLeft)
            }
        }
        
        mouse.mouseInput?.rightButton?.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if pressed {
                self.addKey(.mouseRight, value: value)
            } else {
                self.removeKey(.mouseRight)
            }
        }
        
        mouse.mouseInput?.middleButton?.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if pressed {
                self.addKey(.mouseMiddle, value: value)
            } else {
                self.removeKey(.mouseMiddle)
            }
        }
        
        mouse.mouseInput?.mouseMovedHandler = { [weak self] _, deltaX, deltaY in
            guard let self = self else { return }
            
            self.mouseDelta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
            self.mousePosition += self.mouseDelta
        }
    }
    
    private func disconnectMouse() {
        connectedMouse = nil
    }
}
