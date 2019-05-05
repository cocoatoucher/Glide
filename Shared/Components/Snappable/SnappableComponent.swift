//
//  SnappableComponent.swift
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

/// Snapping is a special behavior which helps with establishing collisions between moving
/// objects. Add this component to your entity to make other objects with `SnapperComponent`
/// collide with it or snap on it. Specific snapping behavior for your entity should be
/// implemented in your custom components. For an example of this see `PlatformComponent`.
/// An entity with Snappable component always gets updated before other custom entities.
public final class SnappableComponent: GKComponent, GlideComponent {
    
    /// `true` if the entity behaves as a one way collider on collisions with
    /// other entities, that is they only collide with their bottom side over
    /// top side of this entity.
    public let providesOneWayCollision: Bool
    
    // MARK: - Initialize
    
    /// Create a snappable component.
    ///
    /// - Parameters:
    ///     - providesOneWayCollision: `true` if the entity behaves as a one way collider on
    /// collisions.
    public init(providesOneWayCollision: Bool) {
        self.providesOneWayCollision = providesOneWayCollision
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
