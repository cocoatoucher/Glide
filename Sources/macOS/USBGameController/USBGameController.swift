//
//  USBGameController.swift
//  glide
//
//  Ported from https://www.dribin.org/dave/software/#ddhidlib
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

internal class USBGameController {
    
    var extendedGamepad: USBExtendedGamepad? = USBExtendedGamepad()
    var microGamepad: USBMicroGamepad?
    var controllerPausedHandler: ((USBGameController) -> Void)?

    let device: Device
    var playerIdx: Int?

    init(device: Device, playerIdx: Int) {
        self.device = device
        self.playerIdx = playerIdx

        extendedGamepad?.controller = self
        device.delegate = self
        device.startListening()
    }
    
    deinit {
        device.stopListening()
    }
}

extension USBGameController: USBGameControllerDeviceDelegate {
    func deviceXAxisStickValueChanged(_ device: USBGameController.Device, value: Int, stickIndex: Int) {
        guard let dpad = extendedGamepad?.dpad else {
            return
        }
        
        if value == -258 {
            dpad.x = 0
        } else if value < -258 {
            dpad.x = -1
        } else {
            dpad.x = 1
        }
        
        dpad.valueChangedHandler?(dpad, dpad.x, dpad.y)
    }

    func deviceYAxisStickValueChanged(_ device: USBGameController.Device, value: Int, stickIndex: Int) {
        guard let dpad = extendedGamepad?.dpad else {
            return
        }
        
        if value == -258 {
            dpad.y = 0
        } else if value < -258 {
            dpad.y = 1
        } else {
            dpad.y = -1
        }
        
        dpad.valueChangedHandler?(dpad, dpad.x, dpad.y)
    }

    func deviceOtherAxisStickValueChanged(_ device: USBGameController.Device, value: Int, stickIndex: Int, otherAxisIndex: Int) {
    }

    func devicePovAxisStickValueChanged(_ device: USBGameController.Device, value: Int, stickIndex: Int, povNumber: Int) {
        guard let leftThumbstick = extendedGamepad?.leftThumbstick else {
            return
        }

        // X
        if value >= 4500 && value <= 13500 {
            leftThumbstick.x = 1
        } else if value >= 22500 && value <= 31500 {
            leftThumbstick.x = -1
        } else {
            leftThumbstick.x = 0
        }
        // Y
        if (value >= 31500 || value <= 4500) && value != -1 {
            leftThumbstick.y = 1
        } else if value <= 22500 && value >= 13500 {
            leftThumbstick.y = -1
        } else {
            leftThumbstick.y = 0
        }
        leftThumbstick.valueChangedHandler?(leftThumbstick, leftThumbstick.x, leftThumbstick.y)
    }

    func deviceDidPressButton(_ device: USBGameController.Device, buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            if let buttonX = extendedGamepad?.buttonX {
                buttonX.pressedChangedHandler?(buttonX, 1.0, true)
            }
        case 1:
            if let buttonA = extendedGamepad?.buttonA {
                buttonA.pressedChangedHandler?(buttonA, 1.0, true)
            }
        case 2:
            if let buttonB = extendedGamepad?.buttonB {
                buttonB.pressedChangedHandler?(buttonB, 1.0, true)
            }
        case 3:
            if let buttonY = extendedGamepad?.buttonY {
                buttonY.pressedChangedHandler?(buttonY, 1.0, true)
            }
        case 4:
            if let leftShoulder = extendedGamepad?.leftShoulder {
                leftShoulder.pressedChangedHandler?(leftShoulder, 1.0, true)
            }
        case 5:
            if let rightShoulder = extendedGamepad?.rightShoulder {
                rightShoulder.pressedChangedHandler?(rightShoulder, 1.0, true)
            }
        case 9, 11:
            controllerPausedHandler?(self)
        default:
            break
        }
    }

    func deviceDidReleaseButton(_ device: USBGameController.Device, buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            if let buttonX = extendedGamepad?.buttonX {
                buttonX.pressedChangedHandler?(buttonX, 1.0, false)
            }
        case 1:
            if let buttonA = extendedGamepad?.buttonA {
                buttonA.pressedChangedHandler?(buttonA, 1.0, false)
            }
        case 2:
            if let buttonB = extendedGamepad?.buttonB {
                buttonB.pressedChangedHandler?(buttonB, 1.0, false)
            }
        case 3:
            if let buttonY = extendedGamepad?.buttonY {
                buttonY.pressedChangedHandler?(buttonY, 1.0, false)
            }
        case 4:
            if let leftShoulder = extendedGamepad?.leftShoulder {
                leftShoulder.pressedChangedHandler?(leftShoulder, 1.0, false)
            }
        case 5:
            if let rightShoulder = extendedGamepad?.rightShoulder {
                rightShoulder.pressedChangedHandler?(rightShoulder, 1.0, false)
            }
        default:
            break
        }
    }
}
#endif
