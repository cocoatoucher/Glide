//
//  InputProfile.swift
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
import CoreGraphics

/// Represents a profile
public class InputProfile {
    /// Unique name for this profile.
    public let name: String
    /// Keys that contribute positive values for this profile.
    public var positiveKeys: [KeyCode] = []
    /// Keys that contribute negative values for this profile.
    public var negativeKeys: [KeyCode] = []
    /// Minimum value this input profile can have.
    public var threshold: Float?
    /// Sensitivity value for this profile. Currently used only for
    /// calculating mouse delta.
    public var sensitivity: CGFloat = 0.1
    
    public init(name: String, configure: (InputProfile) -> Void) {
        self.name = name
        configure(self)
    }
    
    // MARK: - Private
    
    private var allKeys: [KeyCode] {
        return negativeKeys + positiveKeys + [.touchNegative, .touchPositive]
    }
    
    private var keysToRemoveAtNextUpdate: [KeyCode] = []
    
    private var pressedKeys: [Input.KeyPressContext] = []
    private var previousKeysSnapshot: [Input.KeyPressContext] = []
    private var keysSnapshot: [Input.KeyPressContext] = []
}

extension InputProfile {
    
    var value: CGFloat {
        let mostRecentKey = keysSnapshot.filter {
            doKeysContainKeyCode(keys: allKeys, keyCode: $0.keyCode) }.max { (left, right) -> Bool in
                return left.precisePressTime < right.precisePressTime
        }
        
        guard let mostRecentKeyCode = mostRecentKey?.keyCode else {
            return 0.0
        }
        
        if doKeysContainKeyCode(keys: negativeKeys, keyCode: mostRecentKeyCode) || mostRecentKeyCode == .touchNegative {
            if let value = mostRecentKey?.value {
                return CGFloat(value)
            }
            return -1.0
        }
        if doKeysContainKeyCode(keys: positiveKeys, keyCode: mostRecentKeyCode) || mostRecentKeyCode == .touchPositive {
            if let value = mostRecentKey?.value {
                return CGFloat(value)
            }
            return 1.0
        }
        
        return 0.0
    }
    
    func isReleased() -> Bool {
        if
            contains(keys: previousKeysSnapshot, keyCode: .touchPositive) &&
                contains(keys: keysSnapshot, keyCode: .touchPositive) == false {
            return true
        }
        return positiveKeys.filter({ keyCode -> Bool in
            if
                contains(keys: previousKeysSnapshot, keyCode: keyCode) &&
                    contains(keys: keysSnapshot, keyCode: keyCode) == false {
                return true
            }
            return false
        }).isEmpty == false
    }
    
    func isHoldDown() -> Bool {
        if
            contains(keys: previousKeysSnapshot, keyCode: .touchPositive) &&
                contains(keys: keysSnapshot, keyCode: .touchPositive) {
            return true
        }
        return positiveKeys.filter({ keyCode -> Bool in
            if
                contains(keys: previousKeysSnapshot, keyCode: keyCode) &&
                    contains(keys: keysSnapshot, keyCode: keyCode) {
                return true
            }
            return false
        }).isEmpty == false
    }
    
    func isPressed() -> Bool {
        if
            contains(keys: previousKeysSnapshot, keyCode: .touchPositive) == false &&
                contains(keys: keysSnapshot, keyCode: .touchPositive) {
            return true
        }
        return positiveKeys.filter({ keyCode -> Bool in
            if
                contains(keys: previousKeysSnapshot, keyCode: keyCode) == false &&
                    contains(keys: keysSnapshot, keyCode: keyCode) {
                return true
            }
            return false
        }).isEmpty == false
    }
    
    func addKey(context: Input.KeyPressContext, removeAtNextUpdate: Bool = false) {
        if let threshold = threshold, let value = context.value, abs(value) < threshold {
            return
        }
        guard doKeysContainKeyCode(keys: allKeys, keyCode: context.keyCode) else {
            return
        }
        pressedKeys.append(context)
        if removeAtNextUpdate {
            if keysToRemoveAtNextUpdate.firstIndex(of: context.keyCode) == nil {
                keysToRemoveAtNextUpdate.append(context.keyCode)
            }
        } else {
            if let index = keysToRemoveAtNextUpdate.firstIndex(of: context.keyCode) {
                keysToRemoveAtNextUpdate.remove(at: index)
            }
        }
    }
    
    func removeKeyForRepeatedPress(keyCode: KeyCode) {
        if let index = pressedKeys.firstIndex(where: { $0.keyCode == keyCode }) {
            pressedKeys.remove(at: index)
        }
    }
    
    func removeKey(keyCode: KeyCode) {
        if let index = pressedKeys.firstIndex(where: { $0.keyCode == keyCode }) {
            pressedKeys.remove(at: index)
        }
    }
    
    func update() {
        keysSnapshot = pressedKeys
    }
    
    func reset() {
        for keyToRemove in keysToRemoveAtNextUpdate {
            if let index = pressedKeys.firstIndex(where: { $0.keyCode == keyToRemove }) {
                pressedKeys.remove(at: index)
            }
        }
        keysToRemoveAtNextUpdate = []
        previousKeysSnapshot = keysSnapshot
        
        keysSnapshot = []
    }
    
    func flushInputs() {
        keysSnapshot = []
        previousKeysSnapshot = []
        pressedKeys = []
    }
    
    // MARK: - Private
    
    private func contains(keys: [Input.KeyPressContext], keyCode: KeyCode) -> Bool {
        return doKeysContainKeyCode(keys: keys.map { $0.keyCode }, keyCode: keyCode)
    }
    
    private func doKeysContainKeyCode(keys: [KeyCode], keyCode: KeyCode) -> Bool {
        if keys.contains(keyCode) {
            return true
        }
        let mappedAllControllersKeyCode = allGameControllerKeyGroups.compactMap {
            $0.allControllersKeyCodeMap(for: keyCode)
            }.first
        if let mappedAllControllersKeyCode = mappedAllControllersKeyCode {
            return keys.contains(mappedAllControllersKeyCode)
        } else if allGameControllersKeyGroup.containsKeyCode(keyCode) {
            let mappedKeys = keys.compactMap { keyCode in
                allGameControllerKeyGroups.compactMap {
                    $0.allControllersKeyCodeMap(for: keyCode)
                    }.first
            }
            return mappedKeys.contains(keyCode)
        }
        return keys.contains(keyCode)
    }
}
