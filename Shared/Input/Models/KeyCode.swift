//
//  KeyCode.swift
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

/// All input key codes recognized.
public enum KeyCode: UInt16, CaseIterable, Equatable {
    
    case alpha0 = 0x1D
    case alpha1 = 0x12
    case alpha2 = 0x13
    case alpha3 = 0x14
    case alpha4 = 0x15
    case alpha5 = 0x17
    case alpha6 = 0x16
    case alpha7 = 0x1A
    case alpha8 = 0x1C
    case alpha9 = 0x19
    
    case keypadPeriod = 0x41
    case keypadDivide = 0x4B
    case keypadMultiply = 0x43
    case keypadMinus = 0x4E
    case keypadPlus = 0x45
    case keypadEnter = 0x4C
    case keypadEquals = 0x51
    
    case keypad0 = 0x52
    case keypad1 = 0x53
    case keypad2 = 0x54
    case keypad3 = 0x55
    case keypad4 = 0x56
    case keypad5 = 0x57
    case keypad6 = 0x58
    case keypad7 = 0x59
    case keypad8 = 0x5B
    case keypad9 = 0x5C
    
    case f1 = 0x7A
    case f2 = 0x78
    case f3 = 0x63
    case f4 = 0x76
    case f5 = 0x60
    case f6 = 0x61
    case f7 = 0x62
    case f8 = 0x64
    case f9 = 0x65
    case f10 = 0x6D
    case f11 = 0x6E
    case f12 = 0x6F
    case f13 = 0x69
    case f14 = 0x6B
    case f15 = 0x71
    
    case returnEnter = 0x24
    case tab = 0x30
    case space = 0x31
    case escape = 0x35
    case leftCommand = 0x37
    case rightCommand = 0x38
    case leftShift = 0x39
    case leftAlt = 0x3A
    case leftControl = 0x3B
    case rightShift = 0x3C
    case rightAlt = 0x3D
    case rightControl = 0x3E
    case clear = 0x47
    case home = 0x73
    case pageUp = 0x74
    case delete = 0x75
    case end = 0x77
    case pageDown = 0x79
    case leftArrow = 0x7B
    case rightArrow = 0x7C
    case downArrow = 0x7D
    case upArrow = 0x7E
    case backspace = 0x7F
    
    case a = 0x0
    case b = 0xB
    case c = 0x8
    case d = 0x2
    case e = 0xE
    case f = 0x3
    case g = 0x5
    case h = 0x4
    case i = 0x22
    case j = 0x26
    case k = 0x28
    case l = 0x25
    case m = 0x2E
    case n = 0x2D
    case o = 0x1F
    case p = 0x23
    case q = 0xC
    case r = 0xF
    case s = 0x1
    case t = 0x11
    case u = 0x20
    case v = 0x9
    case w = 0xD
    case x = 0x7
    case y = 0x10
    case z = 0x6
    
    case capsLock = 0xFFF
    case mouse0 = 0x2BC
    case mouse1 = 0x2BD
    
    case controller1ButtonA = 0x3E8
    case controller1ButtonB = 0x3E9
    case controller1ButtonY = 0x3EA
    case controller1ButtonX = 0x3EB
    case controller1DpadLeft = 0x3EC
    case controller1DpadRight = 0x3ED
    case controller1DpadUp = 0x3EE
    case controller1DpadDown = 0x3EF
    case controller1LeftThumbstickLeft = 0x3F0
    case controller1LeftThumbstickRight = 0x3F1
    case controller1LeftThumbstickUp = 0x3F2
    case controller1LeftThumbstickDown = 0x3F3
    case controller1RightThumbstickLeft = 0x3F4
    case controller1RightThumbstickRight = 0x3F5
    case controller1RightThumbstickUp = 0x3F6
    case controller1RightThumbstickDown = 0x3F7
    case controller1LeftShoulder = 0x3F8
    case controller1RightShoulder = 0x3F9
    case controller1LeftTrigger = 0x3FA
    case controller1RightTrigger = 0x3FB
    case controller1Menu = 0x3FC
    
    case controller2ButtonA = 0x7D0
    case controller2ButtonB = 0x7D1
    case controller2ButtonY = 0x7D2
    case controller2ButtonX = 0x7D3
    case controller2DpadLeft = 0x7D4
    case controller2DpadRight = 0x7D5
    case controller2DpadUp = 0x7D6
    case controller2DpadDown = 0x7D7
    case controller2LeftThumbstickLeft = 0x7D8
    case controller2LeftThumbstickRight = 0x7D9
    case controller2LeftThumbstickUp = 0x7DA
    case controller2LeftThumbstickDown = 0x7DB
    case controller2RightThumbstickLeft = 0x7DC
    case controller2RightThumbstickRight = 0x7DD
    case controller2RightThumbstickUp = 0x7DE
    case controller2RightThumbstickDown = 0x7DF
    case controller2LeftShoulder = 0x7E0
    case controller2RightShoulder = 0x7E1
    case controller2LeftTrigger = 0x7E2
    case controller2RightTrigger = 0x7E3
    case controller2Menu = 0x7E4
    
    case controller3ButtonA = 0xBB8
    case controller3ButtonB = 0xBB9
    case controller3ButtonY = 0xBBA
    case controller3ButtonX = 0xBBB
    case controller3DpadLeft = 0xBBC
    case controller3DpadRight = 0xBBD
    case controller3DpadUp = 0xBBE
    case controller3DpadDown = 0xBBF
    case controller3LeftThumbstickLeft = 0xBC0
    case controller3LeftThumbstickRight = 0xBC1
    case controller3LeftThumbstickUp = 0xBC2
    case controller3LeftThumbstickDown = 0xBC3
    case controller3RightThumbstickLeft = 0xBC4
    case controller3RightThumbstickRight = 0xBC5
    case controller3RightThumbstickUp = 0xBC6
    case controller3RightThumbstickDown = 0xBC7
    case controller3LeftShoulder = 0xBC8
    case controller3RightShoulder = 0xBC9
    case controller3LeftTrigger = 0xBCA
    case controller3RightTrigger = 0xBCB
    case controller3Menu = 0xBCC
    
    case controller4ButtonA = 0xFA0
    case controller4ButtonB = 0xFA1
    case controller4ButtonY = 0xFA2
    case controller4ButtonX = 0xFA3
    case controller4DpadLeft = 0xFA4
    case controller4DpadRight = 0xFA5
    case controller4DpadUp = 0xFA6
    case controller4DpadDown = 0xFA7
    case controller4LeftThumbstickLeft = 0xFA8
    case controller4LeftThumbstickRight = 0xFA9
    case controller4LeftThumbstickUp = 0xFAA
    case controller4LeftThumbstickDown = 0xFAB
    case controller4RightThumbstickLeft = 0xFAC
    case controller4RightThumbstickRight = 0xFAD
    case controller4RightThumbstickUp = 0xFAE
    case controller4RightThumbstickDown = 0xFAF
    case controller4LeftShoulder = 0xFB0
    case controller4RightShoulder = 0xFB1
    case controller4LeftTrigger = 0xFB2
    case controller4RightTrigger = 0xFB3
    case controller4Menu = 0xFB4
    
    case controller5ButtonA = 0x1388
    case controller5ButtonB = 0x1389
    case controller5ButtonY = 0x138A
    case controller5ButtonX = 0x138B
    case controller5DpadLeft = 0x138C
    case controller5DpadRight = 0x138D
    case controller5DpadUp = 0x138E
    case controller5DpadDown = 0x138F
    case controller5LeftThumbstickLeft = 0x1390
    case controller5LeftThumbstickRight = 0x1391
    case controller5LeftThumbstickUp = 0x1392
    case controller5LeftThumbstickDown = 0x1393
    case controller5RightThumbstickLeft = 0x1394
    case controller5RightThumbstickRight = 0x1395
    case controller5RightThumbstickUp = 0x1398
    case controller5RightThumbstickDown = 0x1399
    case controller5LeftShoulder = 0x139A
    case controller5RightShoulder = 0x139B
    case controller5LeftTrigger = 0x139C
    case controller5RightTrigger = 0x139D
    case controller5Menu = 0x139E
    
    case controller6ButtonA = 0x1770
    case controller6ButtonB = 0x1771
    case controller6ButtonY = 0x1772
    case controller6ButtonX = 0x1773
    case controller6DpadLeft = 0x1774
    case controller6DpadRight = 0x1775
    case controller6DpadUp = 0x1776
    case controller6DpadDown = 0x1777
    case controller6LeftThumbstickLeft = 0x1778
    case controller6LeftThumbstickRight = 0x1779
    case controller6LeftThumbstickUp = 0x177A
    case controller6LeftThumbstickDown = 0x177B
    case controller6RightThumbstickLeft = 0x177C
    case controller6RightThumbstickRight = 0x177D
    case controller6RightThumbstickUp = 0x177E
    case controller6RightThumbstickDown = 0x177F
    case controller6LeftShoulder = 0x1780
    case controller6RightShoulder = 0x1781
    case controller6LeftTrigger = 0x1782
    case controller6RightTrigger = 0x1783
    case controller6Menu = 0x1784
    
    case controller7ButtonA = 0x1B58
    case controller7ButtonB = 0x1B59
    case controller7ButtonY = 0x1B5A
    case controller7ButtonX = 0x1B5B
    case controller7DpadLeft = 0x1B5C
    case controller7DpadRight = 0x1B5D
    case controller7DpadUp = 0x1B5E
    case controller7DpadDown = 0x1B5F
    case controller7LeftThumbstickLeft = 0x1B60
    case controller7LeftThumbstickRight = 0x1B61
    case controller7LeftThumbstickUp = 0x1B62
    case controller7LeftThumbstickDown = 0x1B63
    case controller7RightThumbstickLeft = 0x1B64
    case controller7RightThumbstickRight = 0x1B65
    case controller7RightThumbstickUp = 0x1B66
    case controller7RightThumbstickDown = 0x1B67
    case controller7LeftShoulder = 0x1B68
    case controller7RightShoulder = 0x1B69
    case controller7LeftTrigger = 0x1B6A
    case controller7RightTrigger = 0x1B6B
    case controller7Menu = 0x1B6C
    
    case controller8ButtonA = 0x1F40
    case controller8ButtonB = 0x1F41
    case controller8ButtonY = 0x1F42
    case controller8ButtonX = 0x1F43
    case controller8DpadLeft = 0x1F44
    case controller8DpadRight = 0x1F45
    case controller8DpadUp = 0x1F46
    case controller8DpadDown = 0x1F47
    case controller8LeftThumbstickLeft = 0x1F48
    case controller8LeftThumbstickRight = 0x1F49
    case controller8LeftThumbstickUp = 0x1F4A
    case controller8LeftThumbstickDown = 0x1F4B
    case controller8RightThumbstickLeft = 0x1F4C
    case controller8RightThumbstickRight = 0x1F4D
    case controller8RightThumbstickUp = 0x1F4E
    case controller8RightThumbstickDown = 0x1F4F
    case controller8LeftShoulder = 0x1F50
    case controller8RightShoulder = 0x1F51
    case controller8LeftTrigger = 0x1F52
    case controller8RightTrigger = 0x1F53
    case controller8Menu = 0x1F54
    
    case allControllersButtonA = 0x2328
    case allControllersButtonB = 0x2329
    case allControllersButtonY = 0x232A
    case allControllersButtonX = 0x232B
    case allControllersDpadLeft = 0x232C
    case allControllersDpadRight = 0x232D
    case allControllersDpadUp = 0x232E
    case allControllersDpadDown = 0x232F
    case allControllersLeftThumbstickLeft = 0x2330
    case allControllersLeftThumbstickRight = 0x2331
    case allControllersLeftThumbstickUp = 0x2332
    case allControllersLeftThumbstickDown = 0x2333
    case allControllersRightThumbstickLeft = 0x2334
    case allControllersRightThumbstickRight = 0x2335
    case allControllersRightThumbstickUp = 0x2336
    case allControllersRightThumbstickDown = 0x2337
    case allControllersLeftShoulder = 0x2338
    case allControllersRightShoulder = 0x2339
    case allControllersLeftTrigger = 0x233A
    case allControllersRightTrigger = 0x233B
    case allControllersMenu = 0x233C
    
    case touchPositive = 0x2AF8
    case touchNegative = 0x2AF9
}
