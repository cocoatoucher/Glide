//
//  CroucherComponent.swift
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

/// Component that gives an entity the ability to ignore one way grounds while
/// its entity is above them and pass through below the ground.
/// This component is also used by `PlayableCharacterComponent` which makes
/// it possible to react to crouching via assigning a custom texture animation.
public final class CroucherComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 670
    
    /// `true` if the entity was crouching in the last frame.
    public private(set) var didCrouch: Bool = false
    
    /// `true` if the entity is crouching in the current frame.
    public var crouches: Bool = false
    
    public override func update(deltaTime seconds: TimeInterval) {
        if crouches {
            entity?.component(ofType: ColliderComponent.self)?.pushesDown = true
            transform?.proposedPosition = (transform?.currentPosition ?? .zero) - CGPoint(x: 0, y: 1)
        }
    }
}

extension CroucherComponent: StateResettingComponent {
    public func resetStates() {
        didCrouch = crouches
        crouches = false
    }
}
