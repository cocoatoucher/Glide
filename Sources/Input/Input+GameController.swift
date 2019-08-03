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
        gameControllerObserver.didConnectControllerHandler = { [weak self] connectedController in
            self?.connectGCController(connectedController)
        }
        
        gameControllerObserver.didDisconnectControllerHandler = { [weak self] removedController in
            self?.disconnectGCController(removedController)
        }
        
        for controller in gameControllerObserver.connectedControllers {
            connectGCController(controller)
        }
        
        #if os(OSX)
        usbGameControllerObserver.didUpdateControllersHandler = { [weak self] connectedDevices in
            
            self?.syncUSBGameControllers(with: connectedDevices)
        }
        #endif
    }
    
    // MARK: - Game controller callback setup
    
    private func configureExtendedGamepadButtonA<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.buttonA.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonA, value: value)
                } else {
                    self.removeKey(keyGroup.buttonA)
                }
            }
        }
    }
    
    private func configureExtendedGamepadButtonB<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.buttonB.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonB, value: value)
                } else {
                    self.removeKey(keyGroup.buttonB)
                }
            }
        }
    }
    
    private func configureExtendedGamepadButtonY<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.buttonY.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonY, value: value)
                } else {
                    self.removeKey(keyGroup.buttonY)
                }
            }
        }
    }
    
    private func configureExtendedGamepadButtonX<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.buttonX.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.buttonX, value: value)
                } else {
                    self.removeKey(keyGroup.buttonX)
                }
            }
        }
    }
    
    private func configureExtendedGamepadDpad<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.dpad.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.dpadKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
    }
    
    private func configureExtendedGamepadLeftThumbstick<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.leftThumbstick.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.leftThumbstickKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
    }
    
    private func configureExtendedGamepadRightThumbstick<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.rightThumbstick.valueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.rightThumbstickKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
    }
    
    private func configureExtendedGamepadLeftShoulder<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.leftShoulder.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }

            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.leftShoulder, value: value)
                } else {
                    self.removeKey(keyGroup.leftShoulder)
                }
            }
        }
    }
    
    private func configureExtendedGamepadRightShoulder<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.rightShoulder.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }

            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.rightShoulder, value: value)
                } else {
                    self.removeKey(keyGroup.rightShoulder)
                }
            }
        }
    }
    
    private func configureExtendedGamepadLeftTrigger<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.leftTrigger.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }

            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.leftTrigger, value: value)
                } else {
                    self.removeKey(keyGroup.leftTrigger)
                }
            }
        }
    }
    
    private func configureExtendedGamepadRightTrigger<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
        extendedGamepad.leftTrigger.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }

            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                if pressed {
                    self.addKey(keyGroup.rightTrigger, value: value)
                } else {
                    self.removeKey(keyGroup.rightTrigger)
                }
            }
        }
    }
    
    private func configureExtendedGamepad<T: ExtendedGamepadInterface>(_ extendedGamepad: T) {
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
            
            if let keyGroup = self.controllerKeyGroup(for: extendedGamepad.controller) {
                self.addKey(keyGroup.menu, removeAtNextUpdate: true)
            }
        }
    }
    
    private func configureMicroGamepad(_ microGamepad: GCMicroGamepad) {
        microGamepad.buttonA.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else {
                return
            }
            if let keyGroup = self.controllerKeyGroup(for: microGamepad.controller) {
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
            if let keyGroup = self.controllerKeyGroup(for: microGamepad.controller) {
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
            if let keyGroup = self.controllerKeyGroup(for: microGamepad.controller) {
                self.handleGameControllerDirectionInput(directionKeys: keyGroup.dpadKeys,
                                                        xValue: xValue,
                                                        yValue: yValue)
            }
        }
        
        microGamepad.controller?.controllerPausedHandler = { [weak self] _ in
            guard let self = self else {
                return
            }
            
            if let keyGroup = self.controllerKeyGroup(for: microGamepad.controller) {
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
    
    // MARK: - Controller index
    
    private var nextAvailableGameControllerPlayerIndex: Int? {
        return availableControllerPlayerIndices.first
    }
    
    private func consumeControllerPlayerIndex(playerIndex: Int) {
        if let idx = availableControllerPlayerIndices.firstIndex(of: playerIndex) {
            availableControllerPlayerIndices.remove(at: idx)
            connectedControllerPlayerIndices.append(playerIndex)
        }
    }
    
    private func recollectGCControllerPlayerIndex(playerIndex: GCControllerPlayerIndex) {
        connectedGCControllerPlayerIndices[playerIndex] = nil
        availableGCControllerPlayerIndices.append(playerIndex)
        availableGCControllerPlayerIndices.sort { (leftIndex, rightIndex) -> Bool in
            leftIndex.rawValue < rightIndex.rawValue
        }
    }
    
    private func recollectControllerPlayerIndex(playerIndex: Int) {
        if let idx = connectedControllerPlayerIndices.firstIndex(of: playerIndex) {
            connectedControllerPlayerIndices.remove(at: idx)
            availableControllerPlayerIndices.append(playerIndex)
            availableControllerPlayerIndices.sort()
        }
    }
    
    // MARK: - GC Controller sync
    
    private func connectGCController(_ controller: GCController) {
        guard shouldConnectControllerAsGCController(controller) else {
            return
        }
        
        let existing = connectedGCControllers.first(where: { connectedController -> Bool in
            connectedController.deviceHash == controller.deviceHash || connectedController == controller
        })
        if let existingController = existing {
            // Sometimes same controller is sent multiple times by GameController
            // and needs to be configured each time to make sure to setup all buttons
            controller.playerIndex = existingController.playerIndex
        } else {
            guard let newPlayerIndex = self.nextAvailableGameControllerPlayerIndex else {
                return
            }
            
            controller.playerIdx = newPlayerIndex
            if let connectedPlayerIndex = controller.playerIdx {
                consumeControllerPlayerIndex(playerIndex: connectedPlayerIndex)
                connectedGCControllers.append(controller)
            } else {
                return
            }
        }
        
        if let extendedGamepad = controller.extendedGamepad {
            configureExtendedGamepad(extendedGamepad)
        } else if let microGamepad = controller.microGamepad {
            configureMicroGamepad(microGamepad)
        }
    }
    
    private func disconnectGCController(_ removedController: GCController) {
        let index = self.connectedGCControllers.firstIndex(where: { connectedController -> Bool in
            connectedController.deviceHash == removedController.deviceHash || connectedController == removedController
        })
        guard let foundIndex = index else {
            return
        }
        
        let controller = self.connectedGCControllers[foundIndex]
        if let rawIdx = self.connectedGCControllerPlayerIndices[controller.playerIndex] {
            self.recollectGCControllerPlayerIndex(playerIndex: controller.playerIndex)
            self.recollectControllerPlayerIndex(playerIndex: rawIdx)
        }
        self.connectedGCControllers.remove(at: foundIndex)
    }
    
    private func shouldConnectControllerAsGCController(_ controller: GCController) -> Bool {
        // This is a potential list for future.
        // Joy-cons
        if controller.vendorName?.hasPrefix("Joy-Con") == true {
            return false
        }
        
        if controller.vendorName?.hasPrefix("Wireless Controller") == true {
            return false
        }
        
        if controller.vendorName?.hasPrefix("8Bitdo") == true {
            return false
        }
        return true
    }
    
    #if os(OSX)
    
    // MARK: - USB controller sync
    
    private func shouldConnectDeviceAsUSBGameController(_ device: USBGameController.Device) -> Bool {
        // This is a potential list for future.
        
        // SteelSeries Nimbus
//        if device.vendorId == 273 && device.productId == 5152 {
//            return false
//        }
        return true
    }
    
    private func syncUSBGameControllers(with connectedDevices: [USBGameController.Device]) {
        
        for (index, connectedUSBGameController) in connectedUSBGameControllers.enumerated().reversed() {
            if connectedDevices.first(where: { $0.uniqueId == connectedUSBGameController.device.uniqueId }) == nil {
                disconnectUSBGameController(connectedUSBGameController, index: index)
            }
        }
        
        var newDevices: [USBGameController.Device] = []
        for device in connectedDevices {
            if connectedUSBGameControllers.first(where: { $0.device.uniqueId == device.uniqueId }) == nil {
                newDevices.append(device)
            }
        }
        
        newDevices.forEach { connectUSBGameControllerDevice($0) }
    }
    
    private func connectUSBGameControllerDevice(_ device: USBGameController.Device) {
        guard connectedUSBGameControllers.first(where: { $0.device.uniqueId == device.uniqueId }) == nil else {
            return
        }
        
        guard shouldConnectDeviceAsUSBGameController(device) else {
            return
        }
        
        guard let playerIndex = nextAvailableGameControllerPlayerIndex else {
            return
        }
        
        let usbGameController = USBGameController(device: device, playerIdx: playerIndex)
        
        consumeControllerPlayerIndex(playerIndex: playerIndex)
        connectedUSBGameControllers.append(usbGameController)
        
        if let extendedGamepad = usbGameController.extendedGamepad {
            configureExtendedGamepad(extendedGamepad)
        }
    }
    
    private func disconnectUSBGameController(_ removedController: USBGameController, index: Int) {
        if let playerIndex = removedController.playerIdx {
            recollectControllerPlayerIndex(playerIndex: playerIndex)
        }
        connectedUSBGameControllers.remove(at: index)
    }
    #endif
    
    // MARK: - Controller key groups
    
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
    
    private func controllerKeyGroup<T: GameControllerInterface>(for gameController: T?) -> GameControllerKeyGroup? {
        guard let playerIndex = gameController?.playerIdx else {
            return nil
        }
        return controllerKeyGroup(for: playerIndex)
    }
}
