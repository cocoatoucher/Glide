//
//  SelfShootOnObserveComponent.swift
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

/// Component that makes an entity with observing capabilities to shoot towards
/// the closest entity among its observed entities.
///
/// Required components:
/// - `EntityObserverComponent`
/// - `ProjectileShooterComponent`
public final class SelfShootOnObserveComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 570
    
    /// Tags of entities to shoot amongst observed entities.
    public let entityTagsToShoot: [String]
    
    /// Entity that was being shot in the last frame.
    public private(set) var didShootAtEntity: GlideEntity?
    
    /// Entity that is being shot in the current frame.
    public private(set) weak var shootsAtEntity: GlideEntity?
    
    // MARK: - Initialize
    
    /// Create a self shoot on observe component.
    ///
    /// - Parameters:
    ///     - entityTagsToShoot: Tags of entities to shoot amongst observed
    /// entities.
    public init(entityTagsToShoot: [String]) {
        self.entityTagsToShoot = entityTagsToShoot
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        shootIfNeeded(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var shootingRestTimer: TimeInterval = 0.0
    private var axesAndMovementDirectionBeforeShooting: [(MovementAxes, Direction)] = []
    
    private func shootIfNeeded(deltaTime seconds: TimeInterval) {
        guard let observerComponent = entity?.component(ofType: EntityObserverComponent.self) else {
            return
        }
        guard let projectileShooterComponent = entity?.component(ofType: ProjectileShooterComponent.self) else {
            return
        }
        
        let entitiesToShoot = entityTagsToShoot.compactMap { entityTag -> [GlideEntity]? in
            if observerComponent.didObserveEntities.contains(entityTag) {
                return scene?.entitiesWithTag(entityTag)
            }
            return nil
        }.joined()
        guard entitiesToShoot.isEmpty == false else {
            shootingRestTimer = 0
            return
        }
        
        let closestObservedEntity: GlideEntity? = entitiesToShoot.sorted { (entity1, _) -> Bool in
            let distance1 = transform?.currentPosition.distanceTo(entity1.transform.currentPosition) ?? 0
            let distance2 = transform?.currentPosition.distanceTo(entity1.transform.currentPosition) ?? 0
            return distance1 < distance2
            }.first
        shootingRestTimer = 0
        shootsAtEntity = closestObservedEntity
        projectileShooterComponent.shoots = true
    }
}

extension SelfShootOnObserveComponent: StateResettingComponent {
    public func resetStates() {
        didShootAtEntity = shootsAtEntity
        shootsAtEntity = nil
    }
}
