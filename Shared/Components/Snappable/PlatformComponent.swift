//
//  PlatformComponent.swift
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

/// Component that provides snapping behaviors of a platform.
public final class PlatformComponent: GKComponent, GlideComponent {
    
    /// `true` if the component's entity is affected by gravity.
    /// Entity should have a `KinematicsBodyComponent` for this to work.
    public var isGravityEnabled: Bool = false
    
    public override func update(deltaTime seconds: TimeInterval) {
        guard let kinematicsBodyComponent = (entity?.component(ofType: KinematicsBodyComponent.self)) else {
            return
        }
        if isGravityEnabled == false {
            kinematicsBodyComponent.gravityInEffect = 0
        }
    }
    
    public func handleNewCollision(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    public func handleExistingCollision(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    // MARK: - Private
    
    private func handleSnapping(with contact: Contact) {
        let otherEntity = contact.otherObject.colliderComponent?.entity
        guard let snapper = otherEntity?.component(ofType: SnapperComponent.self) else {
            return
        }
        
        if contact.otherContactSides?.contains(.bottom) == true {
            snapper.isSnapping = true
            snapper.snappedPositionCallback = { [weak self] transform in
                guard let self = self else { return nil }
                guard let selfTransform = self.transform else { return nil }
                return CGPoint(x: transform.proposedPosition.x + selfTransform.currentTranslation.dx,
                               y: transform.proposedPosition.y + selfTransform.currentTranslation.dy)
            }
        }
    }
}
