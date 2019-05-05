//
//  GameControllerKeyGroup.swift
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

typealias GameControllerDirectionKeys = (left: KeyCode, right: KeyCode, up: KeyCode, down: KeyCode)

/// Represents all key codes which belong to an individual game controller.
struct GameControllerKeyGroup {
    let buttonA: KeyCode
    let buttonB: KeyCode
    let buttonY: KeyCode
    let buttonX: KeyCode
    let dpadLeft: KeyCode
    let dpadRight: KeyCode
    let dpadUp: KeyCode
    let dpadDown: KeyCode
    let leftThumbstickLeft: KeyCode
    let leftThumbstickRight: KeyCode
    let leftThumbstickUp: KeyCode
    let leftThumbstickDown: KeyCode
    let rightThumbstickLeft: KeyCode
    let rightThumbstickRight: KeyCode
    let rightThumbstickUp: KeyCode
    let rightThumbstickDown: KeyCode
    let leftShoulder: KeyCode
    let rightShoulder: KeyCode
    let leftTrigger: KeyCode
    let rightTrigger: KeyCode
    let menu: KeyCode
    
    var dpadKeys: GameControllerDirectionKeys {
        return (left: dpadLeft,
                right: dpadRight,
                up: dpadUp,
                down: dpadDown)
    }
    
    var leftThumbstickKeys: GameControllerDirectionKeys {
        return (left: leftThumbstickLeft,
                right: leftThumbstickRight,
                up: leftThumbstickUp,
                down: leftThumbstickDown)
    }
    
    var rightThumbstickKeys: GameControllerDirectionKeys {
        return (left: rightThumbstickLeft,
                right: rightThumbstickRight,
                up: rightThumbstickUp,
                down: rightThumbstickDown)
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func containsKeyCode(_ controllerKeyCode: KeyCode) -> Bool {
        if buttonA == controllerKeyCode { return true }
        if buttonB == controllerKeyCode { return true }
        if buttonY == controllerKeyCode { return true }
        if buttonX == controllerKeyCode { return true }
        
        if dpadLeft == controllerKeyCode { return true }
        if dpadRight == controllerKeyCode { return true }
        if dpadUp == controllerKeyCode { return true }
        if dpadDown == controllerKeyCode { return true }
        
        if leftThumbstickLeft == controllerKeyCode { return true }
        if leftThumbstickRight == controllerKeyCode { return true }
        if leftThumbstickUp == controllerKeyCode { return true }
        if leftThumbstickDown == controllerKeyCode { return true }
        
        if rightThumbstickLeft == controllerKeyCode { return true }
        if rightThumbstickRight == controllerKeyCode { return true }
        if rightThumbstickUp == controllerKeyCode { return true }
        if rightThumbstickDown == controllerKeyCode { return true }
        
        if leftShoulder == controllerKeyCode { return true }
        if rightShoulder == controllerKeyCode { return true }
        if leftTrigger == controllerKeyCode { return true }
        if rightTrigger == controllerKeyCode { return true }
        if menu == controllerKeyCode { return true }
        
        return false
    }
    
    /// Maps a key code to related all controllers key code.
    // swiftlint:disable:next cyclomatic_complexity
    func allControllersKeyCodeMap(for controllerKeyCode: KeyCode) -> KeyCode? {
        if buttonA == controllerKeyCode { return KeyCode.allControllersButtonA }
        if buttonB == controllerKeyCode { return KeyCode.allControllersButtonB }
        if buttonY == controllerKeyCode { return KeyCode.allControllersButtonY }
        if buttonX == controllerKeyCode { return KeyCode.allControllersButtonX }
        
        if dpadLeft == controllerKeyCode { return KeyCode.allControllersDpadLeft }
        if dpadRight == controllerKeyCode { return KeyCode.allControllersDpadRight }
        if dpadUp == controllerKeyCode { return KeyCode.allControllersDpadUp }
        if dpadDown == controllerKeyCode { return KeyCode.allControllersDpadDown }
        
        if leftThumbstickLeft == controllerKeyCode { return KeyCode.allControllersLeftThumbstickLeft }
        if leftThumbstickRight == controllerKeyCode { return KeyCode.allControllersLeftThumbstickRight }
        if leftThumbstickUp == controllerKeyCode { return KeyCode.allControllersLeftThumbstickUp }
        if leftThumbstickDown == controllerKeyCode { return KeyCode.allControllersLeftThumbstickDown }
        
        if rightThumbstickLeft == controllerKeyCode { return KeyCode.allControllersRightThumbstickLeft }
        if rightThumbstickRight == controllerKeyCode { return KeyCode.allControllersRightThumbstickRight }
        if rightThumbstickUp == controllerKeyCode { return KeyCode.allControllersRightThumbstickUp }
        if rightThumbstickDown == controllerKeyCode { return KeyCode.allControllersRightThumbstickDown }
        
        if leftShoulder == controllerKeyCode { return KeyCode.allControllersLeftShoulder }
        if rightShoulder == controllerKeyCode { return KeyCode.allControllersRightShoulder }
        if leftTrigger == controllerKeyCode { return KeyCode.allControllersLeftTrigger }
        if rightTrigger == controllerKeyCode { return KeyCode.allControllersRightTrigger }
        if menu == controllerKeyCode { return KeyCode.allControllersMenu }
        
        return nil
    }
}
