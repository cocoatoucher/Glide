//
//  GameControllerInterface.swift
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

protocol GameControllerInterface: class {
    associatedtype Controller: GameControllerInterface
    associatedtype ExtendedGamepad: ExtendedGamepadInterface
    associatedtype MicroGamepad: MicroGamepadInterface

    var playerIdx: Int? { get set }
    var controllerPausedHandler: ((Controller) -> Void)? { get set }
    var extendedGamepad: ExtendedGamepad? { get }
    var microGamepad: MicroGamepad? { get }
}

protocol MicroGamepadInterface {}

protocol ExtendedGamepadInterface {
    associatedtype Controller: GameControllerInterface
    associatedtype Button: GamepadButtonInterface
    associatedtype DirectionPad: GamepadDirectionPadInterface

    var controller: Controller? { get }
    
    var buttonA: Button { get }
    var buttonB: Button { get }
    var buttonY: Button { get }
    var buttonX: Button { get }
    var dpad: DirectionPad { get }
    var leftThumbstick: DirectionPad { get }
    var rightThumbstick: DirectionPad { get }
    var leftShoulder: Button { get }
    var rightShoulder: Button { get }
    var leftTrigger: Button { get }
    var rightTrigger: Button { get }
}

protocol GamepadButtonInterface: class {
    associatedtype Button

    var pressedChangedHandler: ((Button, Float, Bool) -> Void)? { get set }
}

protocol GamepadDirectionPadInterface: class {
    associatedtype DirectionPad

    var valueChangedHandler: ((DirectionPad, Float, Float) -> Void)? { get set }
}
