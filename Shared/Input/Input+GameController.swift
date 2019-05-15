//
//  Input+GameController.swift
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
import GameController

// swiftlint:disable file_length
extension Input {
    func setupGameControllers() {
        gameControllerObserver.didConnectControllerHandler = { connectedController in
            self.connectGCController(connectedController)
        }
        
        gameControllerObserver.didDisconnectControllerHandler = { removedController in
            
            let index = self.connectedGameControllers.firstIndex(where: { connectedController -> Bool in
                connectedController.deviceHash == removedController.deviceHash || connectedController == removedController
            })
            guard let foundIndex = index else {
                return
            }
            
            let controller = self.connectedGameControllers[foundIndex]
            if let rawIdx = self.connectedGCControllerPlayerIndices[controller.playerIndex] {
                self.recollectGCControllerPlayerIndex(playerIndex: controller.playerIndex)
                self.recollectControllerPlayerIndex(playerIndex: rawIdx)
            }
            self.connectedGameControllers.remove(at: foundIndex)
        }
        
        for controller in gameControllerObserver.connectedControllers {
            connectGCController(controller)
        }
        
        #if os(OSX)
        for joystick in DDHidJoystick.allJoysticks() {
            if let joystick = joystick as? DDHidJoystick {
                connectDDHidJoystick(joystick)
            }
        }
        #endif
    }
    
    private func configureExtendedGamepadButtonA(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.buttonA.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonA, value: value)
                } else {
                    self.removeKey(keyGroup.buttonA)
                }
            }
        }
    }
    
    private func configureExtendedGamepadButtonB(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.buttonB.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonB, value: value)
                } else {
                    self.removeKey(keyGroup.buttonB)
                }
            }
        }
    }
    
    private func configureExtendedGamepadButtonY(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.buttonY.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonY, value: value)
                } else {
                    self.removeKey(keyGroup.buttonY)
                }
            }
        }
    }
    
    private func configureExtendedGamepadButtonX(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.buttonX.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonX, value: value)
                } else {
                    self.removeKey(keyGroup.buttonX)
                }
            }
        }
    }
    
    private func configureExtendedGamepadDpad(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.dpad.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.dpadKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
    }
    
    private func configureExtendedGamepadLeftThumbstick(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.leftThumbstick.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.leftThumbstickKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
    }
    
    private func configureExtendedGamepadRightThumbstick(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.rightThumbstick.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.rightThumbstickKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
    }
    
    private func configureExtendedGamepadLeftShoulder(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.leftShoulder.valueChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.leftShoulder, value: value)
                } else {
                    self.removeKey(keyGroup.leftShoulder)
                }
            }
        }
    }
    
    private func configureExtendedGamepadRightShoulder(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.rightShoulder.valueChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.rightShoulder, value: value)
                } else {
                    self.removeKey(keyGroup.rightShoulder)
                }
            }
        }
    }
    
    private func configureExtendedGamepadLeftTrigger(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.leftTrigger.valueChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.leftTrigger, value: value)
                } else {
                    self.removeKey(keyGroup.leftTrigger)
                }
            }
        }
    }
    
    private func configureExtendedGamepadRightTrigger(_ extendedGamepad: GCExtendedGamepad) {
        extendedGamepad.rightTrigger.valueChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.rightTrigger, value: value)
                } else {
                    self.removeKey(keyGroup.rightTrigger)
                }
            }
        }
    }
    
    private func configureExtendedGamepad(_ extendedGamepad: GCExtendedGamepad) {
        configureExtendedGamepadButtonA(extendedGamepad)
        configureExtendedGamepadButtonB(extendedGamepad)
        configureExtendedGamepadButtonY(extendedGamepad)
        configureExtendedGamepadButtonX(extendedGamepad)
        configureExtendedGamepadDpad(extendedGamepad)
        configureExtendedGamepadLeftThumbstick(extendedGamepad)
        configureExtendedGamepadRightThumbstick(extendedGamepad)
        configureExtendedGamepadLeftTrigger(extendedGamepad)
        configureExtendedGamepadRightTrigger(extendedGamepad)
        configureExtendedGamepadLeftShoulder(extendedGamepad)
        configureExtendedGamepadRightShoulder(extendedGamepad)
        
        extendedGamepad.controller?.controllerPausedHandler = { [weak self] _ in
            guard let self = self else {
                return
            }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: extendedGamepad.controller) {
                self.addKey(keyGroup.menu, removeAtNextUpdate: true)
            }
        }
    }
    
    private func configureMicroGamepad(_ microGamepad: GCMicroGamepad) {
        microGamepad.buttonA.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(forGameController: microGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonA, value: value)
                } else {
                    self.removeKey(keyGroup.buttonA)
                }
            }
        }
        
        microGamepad.buttonX.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(forGameController: microGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonX, value: value)
                } else {
                    self.removeKey(keyGroup.buttonX)
                }
            }
        }
        
        microGamepad.dpad.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(forGameController: microGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.dpadKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
        
        microGamepad.controller?.controllerPausedHandler = { [weak self] _ in
            guard let self = self else {
                return
            }
            
            if let keyGroup = self.controllerKeyGroup(forGameController: microGamepad.controller) {
                self.addKey(keyGroup.menu, removeAtNextUpdate: true)
            }
        }
    }
    
    private func handleGameControllerDirectionInput(directionKeys: GameControllerDirectionKeys,
                                                    xValue: Float,
                                                    yValue: Float) {
        if xValue < 0 {
            addKey(directionKeys.left, value: xValue)
        } else if xValue > 0 {
            addKey(directionKeys.right, value: xValue)
        } else {
            removeKey(directionKeys.left)
            removeKey(directionKeys.right)
        }
        
        if yValue < 0 {
            addKey(directionKeys.down, value: yValue)
        } else if yValue > 0 {
            addKey(directionKeys.up, value: yValue)
        } else {
            removeKey(directionKeys.up)
            removeKey(directionKeys.down)
        }
    }
    
    private var nextAvailableGCControllerPlayerIndex: (Int, GCControllerPlayerIndex)? {
        guard
            let nextIndex = availableControllerPlayerIndices.first,
            let nextGCControllerPlayerIndex = availableGCControllerPlayerIndices.first
            else {
                return nil
        }
        return (nextIndex, nextGCControllerPlayerIndex)
    }
    
    private var nextAvailableDDHidJoystickPlayerIndex: Int? {
        return availableControllerPlayerIndices.first
    }
    
    private func consumeGCControllerPlayerIndex(playerIndex: GCControllerPlayerIndex, rawIndex: Int) {
        if let idx = availableGCControllerPlayerIndices.firstIndex(of: playerIndex) {
            availableGCControllerPlayerIndices.remove(at: idx)
            connectedGCControllerPlayerIndices[playerIndex] = rawIndex
        }
    }
    
    private func consumeControllerPlayerIndex(playerIndex: Int) {
        if let idx = availableControllerPlayerIndices.firstIndex(of: playerIndex) {
            availableControllerPlayerIndices.remove(at: idx)
            connectedControllerPlayerIndices.append(playerIndex)
        }
    }
    
    func recollectGCControllerPlayerIndex(playerIndex: GCControllerPlayerIndex) {
        connectedGCControllerPlayerIndices[playerIndex] = nil
        availableGCControllerPlayerIndices.append(playerIndex)
        availableGCControllerPlayerIndices.sort { (leftIndex, rightIndex) -> Bool in
            leftIndex.rawValue < rightIndex.rawValue
        }
    }
    
    func recollectControllerPlayerIndex(playerIndex: Int) {
        if let idx = connectedControllerPlayerIndices.firstIndex(of: playerIndex) {
            connectedControllerPlayerIndices.remove(at: idx)
            availableControllerPlayerIndices.append(playerIndex)
            availableControllerPlayerIndices.sort()
        }
    }
    
    func connectGCController(_ controller: GCController) {
        guard shouldConnectControllerAsGCController(controller) else {
            return
        }
        
        let existing = connectedGameControllers.first(where: { connectedController -> Bool in
            connectedController.deviceHash == controller.deviceHash || connectedController == controller
        })
        if let existingController = existing {
            controller.playerIndex = existingController.playerIndex
        } else {
            guard let newPlayerIndex = self.nextAvailableGCControllerPlayerIndex else {
                return
            }
            connectedGameControllers.append(controller)
            controller.playerIndex = newPlayerIndex.1
            consumeControllerPlayerIndex(playerIndex: newPlayerIndex.0)
            consumeGCControllerPlayerIndex(playerIndex: newPlayerIndex.1, rawIndex: newPlayerIndex.0)
        }
        
        if let extendedGamepad = controller.extendedGamepad {
            configureExtendedGamepad(extendedGamepad)
        } else if let microGamepad = controller.microGamepad {
            configureMicroGamepad(microGamepad)
        }
    }
    
    private func shouldConnectControllerAsGCController(_ controller: GCController) -> Bool {
        // This is a potential list for future.
        
        // Joy-cons
        if controller.vendorName?.hasPrefix("Joy-Con") == true {
            return false
        }
        return true
    }
    
    #if os(OSX)
    private func shouldConnectControllerAsCustomController(_ ddHidJoystick: DDHidJoystick) -> Bool {
        // This is a potential list for future.
        
        // SteelSeries Nimbus
        if ddHidJoystick.vendorId() == 273 && ddHidJoystick.productId() == 5152 {
            return false
        }
        return true
    }
    
    private func connectDDHidJoystick(_ ddHidJoystick: DDHidJoystick) {
        guard shouldConnectControllerAsCustomController(ddHidJoystick) else {
            return
        }
        
        guard let playerIndex = self.nextAvailableDDHidJoystickPlayerIndex else {
            return
        }
        
        let customGameController = CustomGameController(joystick: ddHidJoystick, playerIndex: playerIndex)
        consumeControllerPlayerIndex(playerIndex: playerIndex)
        connectedCustomGameControllers.append(customGameController)
        configureCustomGameController(customGameController)
    }
    
    func configureCustomGameControllerButtonA(_ customGameController: CustomGameController) {
        customGameController.buttonAHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.buttonA)
                } else {
                    self.removeKey(keyGroup.buttonA)
                }
            }
        }
    }
    
    func configureCustomGameControllerButtonB(_ customGameController: CustomGameController) {
        customGameController.buttonBHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.buttonB)
                } else {
                    self.removeKey(keyGroup.buttonB)
                }
            }
        }
    }
    
    func configureCustomGameControllerButtonX(_ customGameController: CustomGameController) {
        customGameController.buttonXHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.buttonX)
                } else {
                    self.removeKey(keyGroup.buttonX)
                }
            }
        }
    }
    
    func configureCustomGameControllerButtonY(_ customGameController: CustomGameController) {
        customGameController.buttonYHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.buttonY)
                } else {
                    self.removeKey(keyGroup.buttonY)
                }
            }
        }
    }
    
    func configureCustomGameControllerLeftShoulder(_ customGameController: CustomGameController) {
        customGameController.leftShoulderHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.leftShoulder)
                } else {
                    self.removeKey(keyGroup.leftShoulder)
                }
            }
        }
    }
    
    func configureCustomGameControllerRightShoulder(_ customGameController: CustomGameController) {
        customGameController.rightShoulderHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.rightShoulder)
                } else {
                    self.removeKey(keyGroup.rightShoulder)
                }
            }
        }
    }
    
    func configureCustomGameControllerPausedHandler(_ customGameController: CustomGameController) {
        customGameController.pausedHandler = { [weak self] pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                if pressed {
                    self.addKey(keyGroup.menu)
                } else {
                    self.removeKey(keyGroup.menu)
                }
            }
        }
    }
    
    func configureCustomGameControllerDirectionXHandler(_ customGameController: CustomGameController) {
        customGameController.directionXHandler = { [weak self] xValue in
            guard let self = self else {
                return
            }
            
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                self.handleCustomGameControllerDirectionInput(directionKeys: keyGroup.dpadKeys, xValue: xValue)
            }
        }
    }
    
    func configureCustomGameControllerDirectionYHandler(_ customGameController: CustomGameController) {
        customGameController.directionYHandler = { [weak self] yValue in
            guard let self = self else {
                return
            }
            
            if let keyGroup = self.controllerKeyGroup(for: customGameController) {
                self.handleCustomGameControllerDirectionInput(directionKeys: keyGroup.dpadKeys, yValue: yValue)
            }
        }
    }
    
    private func configureCustomGameController(_ customGameController: CustomGameController) {
        configureCustomGameControllerButtonA(customGameController)
        configureCustomGameControllerButtonB(customGameController)
        configureCustomGameControllerButtonX(customGameController)
        configureCustomGameControllerButtonY(customGameController)
        configureCustomGameControllerLeftShoulder(customGameController)
        configureCustomGameControllerRightShoulder(customGameController)
        configureCustomGameControllerPausedHandler(customGameController)
        configureCustomGameControllerDirectionXHandler(customGameController)
        configureCustomGameControllerDirectionYHandler(customGameController)
    }
    #endif
    
    private func controllerKeyGroup(for playerIndex: Int?) -> GameControllerKeyGroup? {
        var keyGroup: GameControllerKeyGroup?
        if let playerIndex = playerIndex {
            switch playerIndex {
            case 0:
                keyGroup = gameController1KeyGroup
            case 1:
                keyGroup = gameController2KeyGroup
            case 2:
                keyGroup = gameController3KeyGroup
            case 3:
                keyGroup = gameController4KeyGroup
            case 4:
                keyGroup = gameController5KeyGroup
            case 5:
                keyGroup = gameController6KeyGroup
            case 6:
                keyGroup = gameController7KeyGroup
            case 7:
                keyGroup = gameController8KeyGroup
            default:
                break
            }
        }
        return keyGroup
    }
    
    private func controllerKeyGroup(forGameController gameController: GCController?) -> GameControllerKeyGroup? {
        guard let playerIndex = gameController?.playerIndex else {
            return nil
        }
        return controllerKeyGroup(for: connectedGCControllerPlayerIndices[playerIndex])
    }
    
    #if os(OSX)
    private func controllerKeyGroup(for customGameController: CustomGameController) -> GameControllerKeyGroup? {
        return controllerKeyGroup(for: customGameController.playerIndex)
    }
    
    private func handleCustomGameControllerDirectionInput(directionKeys: GameControllerDirectionKeys, xValue: Float) {
        if xValue == -258 {
            removeKey(directionKeys.left)
            removeKey(directionKeys.right)
        } else if xValue < -258 {
            addKey(directionKeys.left, value: -1)
        } else {
            addKey(directionKeys.right, value: 1)
        }
    }
    
    private func handleCustomGameControllerDirectionInput(directionKeys: GameControllerDirectionKeys, yValue: Float) {
        if yValue == -258 {
            removeKey(directionKeys.down)
            removeKey(directionKeys.up)
        } else if yValue < -258 {
            addKey(directionKeys.up, value: 1)
        } else {
            addKey(directionKeys.down, value: -1)
        }
    }
    #endif
}
