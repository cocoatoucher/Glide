//
//  USBGameController+GameControllerInterface.swift
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

#if os(macOS)
import Foundation

extension USBGameController: GameControllerInterface {
    typealias Controller = USBGameController
    typealias ExtendedGamepad = USBExtendedGamepad
    typealias MicroGamepad = USBMicroGamepad
}

class USBExtendedGamepad: ExtendedGamepadInterface {
    
    typealias Controller = USBGameController
    typealias Button = USBGameControllerButton
    typealias DirectionPad = USBGameControllerDirectionPad
    
    var controller: USBGameController?

    var buttonA = USBGameControllerButton()
    var buttonB = USBGameControllerButton()
    var buttonY = USBGameControllerButton()
    var buttonX = USBGameControllerButton()
    var dpad = USBGameControllerDirectionPad()
    var leftThumbstick = USBGameControllerDirectionPad()
    var rightThumbstick = USBGameControllerDirectionPad()
    var leftShoulder = USBGameControllerButton()
    var rightShoulder = USBGameControllerButton()
    var leftTrigger = USBGameControllerButton()
    var rightTrigger = USBGameControllerButton()
}

class USBMicroGamepad: MicroGamepadInterface {
    var buttonA = USBGameControllerButton()
    var buttonX = USBGameControllerButton()
    var dpad = USBGameControllerDirectionPad()
}

class USBGameControllerButton: GamepadButtonInterface {
    typealias Button = USBGameControllerButton

    var pressedChangedHandler: ((USBGameControllerButton, Float, Bool) -> Void)?
}

class USBGameControllerDirectionPad: GamepadDirectionPadInterface {
    typealias DirectionPad = USBGameControllerDirectionPad

    var valueChangedHandler: ((USBGameControllerDirectionPad, Float, Float) -> Void)?
    var x: Float = 0
    var y: Float = 0
}
#endif
