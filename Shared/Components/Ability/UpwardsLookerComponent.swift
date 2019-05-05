//
//  UpwardsLookerComponent.swift
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

import GameplayKit

/// Component that gives an entity the ability to adjust the camera to focus it
/// above the entity's node, if camera is already focused on this entity's transform.
public final class UpwardsLookerComponent: GKComponent, GlideComponent {
    public static let componentPriority: Int = 680
    
    /// `true` if the entity was looking upwards in the last frame.
    public private(set) var didLookUpwards: Bool = false
    
    /// `true` if the entity is looking upwards in the current frame.
    public var looksUpwards: Bool = false
    
    public var focusOffset: CGPoint = .zero
    
    public override func update(deltaTime seconds: TimeInterval) {
        if looksUpwards {
            focusOffset = CGPoint(x: 0, y: 80)
        } else {
            focusOffset = .zero
        }
    }
}

extension UpwardsLookerComponent: CameraFocusingComponent { }

extension UpwardsLookerComponent: StateResettingComponent {
    public func resetStates() {
        didLookUpwards = looksUpwards
        looksUpwards = false
    }
}
