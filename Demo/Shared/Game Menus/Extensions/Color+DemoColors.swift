//
//  Color+DemoColors.swift
//  glide Demo
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

import GlideEngine

extension Color {
    static var defaultTextColor: Color {
        return Color.black
    }
    
    static var mainBackgroundColor: Color {
        return Color(red: 178/255, green: 220/255, blue: 239/255, alpha: 1.0)
    }
    
    static var hudBackgroundColor: Color {
        return Color(red: 178/255, green: 220/255, blue: 239/255, alpha: 1.0)
    }
    
    static var levelThumbBackgroundColor: Color {
        return Color(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
    }
    
    static var touchHighlightColor: Color {
        return Color(red: 41/255, green: 112/255, blue: 164/255, alpha: 1.00)
    }
    
    static var selectionAnimationBlueColor: Color {
        return Color(red: 49/255, green: 162/255, blue: 242/255, alpha: 1.00)
    }
    
    static var selectionAnimationDarkerBlueColor: Color {
        return Color(red: 41/255, green: 112/255, blue: 164/255, alpha: 1.00)
    }
    
    static var navigationFocusRedBorderColor: Color {
        return Color(red: 0, green: 73/255, blue: 132/255, alpha: 1.00)
    }
    
    static var backButtonTextColor: Color {
        return Color.white
    }
    
    static var backButtonBackgroundColor: Color {
        return Color.clear
    }
}
