//
//  GlideScene+EntityManagement.swift
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

import SpriteKit

extension GlideScene {
    
    /// Add an entity to the scene in default z position container.
    ///
    /// - Parameters:
    ///     - entity: Entity which will start getting callbacks from scene's update loop.
    /// This value's transform node will be added to the scene.
    public func addEntity(_ entity: GlideEntity) {
        let zPositionContainer = entity.zPositionContainer
        addEntity(entity, in: zPositionContainer ?? GlideZPositionContainer.default)
    }
    
    /// Add an entity to the scene in a specific z position container.
    ///
    /// - Parameters:
    ///     - entity: Entity which will start getting events from scene's update loop.
    /// This value's transform node will be added to the scene.
    ///     - zPositionContainer: Desired z position container of scene which will become
    /// the parent of the entity's transform node.
    public func addEntity(_ entity: GlideEntity, in zPositionContainer: ZPositionContainer) {
        guard let zPositionContainerNode = zPositionContainerNode(with: zPositionContainer) else {
            return
        }
        addEntity(entity, in: zPositionContainerNode)
    }
    
    /// Add an entity to the scene in a specific z position container.
    ///
    /// - Parameters:
    ///     - entity: Entity which will start getting callbacks from scene's update loop.
    /// This value's transform node will be added to the scene.
    ///     - zPositionContainer: Desired z position container of scene in which the entity's
    /// transform node will be added.
    public func addChild(_ node: SKNode, in zPositionContainer: ZPositionContainer) {
        let zPositionContainer = zPositionContainerNode(with: zPositionContainer)
        zPositionContainer?.addChild(node)
    }
    
    /// Remove an entity's transform node from the scene and stop if from getting future
    /// update loop events.
    ///
    /// - Parameters:
    ///     - entity: Entity to remove its transform node from scene.
    public func removeEntity(_ entity: GlideEntity) {
        finishEntity(entity, killIfPossible: false, isForcedRemove: true)
    }
    
    // MARK: - Helpers
    
    /// Get entities with given transform node name.
    ///
    /// - Parameters:
    ///     - nodeName: Name of the transform node for the entity.
    public func entitiesWithName(_ nodeName: String) -> [GlideEntity] {
        return entities.filter { $0.transform.node.name == nodeName }
    }
    
    /// Get entities with given tags.
    ///
    /// - Parameters:
    ///     - tags: Tags to use for querying entities.
    public func entitiesWithTags(_ tags: [String]) -> [GlideEntity] {
        return entities.filter {
            if let tag = $0.tag {
                return tags.contains(tag)
            }
            return false
        }
    }
    
    /// Get the first entity with given tag.
    ///
    /// - Parameters:
    ///     - entityTag: Tag to use for querying entities.
    public func entityWithTag(_ entityTag: String) -> GlideEntity? {
        return entities.first {
            $0.tag == entityTag
        }
    }
    
    /// Get all the entities with given tag.
    ///
    /// - Parameters:
    ///     - entityTag: Tag to use for querying entities.
    public func entitiesWithTag(_ entityTag: String) -> [GlideEntity] {
        return entities.filter {
            $0.tag == entityTag
        }
    }
    
    /// Checks whether the entity is inside camera bounds or within a reasonable distance
    /// from camera bounds.
    func isEntityInSight(_ entity: GlideEntity) -> Bool {
        guard let transformNodeParent = entity.transform.node.parent else {
            return true
        }
        guard internalEntities.contains(entity) == false else {
            return true
        }
        guard entity.component(ofType: CameraFollowerComponent.self) == nil else {
            return true
        }
        guard let camera = (cameraEntity.component(ofType: CameraComponent.self))?.cameraNode else {
            return true
        }
        guard entity.transform.nestedParentNode != zPositionContainerNode(with: GlideZPositionContainer.camera) else {
            return true
        }
        
        let offset: CGFloat = size.width
        let sightFrame = CGRect(x: -size.width / 2.0 - offset,
                                y: -size.height / 2.0 - offset,
                                width: size.width + (offset * 2.0),
                                height: size.height + (offset * 2.0))
        
        if let collider = entity.component(ofType: ColliderComponent.self) {
            let colliderFrame = collider.colliderFrameInScene
            let convertedOrigin = convert(colliderFrame.origin, to: camera)
            let convertedColliderFrame = CGRect(origin: convertedOrigin, size: colliderFrame.size)
            
            if sightFrame.intersects(convertedColliderFrame) {
                return true
            }
        } else {
            let transformPosition = entity.transform.node.position
            let convertedPosition = transformNodeParent.convert(transformPosition, to: camera)
            let accumulatedFrame = convertedPosition.centeredFrame(withSize: entity.transform.node.calculateAccumulatedFrame().size)
            
            if sightFrame.intersects(accumulatedFrame) {
                return true
            }
        }
        
        return false
    }
    
    private func addEntity(_ entity: GlideEntity, in zPositionContainerNode: SKNode) {
        guard entities.contains(entity) == false else {
            return
        }
        guard entity.component(ofType: CameraComponent.self) == nil else {
            fatalError("Adding entities with `CameraComponent` is currently not supported.")
        }
        
        if entity.component(ofType: PlayableCharacterComponent.self) != nil {
            entities.insert(entity, at: 0)
        } else {
            entities.append(entity)
        }
        
        if let respawnOnRestartComponent = entity.component(ofType: RespawnAtCheckpointOnRestartComponent.self) {
            checkpointIdsAndRespawnCallbacks.append((respawnOnRestartComponent.checkpointId, respawnOnRestartComponent.respawnedEntity))
        }
        
        entity.transform.node.removeFromParent()
        zPositionContainerNode.addChild(entity.transform.node)
        
        entity.internal_didMoveToScene(self)
    }
    
    @discardableResult
    func finishEntity(_ entity: GlideEntity,
                      killIfPossible: Bool,
                      isForcedRemove: Bool = true) -> GlideEntity? {
        guard let index = entities.firstIndex(where: { $0 === entity }) else {
            return nil
        }
        
        if killIfPossible, let healthComponent = entity.component(ofType: HealthComponent.self) {
            healthComponent.kill()
        } else if isForcedRemove || entity.canBeRemoved {
            
            entity.internal_prepareForRemoval()
            entity.transform.node.removeFromParent()
            
            for childNode in entity.transform.node.children {
                if let childEntity = childNode.entity as? GlideEntity, childEntity != entity {
                    childEntity.transform.node.removeFromParent()
                    entities.removeAll { $0 === childEntity }
                }
            }
            
            let removedEntity = entity
            entities.remove(at: index)
            return removedEntity
        }
        
        return nil
    }
    
}
