//
//  Input+Keyboard.swift
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
    func setupKeyboard() {
        gameControllerObserver.keyboardConnectionChangedHandler = { [weak self] connectedKeyboard in
            guard let self = self else { return }
            
            if let keyboard = connectedKeyboard {
                self.connectKeyboard(keyboard)
            } else {
                self.disconnectKeyboard()
            }
        }
        
        if let keyboard = gameControllerObserver.connectedKeyboard {
            connectKeyboard(keyboard)
        }
    }
    
    private func connectKeyboard(_ keyboard: GCKeyboard) {
        connectedKeyboard = keyboard
        
        keyboard.keyboardInput?.keyChangedHandler = { [weak self] input, buttonInput, keyCode, isPressed in
            guard let self = self else { return }
            guard let keyCode = keyCode.toKeyCode else { return }
            if isPressed {
                self.addKey(keyCode)
            } else {
                self.removeKey(keyCode)
            }
        }
    }
    
    private func disconnectKeyboard() {
        connectedKeyboard = nil
    }
}

extension GCKeyCode {
    
    var toKeyCode: KeyCode? {
        switch self {
        case .keyA: return .a
        case .keyB: return .b
        case .keyC: return .c
        case .keyD: return .d
        case .keyE: return .e
        case .keyF: return .f
        case .keyG: return .g
        case .keyH: return .h
        case .keyI: return .i
        case .keyJ: return .j
        case .keyK: return .k
        case .keyL: return .l
        case .keyM: return .m
        case .keyN: return .n
        case .keyO: return .o
        case .keyP: return .p
        case .keyQ: return .q
        case .keyR: return .r
        case .keyS: return .s
        case .keyT: return .t
        case .keyU: return .u
        case .keyV: return .v
        case .keyW: return .w
        case .keyX: return .x
        case .keyY: return .y
        case .keyZ: return .z
            
        case .one: return .alpha1
        case .two: return .alpha2
        case .three: return .alpha3
        case .four: return .alpha4
        case .five: return .alpha5
        case .six: return .alpha6
        case .seven: return .alpha7
        case .eight: return .alpha8
        case .nine: return .alpha9
        case .zero: return .alpha0
            
        case .keypad1: return .keypad1
        case .keypad2: return .keypad2
        case .keypad3: return .keypad3
        case .keypad4: return .keypad4
        case .keypad5: return .keypad5
        case .keypad6: return .keypad6
        case .keypad7: return .keypad7
        case .keypad8: return .keypad8
        case .keypad9: return .keypad9
        case .keypad0: return .keypad0
        case .keypadPeriod: return .keypadPeriod
        case .keypadEqualSign: return .keypadEqualSign
        case .keypadEnter: return .keypadEnter
        case .keypadSlash: return .keypadSlash
        case .keypadAsterisk: return .keypadAsterisk
        case .keypadHyphen: return .keypadHyphen
        case .keypadPlus: return .keypadPlus
        case .keypadNumLock: return .clear
            
        case .F1: return .f1
        case .F2: return .f2
        case .F3: return .f3
        case .F4: return .f4
        case .F5: return .f5
        case .F6: return .f6
        case .F7: return .f7
        case .F8: return .f8
        case .F9: return .f9
        case .F10: return .f10
        case .F11: return .f11
        case .F12: return .f12
            
        case .returnOrEnter: return .returnEnter
        case .escape: return .escape
        case .deleteOrBackspace: return .backspace
        case .tab: return .tab
        case .spacebar: return .space
        case .capsLock: return .capsLock
            
        case .leftControl: return .leftControl
        case .leftShift: return .leftShift
        case .leftAlt: return .leftAlt
        case .leftGUI: return .leftCommand
        case .rightControl: return .rightControl
        case .rightShift: return .rightShift
        case .rightGUI: return .rightCommand
            
        case .rightArrow: return .rightArrow
        case .leftArrow: return .leftArrow
        case .downArrow: return .downArrow
        case .upArrow: return .upArrow
        
        case .home: return .home
        case .pageUp: return .pageUp
        case .end: return .end
        case .pageDown: return .pageDown
            
        default:
            return nil
        }
    }
    
}
