//
//  DefaultInputProfiles.swift
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

/// List of all input profiles recognized.
/// Adding new profiles or removing existing ones can be done through `Input`.
public internal(set) var inputProfiles = [
    InputProfile(name: "MenuRight") { profile in
        profile.positiveKeys = [.rightArrow,
                                .allControllersDpadRight,
                                .allControllersLeftThumbstickRight,
                                .allControllersRightThumbstickRight]
        profile.threshold = 0.02
    },
    InputProfile(name: "MenuLeft") { profile in
        profile.positiveKeys = [.leftArrow,
                                .allControllersDpadLeft,
                                .allControllersLeftThumbstickLeft,
                                .allControllersRightThumbstickLeft]
        profile.threshold = 0.02
    },
    InputProfile(name: "MenuUp") { profile in
        profile.positiveKeys = [.upArrow,
                                .allControllersDpadUp,
                                .allControllersLeftThumbstickUp,
                                .allControllersRightThumbstickUp]
        profile.threshold = 0.02
    },
    InputProfile(name: "MenuDown") { profile in
        profile.positiveKeys = [.downArrow,
                                .allControllersDpadDown,
                                .allControllersLeftThumbstickDown,
                                .allControllersRightThumbstickDown]
        profile.threshold = 0.02
    },
    InputProfile(name: "MenuNextPage") { profile in
        profile.positiveKeys = [.rightShift,
                                .allControllersRightShoulder]
        profile.threshold = 0.02
    },
    InputProfile(name: "MenuPreviousPage") { profile in
        profile.positiveKeys = [.leftShift,
                                .allControllersLeftShoulder]
        profile.threshold = 0.02
    },
    
    InputProfile(name: "Submit") { profile in
        profile.positiveKeys = [.returnEnter,
                                .keypadEnter,
                                .allControllersButtonA]
    },
    InputProfile(name: "Cancel") { profile in
        profile.positiveKeys = [.escape,
                                .allControllersMenu,
                                .allControllersButtonB]
    },
    InputProfile(name: "Pause") { profile in
        profile.positiveKeys = [.c,
                                .allControllersMenu]
    },
    
    // Gameplay
    InputProfile(name: "Horizontal") { profile in
        profile.positiveKeys = [.rightArrow,
                                .d,
                                .controller1DpadRight,
                                .controller1LeftThumbstickRight,
                                .controller1RightThumbstickRight]
        profile.negativeKeys = [.leftArrow,
                                .a,
                                .controller1DpadLeft,
                                .controller1LeftThumbstickLeft,
                                .controller1RightThumbstickLeft]
    },
    InputProfile(name: "Vertical") { profile in
        profile.positiveKeys = [.upArrow,
                                .w,
                                .controller1DpadUp,
                                .controller1LeftThumbstickUp,
                                .controller1RightThumbstickUp]
        profile.negativeKeys = [.downArrow,
                                .s,
                                .controller1DpadDown,
                                .controller1LeftThumbstickDown,
                                .controller1RightThumbstickDown]
    },
    
    InputProfile(name: "Player1_Horizontal") { profile in
        profile.positiveKeys = [.d,
                                .controller1DpadRight,
                                .controller1LeftThumbstickRight]
        profile.negativeKeys = [.a,
                                .controller1DpadLeft,
                                .controller1LeftThumbstickLeft]
    },
    InputProfile(name: "Player2_Horizontal") { profile in
        profile.positiveKeys = [.rightArrow,
                                .controller2DpadRight,
                                .controller2LeftThumbstickRight]
        profile.negativeKeys = [.leftArrow,
                                .controller2DpadLeft,
                                .controller2LeftThumbstickLeft]
    },
    InputProfile(name: "Player3_Horizontal") { profile in
        profile.positiveKeys = [.j,
                                .controller3DpadRight,
                                .controller3LeftThumbstickRight]
        profile.negativeKeys = [.g,
                                .controller3DpadLeft,
                                .controller3LeftThumbstickLeft]
    },
    InputProfile(name: "Player4_Horizontal") { profile in
        profile.positiveKeys = [.alpha6,
                                .controller4DpadRight,
                                .controller4LeftThumbstickRight]
        profile.negativeKeys = [.alpha4,
                                .controller4DpadLeft,
                                .controller4LeftThumbstickLeft]
    },
    
    InputProfile(name: "Player1_Vertical") { profile in
        profile.positiveKeys = [.w,
                                .controller1DpadUp,
                                .controller1LeftThumbstickUp]
        profile.negativeKeys = [.s,
                                .controller1DpadDown,
                                .controller1LeftThumbstickDown]
    },
    InputProfile(name: "Player2_Vertical") { profile in
        profile.positiveKeys = [.upArrow,
                                .controller2DpadUp,
                                .controller2LeftThumbstickUp]
        profile.negativeKeys = [.downArrow,
                                .controller2DpadDown,
                                .controller2LeftThumbstickDown]
    },
    InputProfile(name: "Player3_Vertical") { profile in
        profile.positiveKeys = [.y,
                                .controller3DpadUp,
                                .controller3LeftThumbstickUp]
        profile.negativeKeys = [.h,
                                .controller3DpadDown,
                                .controller3LeftThumbstickDown]
    },
    InputProfile(name: "Player4_Vertical") { profile in
        profile.positiveKeys = [.alpha8,
                                .controller4DpadUp,
                                .controller4LeftThumbstickUp]
        profile.negativeKeys = [.alpha2,
                                .controller4DpadDown,
                                .controller4LeftThumbstickDown]
    },
    
    // Actions
    InputProfile(name: "Player1_Jump") { profile in
        profile.positiveKeys = [.space, .controller1ButtonA]
    },
    InputProfile(name: "Player2_Jump") { profile in
        profile.positiveKeys = [.n, .controller2ButtonA]
    },
    InputProfile(name: "Player3_Jump") { profile in
        profile.positiveKeys = [.o, .controller3ButtonA]
    },
    InputProfile(name: "Player4_Jump") { profile in
        profile.positiveKeys = [.pageUp, .controller4ButtonA]
    },
    
    InputProfile(name: "Player1_Shoot") { profile in
        profile.positiveKeys = [.e, .mouse0, .controller1ButtonY]
    },
    InputProfile(name: "Player2_Shoot") { profile in
        profile.positiveKeys = [.v, .controller2ButtonY]
    },
    InputProfile(name: "Player3_Shoot") { profile in
        profile.positiveKeys = [.i, .controller3ButtonY]
    },
    InputProfile(name: "Player4_Shoot") { profile in
        profile.positiveKeys = [.home, .controller4ButtonY]
    },
    
    InputProfile(name: "Player1_Jetpack") { profile in
        profile.positiveKeys = [.leftControl, .mouse0, .controller1ButtonB]
    },
    InputProfile(name: "Player2_Jetpack") { profile in
        profile.positiveKeys = [.c, .controller2ButtonB]
    },
    InputProfile(name: "Player3_Jetpack") { profile in
        profile.positiveKeys = [.l, .controller3ButtonB]
    },
    InputProfile(name: "Player4_Jetpack") { profile in
        profile.positiveKeys = [.delete, .controller4ButtonB]
    },
    
    InputProfile(name: "Player1_Paraglide") { profile in
        profile.positiveKeys = [.space, .controller1ButtonA]
    },
    InputProfile(name: "Player2_Paraglide") { profile in
        profile.positiveKeys = [.n, .controller2ButtonA]
    },
    InputProfile(name: "Player3_Paraglide") { profile in
        profile.positiveKeys = [.o, .controller3ButtonA]
    },
    InputProfile(name: "Player4_Paraglide") { profile in
        profile.positiveKeys = [.pageUp, .controller4ButtonA]
    },
    
    InputProfile(name: "Player1_Dash") { profile in
        profile.positiveKeys = [.f, .controller1RightShoulder]
    },
    InputProfile(name: "Player2_Dash") { profile in
        profile.positiveKeys = [.b, .controller2RightShoulder]
    },
    InputProfile(name: "Player3_Dash") { profile in
        profile.positiveKeys = [.p, .controller3RightShoulder]
    },
    InputProfile(name: "Player4_Dash") { profile in
        profile.positiveKeys = [.pageDown, .controller4RightShoulder]
    }
]
