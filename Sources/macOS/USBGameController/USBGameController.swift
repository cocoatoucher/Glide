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
    
    func deviceXAxisStickValueChanged(_ device: USBGameController.Device, value: Int, baseValue: Int, threshold: Int, stickIndex: Int) {
        guard let dpad = extendedGamepad?.dpad else {
            return
        }
        
        dpad.rawX = value
        notifyAxisValueOfDirectionPad(dpad, baseValue: baseValue, threshold: threshold)
    }

    func deviceYAxisStickValueChanged(_ device: USBGameController.Device, value: Int, baseValue: Int, threshold: Int, stickIndex: Int) {
        guard let dpad = extendedGamepad?.dpad else {
            return
        }
        
        dpad.rawY = value
        notifyAxisValueOfDirectionPad(dpad, baseValue: baseValue, threshold: threshold)
    }
    
    func deviceOtherAxisStickValueChanged(_ device: USBGameController.Device, value: Int, baseValue: Int, threshold: Int, stickIndex: Int, otherAxisIndex: Int) {
        guard let rightThumbstick = extendedGamepad?.rightThumbstick else {
            return
        }

        switch otherAxisIndex {
        case 0:
            rightThumbstick.rawX = value
        case 1:
            rightThumbstick.rawY = value
        default:
            break
        }

        notifyAxisValueOfDirectionPad(rightThumbstick, baseValue: baseValue, threshold: threshold)
    }

    func devicePovAxisStickValueChanged(_ device: USBGameController.Device, value: Int, stickIndex: Int, povNumber: Int) {
        guard let leftThumbstick = extendedGamepad?.leftThumbstick else {
            return
        }
        
        if value / 2 == 0 {
            leftThumbstick.y = 1
            leftThumbstick.x = 0
        } else if value / 2 == 1 {
            leftThumbstick.x = 1
            leftThumbstick.y = 0
        } else if value / 2 == 2 {
            leftThumbstick.y = -1
            leftThumbstick.x = 0
        } else if value / 2 == 3 {
            leftThumbstick.x = -1
            leftThumbstick.y = 0
        } else {
            leftThumbstick.x = 0
            leftThumbstick.y = 0
        }
        
        leftThumbstick.valueChangedHandler?(leftThumbstick, leftThumbstick.x, leftThumbstick.y)
    }

    // swiftlint:disable:next cyclomatic_complexity
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
        case 6:
            if let leftTrigger = extendedGamepad?.leftTrigger {
            leftTrigger.pressedChangedHandler?(leftTrigger, 1.0, true)
        }
        case 7:
            if let rightTrigger = extendedGamepad?.rightTrigger {
            rightTrigger.pressedChangedHandler?(rightTrigger, 1.0, true)
        }
        case 9, 11:
            controllerPausedHandler?(self)
        default:
            break
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
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
        case 6:
            if let leftTrigger = extendedGamepad?.leftTrigger {
            leftTrigger.pressedChangedHandler?(leftTrigger, 1.0, false)
        }
        case 7:
            if let rightTrigger = extendedGamepad?.rightTrigger {
            rightTrigger.pressedChangedHandler?(rightTrigger, 1.0, false)
        }
        default:
            break
        }
    }
    
    private func notifyAxisValueOfDirectionPad(_ dpad: USBGameControllerDirectionPad, baseValue: Int, threshold: Int) {
        let diffY = dpad.rawY - baseValue

        if abs(diffY) <= 2 {
            dpad.y = 0
        } else if diffY < 0 && abs(diffY) >= threshold {
            dpad.y = 1
        } else if diffY > 0 && abs(diffY) >= threshold {
            dpad.y = -1
        } else {
            dpad.y = 0
        }

        let diffX = dpad.rawX - baseValue

        if abs(diffX) <= 2 {
            dpad.x = 0
        } else if diffX > 0 && abs(diffX) >= threshold {
            dpad.x = 1
        } else if diffX < 0 && abs(diffX) >= threshold {
            dpad.x = -1
        } else {
            dpad.x = 0
        }

        dpad.valueChangedHandler?(dpad, dpad.x, dpad.y)
    }
}
#endif
