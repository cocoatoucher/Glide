//
//  CustomGameController.swift
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

class CustomGameController: NSObject {
    var buttonAHandler: ((Bool) -> Void)?
    var buttonBHandler: ((Bool) -> Void)?
    var buttonYHandler: ((Bool) -> Void)?
    var buttonXHandler: ((Bool) -> Void)?
    var leftShoulderHandler: ((Bool) -> Void)?
    var rightShoulderHandler: ((Bool) -> Void)?
    var pausedHandler: ((Bool) -> Void)?
    var directionXHandler: ((Float) -> Void)?
    var directionYHandler: ((Float) -> Void)?
    
    let joystick: DDHidJoystick
    let playerIndex: Int
    
    init(joystick: DDHidJoystick, playerIndex: Int) {
        self.joystick = joystick
        self.playerIndex = playerIndex
        super.init()
        joystick.setDelegate(self)
        joystick.startListening()
    }
    
    // MARK: - Joystick delegate
    
    override func ddhidJoystick(_ joystick: DDHidJoystick!, buttonDown buttonNumber: UInt32) {
        switch buttonNumber {
        case 0:
            buttonXHandler?(true)
        case 1:
            buttonAHandler?(true)
        case 2:
            buttonBHandler?(true)
        case 3:
            buttonYHandler?(true)
        case 4:
            leftShoulderHandler?(true)
        case 5:
            rightShoulderHandler?(true)
        case 9:
            pausedHandler?(true)
        default:
            break
        }
    }
    
    override func ddhidJoystick(_ joystick: DDHidJoystick!, buttonUp buttonNumber: UInt32) {
        switch buttonNumber {
        case 0:
            buttonXHandler?(false)
        case 1:
            buttonAHandler?(false)
        case 2:
            buttonBHandler?(false)
        case 3:
            buttonYHandler?(false)
        case 4:
            leftShoulderHandler?(false)
        case 5:
            rightShoulderHandler?(false)
        case 9:
            pausedHandler?(false)
        default:
            break
        }
    }
    
    override func ddhidJoystick(_ joystick: DDHidJoystick!,
                                stick: UInt32,
                                xChanged value: Int32) {
        directionXHandler?(Float(value))
    }
    
    override func ddhidJoystick(_ joystick: DDHidJoystick!,
                                stick: UInt32,
                                yChanged value: Int32) {
        directionYHandler?(Float(value))
    }
    
    override func ddhidJoystick(_ joystick: DDHidJoystick!,
                                stick: UInt32,
                                otherAxis: UInt32,
                                valueChanged value: Int32) {
    }
    
    override func ddhidJoystick(_ joystick: DDHidJoystick!,
                                stick: UInt32,
                                povNumber: UInt32,
                                valueChanged value: Int32) {
        // X
        if value >= 4500 && value <= 13500 {
            directionXHandler?(300)
        } else if value >= 22500 && value <= 31500 {
            directionXHandler?(-300)
        } else {
            directionXHandler?(-258)
        }
        // Y
        if (value >= 31500 || value <= 4500) && value != -1 {
            directionYHandler?(-300)
        } else if value <= 22500 && value >= 13500 {
            directionYHandler?(300)
        } else {
            directionYHandler?(-258)
        }
    }
}
