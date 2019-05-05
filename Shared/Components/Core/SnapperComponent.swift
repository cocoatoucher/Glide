//
//  SnapperComponent.swift
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

/// Component that is used to establish collisions with snappable objects
/// like platforms and ladders. Snapping is a special behavior which helps with
/// partially establishing collisions between moving objects.
public final class SnapperComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 930
    
    public private(set) var wasSnapping: Bool = false
    /// `true` if the entity is snapping to a snapper in the current frame.
    public var isSnapping: Bool = false
    /// Position returned from this callback is used in every update cycle to
    /// the position of the entity's tranform. This callback is to be set by a
    /// snappable component which sets and returns a modified proposed position.
    public var snappedPositionCallback: ((TransformNodeComponent) -> CGPoint?)?
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        guard let transform = transform else {
            return
        }
        
        if isSnapping {
            if let snappedProposedPosition = snappedPositionCallback?(transform) {
                transform.proposedPosition = snappedProposedPosition
            }
        }
    }
}

extension SnapperComponent: StateResettingComponent {
    public func resetStates() {
        wasSnapping = isSnapping
        isSnapping = false
        
        snappedPositionCallback = nil
    }
}
