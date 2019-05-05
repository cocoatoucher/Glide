//
//  DefaultGameControllerKeyGroups.swift
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

/// Represents all individual game controllers.
let allGameControllerKeyGroups = [gameController1KeyGroup,
                                  gameController2KeyGroup,
                                  gameController3KeyGroup,
                                  gameController4KeyGroup,
                                  gameController5KeyGroup,
                                  gameController6KeyGroup,
                                  gameController7KeyGroup,
                                  gameController8KeyGroup]

/// Represets any game controller.
let allGameControllersKeyGroup = GameControllerKeyGroup(buttonA: .allControllersButtonA,
                                                        buttonB: .allControllersButtonB,
                                                        buttonY: .allControllersButtonY,
                                                        buttonX: .allControllersButtonX,
                                                        dpadLeft: .allControllersDpadLeft,
                                                        dpadRight: .allControllersDpadRight,
                                                        dpadUp: .allControllersDpadUp,
                                                        dpadDown: .allControllersDpadDown,
                                                        leftThumbstickLeft: .allControllersLeftThumbstickLeft,
                                                        leftThumbstickRight: .allControllersLeftThumbstickRight,
                                                        leftThumbstickUp: .allControllersLeftThumbstickUp,
                                                        leftThumbstickDown: .allControllersLeftThumbstickDown,
                                                        rightThumbstickLeft: .allControllersRightThumbstickLeft,
                                                        rightThumbstickRight: .allControllersRightThumbstickRight,
                                                        rightThumbstickUp: .allControllersRightThumbstickUp,
                                                        rightThumbstickDown: .allControllersRightThumbstickDown,
                                                        leftShoulder: .allControllersLeftShoulder,
                                                        rightShoulder: .allControllersRightShoulder,
                                                        leftTrigger: .allControllersLeftTrigger,
                                                        rightTrigger: .allControllersRightTrigger,
                                                        menu: .allControllersMenu)

/// Represents game controller with index 1.
let gameController1KeyGroup = GameControllerKeyGroup(buttonA: .controller1ButtonA,
                                                     buttonB: .controller1ButtonB,
                                                     buttonY: .controller1ButtonY,
                                                     buttonX: .controller1ButtonX,
                                                     dpadLeft: .controller1DpadLeft,
                                                     dpadRight: .controller1DpadRight,
                                                     dpadUp: .controller1DpadUp,
                                                     dpadDown: .controller1DpadDown,
                                                     leftThumbstickLeft: .controller1LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller1LeftThumbstickRight,
                                                     leftThumbstickUp: .controller1LeftThumbstickUp,
                                                     leftThumbstickDown: .controller1LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller1RightThumbstickLeft,
                                                     rightThumbstickRight: .controller1RightThumbstickRight,
                                                     rightThumbstickUp: .controller1RightThumbstickUp,
                                                     rightThumbstickDown: .controller1RightThumbstickDown,
                                                     leftShoulder: .controller1LeftShoulder,
                                                     rightShoulder: .controller1RightShoulder,
                                                     leftTrigger: .controller1LeftTrigger,
                                                     rightTrigger: .controller1RightTrigger,
                                                     menu: .controller1Menu)

/// Represents game controller with index 2.
let gameController2KeyGroup = GameControllerKeyGroup(buttonA: .controller2ButtonA,
                                                     buttonB: .controller2ButtonB,
                                                     buttonY: .controller2ButtonY,
                                                     buttonX: .controller2ButtonX,
                                                     dpadLeft: .controller2DpadLeft,
                                                     dpadRight: .controller2DpadRight,
                                                     dpadUp: .controller2DpadUp,
                                                     dpadDown: .controller2DpadDown,
                                                     leftThumbstickLeft: .controller2LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller2LeftThumbstickRight,
                                                     leftThumbstickUp: .controller2LeftThumbstickUp,
                                                     leftThumbstickDown: .controller2LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller2RightThumbstickLeft,
                                                     rightThumbstickRight: .controller2RightThumbstickRight,
                                                     rightThumbstickUp: .controller2RightThumbstickUp,
                                                     rightThumbstickDown: .controller2RightThumbstickDown,
                                                     leftShoulder: .controller2LeftShoulder,
                                                     rightShoulder: .controller2RightShoulder,
                                                     leftTrigger: .controller2LeftTrigger,
                                                     rightTrigger: .controller2RightTrigger,
                                                     menu: .controller2Menu)

/// Represents game controller with index 3.
let gameController3KeyGroup = GameControllerKeyGroup(buttonA: .controller3ButtonA,
                                                     buttonB: .controller3ButtonB,
                                                     buttonY: .controller3ButtonY,
                                                     buttonX: .controller3ButtonX,
                                                     dpadLeft: .controller3DpadLeft,
                                                     dpadRight: .controller3DpadRight,
                                                     dpadUp: .controller3DpadUp,
                                                     dpadDown: .controller3DpadDown,
                                                     leftThumbstickLeft: .controller3LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller3LeftThumbstickRight,
                                                     leftThumbstickUp: .controller3LeftThumbstickUp,
                                                     leftThumbstickDown: .controller3LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller3RightThumbstickLeft,
                                                     rightThumbstickRight: .controller3RightThumbstickRight,
                                                     rightThumbstickUp: .controller3RightThumbstickUp,
                                                     rightThumbstickDown: .controller3RightThumbstickDown,
                                                     leftShoulder: .controller3LeftShoulder,
                                                     rightShoulder: .controller3RightShoulder,
                                                     leftTrigger: .controller3LeftTrigger,
                                                     rightTrigger: .controller3RightTrigger,
                                                     menu: .controller3Menu)

/// Represents game controller with index 4.
let gameController4KeyGroup = GameControllerKeyGroup(buttonA: .controller4ButtonA,
                                                     buttonB: .controller4ButtonB,
                                                     buttonY: .controller4ButtonY,
                                                     buttonX: .controller4ButtonX,
                                                     dpadLeft: .controller4DpadLeft,
                                                     dpadRight: .controller4DpadRight,
                                                     dpadUp: .controller4DpadUp,
                                                     dpadDown: .controller4DpadDown,
                                                     leftThumbstickLeft: .controller4LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller4LeftThumbstickRight,
                                                     leftThumbstickUp: .controller4LeftThumbstickUp,
                                                     leftThumbstickDown: .controller4LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller4RightThumbstickLeft,
                                                     rightThumbstickRight: .controller4RightThumbstickRight,
                                                     rightThumbstickUp: .controller4RightThumbstickUp,
                                                     rightThumbstickDown: .controller4RightThumbstickDown,
                                                     leftShoulder: .controller4LeftShoulder,
                                                     rightShoulder: .controller4RightShoulder,
                                                     leftTrigger: .controller4LeftTrigger,
                                                     rightTrigger: .controller4RightTrigger,
                                                     menu: .controller4Menu)

/// Represents game controller with index 5.
let gameController5KeyGroup = GameControllerKeyGroup(buttonA: .controller5ButtonA,
                                                     buttonB: .controller5ButtonB,
                                                     buttonY: .controller5ButtonY,
                                                     buttonX: .controller5ButtonX,
                                                     dpadLeft: .controller5DpadLeft,
                                                     dpadRight: .controller5DpadRight,
                                                     dpadUp: .controller5DpadUp,
                                                     dpadDown: .controller5DpadDown,
                                                     leftThumbstickLeft: .controller5LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller5LeftThumbstickRight,
                                                     leftThumbstickUp: .controller5LeftThumbstickUp,
                                                     leftThumbstickDown: .controller5LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller5RightThumbstickLeft,
                                                     rightThumbstickRight: .controller5RightThumbstickRight,
                                                     rightThumbstickUp: .controller5RightThumbstickUp,
                                                     rightThumbstickDown: .controller5RightThumbstickDown,
                                                     leftShoulder: .controller5LeftShoulder,
                                                     rightShoulder: .controller5RightShoulder,
                                                     leftTrigger: .controller5LeftTrigger,
                                                     rightTrigger: .controller5RightTrigger,
                                                     menu: .controller5Menu)

/// Represents game controller with index 6.
let gameController6KeyGroup = GameControllerKeyGroup(buttonA: .controller6ButtonA,
                                                     buttonB: .controller6ButtonB,
                                                     buttonY: .controller6ButtonY,
                                                     buttonX: .controller6ButtonX,
                                                     dpadLeft: .controller6DpadLeft,
                                                     dpadRight: .controller6DpadRight,
                                                     dpadUp: .controller6DpadUp,
                                                     dpadDown: .controller6DpadDown,
                                                     leftThumbstickLeft: .controller6LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller6LeftThumbstickRight,
                                                     leftThumbstickUp: .controller6LeftThumbstickUp,
                                                     leftThumbstickDown: .controller6LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller6RightThumbstickLeft,
                                                     rightThumbstickRight: .controller6RightThumbstickRight,
                                                     rightThumbstickUp: .controller6RightThumbstickUp,
                                                     rightThumbstickDown: .controller6RightThumbstickDown,
                                                     leftShoulder: .controller6LeftShoulder,
                                                     rightShoulder: .controller6RightShoulder,
                                                     leftTrigger: .controller6LeftTrigger,
                                                     rightTrigger: .controller6RightTrigger,
                                                     menu: .controller6Menu)

/// Represents game controller with index 7.
let gameController7KeyGroup = GameControllerKeyGroup(buttonA: .controller7ButtonA,
                                                     buttonB: .controller7ButtonB,
                                                     buttonY: .controller7ButtonY,
                                                     buttonX: .controller7ButtonX,
                                                     dpadLeft: .controller7DpadLeft,
                                                     dpadRight: .controller7DpadRight,
                                                     dpadUp: .controller7DpadUp,
                                                     dpadDown: .controller7DpadDown,
                                                     leftThumbstickLeft: .controller7LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller7LeftThumbstickRight,
                                                     leftThumbstickUp: .controller7LeftThumbstickUp,
                                                     leftThumbstickDown: .controller7LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller7RightThumbstickLeft,
                                                     rightThumbstickRight: .controller7RightThumbstickRight,
                                                     rightThumbstickUp: .controller7RightThumbstickUp,
                                                     rightThumbstickDown: .controller7RightThumbstickDown,
                                                     leftShoulder: .controller7LeftShoulder,
                                                     rightShoulder: .controller7RightShoulder,
                                                     leftTrigger: .controller7LeftTrigger,
                                                     rightTrigger: .controller7RightTrigger,
                                                     menu: .controller7Menu)

/// Represents game controller with index 8.
let gameController8KeyGroup = GameControllerKeyGroup(buttonA: .controller8ButtonA,
                                                     buttonB: .controller8ButtonB,
                                                     buttonY: .controller8ButtonY,
                                                     buttonX: .controller8ButtonX,
                                                     dpadLeft: .controller8DpadLeft,
                                                     dpadRight: .controller8DpadRight,
                                                     dpadUp: .controller8DpadUp,
                                                     dpadDown: .controller8DpadDown,
                                                     leftThumbstickLeft: .controller8LeftThumbstickLeft,
                                                     leftThumbstickRight: .controller8LeftThumbstickRight,
                                                     leftThumbstickUp: .controller8LeftThumbstickUp,
                                                     leftThumbstickDown: .controller8LeftThumbstickDown,
                                                     rightThumbstickLeft: .controller8RightThumbstickLeft,
                                                     rightThumbstickRight: .controller8RightThumbstickRight,
                                                     rightThumbstickUp: .controller8RightThumbstickUp,
                                                     rightThumbstickDown: .controller8RightThumbstickDown,
                                                     leftShoulder: .controller8LeftShoulder,
                                                     rightShoulder: .controller8RightShoulder,
                                                     leftTrigger: .controller8LeftTrigger,
                                                     rightTrigger: .controller8RightTrigger,
                                                     menu: .controller8Menu)
