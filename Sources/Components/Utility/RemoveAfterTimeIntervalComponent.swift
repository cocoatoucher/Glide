//
//  RemoveAfterTimeIntervalComponent.swift
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

/// This component sets its entity's `canBeRemoved` to 'true' after a given period of time
/// starting with the first time this entity.
public class RemoveAfterTimeIntervalComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 500
    
    /// Total amount of time that the entity will be removed from its scene
    /// in seconds.
    public let expireTime: TimeInterval
    
    /// Callback that returns an animation entity to be added to scene right before
    /// removing this entity.
    public let removalAnimationEntity: (() -> GlideEntity?)?
    
    // MARK: - Initialize
    
    /// Create a remove after time interval component.
    ///
    /// - Parameters:
    ///     - expireTime: Total amount of time that the entity will be removed from
    /// its scene in seconds.
    ///     - removalAnimationEntity: Callback that returns an animation entity to be added to
    /// scene right before removing this entity.
    public init(expireTime: TimeInterval, removalAnimationEntity: (() -> GlideEntity?)? = nil) {
        self.expireTime = expireTime
        self.removalAnimationEntity = removalAnimationEntity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func update(deltaTime seconds: TimeInterval) {
        timePassed += seconds
        if timePassed >= expireTime {
            isExpired = true
            if let removalAnimationEntity = removalAnimationEntity?() {
                scene?.addEntity(removalAnimationEntity)
            }
        }
    }
    
    public func willBeRemovedFromEntity() {
        prepareForReuse()
    }
    
    public func entityWillBeRemovedFromScene() {
        prepareForReuse()
    }
    
    // MARK: - Private
    
    private var timePassed: TimeInterval = 0
    private var isExpired: Bool = false
    
    private func prepareForReuse() {
        timePassed = 0
        isExpired = false
    }
}

extension RemoveAfterTimeIntervalComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return isExpired
    }
}
