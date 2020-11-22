//
//  GameControllerObserver.swift
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

class GameControllerObserver {
    
    var didConnectControllerHandler: ((GCController) -> Void)?
    var didDisconnectControllerHandler: ((GCController) -> Void)?
    
    var keyboardConnectionChangedHandler: ((GCKeyboard?) -> Void)?
    
    var mouseConnectionChangedHandler: ((GCMouse?) -> Void)?
    
    init() {
        gameControllerDidConnectObservation = NotificationCenter.default.addObserver(
            forName: .GCControllerDidConnect,
            object: nil,
            queue: nil) { [weak self] notification in
            self?.handleGameControllerDidConnect(notification: notification)
        }
        
        gameControllerDidDisconnectObservation = NotificationCenter.default.addObserver(
            forName: .GCControllerDidDisconnect,
            object: nil,
            queue: nil) { [weak self] notification in
            self?.handleGameControllerDidDisconnect(notification: notification)
        }
        
        keyboardDidConnectObservation = NotificationCenter.default.addObserver(
            forName: .GCKeyboardDidConnect,
            object: nil,
            queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.keyboardConnectionChangedHandler?(self.connectedKeyboard)
        }
        
        keyboardDidDisconnectObservation = NotificationCenter.default.addObserver(
            forName: .GCKeyboardDidDisconnect,
            object: nil,
            queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.keyboardConnectionChangedHandler?(self.connectedKeyboard)
        }
        
        mouseDidConnectObservation = NotificationCenter.default.addObserver(
            forName: .GCMouseDidConnect,
            object: nil,
            queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.mouseConnectionChangedHandler?(self.connectedMouse)
        }
        
        mouseDidDisconnectObservation = NotificationCenter.default.addObserver(
            forName: .GCMouseDidDisconnect,
            object: nil,
            queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.mouseConnectionChangedHandler?(self.connectedMouse)
        }
    }
    
    var connectedControllers: [GCController] {
        return GCController.controllers().filter { $0.vendorName != "Generic Controller" }
    }
    
    var connectedKeyboard: GCKeyboard? {
        return GCKeyboard.coalesced
    }
    
    var connectedMouse: GCMouse? {
        return GCMouse.current
    }
    
    // MARK: - Private
    
    private var gameControllerDidConnectObservation: Any?
    private var gameControllerDidDisconnectObservation: Any?
    
    private var keyboardDidConnectObservation: Any?
    private var keyboardDidDisconnectObservation: Any?
    
    private var mouseDidConnectObservation: Any?
    private var mouseDidDisconnectObservation: Any?
    
    // MARK: - Game Controller
    
    private func handleGameControllerDidConnect(notification: Notification) {
        if let controller = notification.object as? GCController {
            if controller.vendorName != "Generic Controller" {
                self.didConnectControllerHandler?(controller)
            }
            for controller in connectedControllers {
                self.didConnectControllerHandler?(controller)
            }
        }
    }
    
    private func handleGameControllerDidDisconnect(notification: Notification) {
        if let controller = notification.object as? GCController {
            self.didDisconnectControllerHandler?(controller)
        }
    }
    
    deinit {
        if let observation = gameControllerDidConnectObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = gameControllerDidDisconnectObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        
        if let observation = keyboardDidConnectObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = keyboardDidDisconnectObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        
        if let observation = mouseDidConnectObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = mouseDidDisconnectObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}
