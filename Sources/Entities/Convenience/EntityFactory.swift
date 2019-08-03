//
//  EntityFactory.swift
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

/// Convenience functions for creating pre configured entities.
public class EntityFactory {
    
    // MARK: - Various entities
    
    /// Return a new ladder entity.
    ///
    /// - Parameters:
    ///     - initialNodePosition: Position for the transform node of this entity.
    ///     - colliderSize: Size of the collider component of the entity.
    ///     - tileSize: Tile size of the scene.
    public static func ladderEntity(initialNodePosition: TiledPoint,
                                    colliderSize: CGSize,
                                    tileSize: CGSize) -> GlideEntity {
        let offset = CGPoint(size: colliderSize / 2)
        let entity = GlideEntity(initialNodePosition: initialNodePosition.point(with: tileSize), positionOffset: offset)
        
        entity.name = "Ladder"
        
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        entity.addComponent(colliderComponent)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        entity.addComponent(spriteNodeComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: true)
        entity.addComponent(snappableComponent)
        
        let ladderComponent = LadderComponent()
        entity.addComponent(ladderComponent)
        
        return entity
    }
    
    /// Return a new swing entity.
    ///
    /// - Parameters:
    ///     - initialNodePosition: Position for the transform node of this entity.
    ///     - chainLengthInTiles: Height of the node of chain entity for this swing,
    /// in tile unit.
    ///     - tileSize: Tile size of the scene.
    public static func swingEntity(initialNodePosition: TiledPoint,
                                   chainLengthInTiles: Int,
                                   tileSize: CGSize) -> GlideEntity {
        let handleSize = TiledSize(1, 1).size(with: tileSize)
        let offset = CGPoint(x: handleSize.width / 2, y: handleSize.height / 2)
        let entity = GlideEntity(initialNodePosition: initialNodePosition.point(with: tileSize), positionOffset: offset)
        
        entity.name = "Swing"
        
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: handleSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        colliderComponent.isEnabled = false
        entity.addComponent(colliderComponent)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: handleSize)
        entity.addComponent(spriteNodeComponent)
        
        let swingComponent = SwingComponent(chainLengthInTiles: chainLengthInTiles)
        entity.addComponent(swingComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        entity.addComponent(snappableComponent)
        
        return entity
    }
    
    /// Return a new checkpoint entity.
    ///
    /// - Parameters:
    ///     - checkpoint: Checkpoint model this entity will represent.
    ///     - checkpointWidthInTiles: Width of the entity's collider size in
    /// tile units.
    ///     - tileSize: Tile size of the scene.
    public static func checkpointEntity(checkpoint: Checkpoint,
                                        checkpointWidthInTiles: Int,
                                        tileSize: CGSize) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: checkpoint.bottomLeftPosition.point(with: tileSize))
        entity.name = "Checkpoint-\(checkpoint.id)"
        entity.transform.usesProposedPosition = false
        
        let checkpointComponent = CheckpointComponent(checkpoint: checkpoint)
        entity.addComponent(checkpointComponent)
        
        let colliderWidth = CGFloat(checkpointWidthInTiles) * tileSize.width
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: CGSize(width: colliderWidth, height: 0),
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        colliderComponent.isEnabled = false
        entity.addComponent(colliderComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        entity.addComponent(snappableComponent)
        
        return entity
    }
    
    /// Return a new camera focus area entity.
    ///
    /// - Parameters:
    ///     - colliderSize: Size of the collider component of the entity.
    ///     - zoomArea: Zoom area frame that this entity represents.
    public static func cameraFocusAreaEntity(colliderFrame: CGRect, zoomArea: TiledRect) -> GlideEntity {
        let offset = CGPoint(size: colliderFrame.size / 2)
        let entity = GlideEntity(initialNodePosition: colliderFrame.origin, positionOffset: offset)
        entity.name = "CameraFocusArea"
        
        let cameraFocusAreaComponent = CameraFocusAreaComponent(zoomArea: zoomArea)
        entity.addComponent(cameraFocusAreaComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: colliderFrame.size,
                                                  offset: .zero, leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        colliderComponent.isEnabled = false
        entity.addComponent(colliderComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        entity.addComponent(snappableComponent)
        
        return entity
    }
    
    // MARK: - Internal
    
    static func cameraEntity(cameraNode: SKCameraNode, boundingBoxSize: CGSize) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "MainCamera"
        
        let cameraComponent = CameraComponent(cameraNode: cameraNode, boundingBoxSize: boundingBoxSize)
        entity.addComponent(cameraComponent)
        
        let shakerComponent = ShakerComponent()
        entity.addComponent(shakerComponent)
        
        return entity
    }
}
