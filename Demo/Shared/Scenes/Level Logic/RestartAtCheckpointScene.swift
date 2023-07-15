//
//  RestartAtCheckpointScene.swift
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
import SpriteKit

class RestartAtCheckpointScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.collectible)
        
        /// It is recommended to generate those ids with an id generator
        let startCheckpoint = Checkpoint(id: "0",
                                         location: Checkpoint.Location.start,
                                         bottomLeftPosition: TiledPoint(10, 10),
                                         spawnDirection: TransformNodeComponent.HeadingDirection.right)
        let startCheckpointEntity = EntityFactory.checkpointEntity(checkpoint: startCheckpoint,
                                                                   checkpointWidthInTiles: 3,
                                                                   tileSize: tileSize)
        addEntity(startCheckpointEntity)
        
        let endCheckpoint = Checkpoint(id: "1",
                                       location: Checkpoint.Location.middle,
                                       bottomLeftPosition: TiledPoint(42, 10),
                                       spawnDirection: TransformNodeComponent.HeadingDirection.right)
        let endCheckpointEntity = EntityFactory.checkpointEntity(checkpoint: endCheckpoint,
                                                                 checkpointWidthInTiles: 3,
                                                                 tileSize: tileSize)
        addEntity(endCheckpointEntity)
        
        let finishCheckpoint = Checkpoint(id: "2",
                                          location: Checkpoint.Location.finish,
                                          bottomLeftPosition: TiledPoint(91, 10),
                                          spawnDirection: TransformNodeComponent.HeadingDirection.right)
        let finishCheckpointEntity = EntityFactory.checkpointEntity(checkpoint: finishCheckpoint,
                                                                    checkpointWidthInTiles: 3,
                                                                    tileSize: tileSize,
                                                                    stretchesToTop: true)
        addEntity(finishCheckpointEntity)
        
        addEntity(gemCounterEntity)
        
        let player = RestartAtCheckpointScene.playerEntity(at: startCheckpoint, numberOfRespawnsLeft: 2, tileSize: tileSize, gemCounterEntity: gemCounterEntity)
        addEntity(player)
        
        // Start checkpoint entities
        addEntity(RestartAtCheckpointScene.gemEntity(at: TiledPoint(21, 12),
                                                     checkpointId: "0",
                                                     tileSize: tileSize,
                                                     gemCounterEntity: gemCounterEntity))
        
        // Middle checkpoint entities
        addEntity(RestartAtCheckpointScene.gemEntity(at: TiledPoint(47, 12),
                                                     checkpointId: "1",
                                                     tileSize: tileSize,
                                                     gemCounterEntity: gemCounterEntity))
        
        setupTips()
    }
    
    var gemCounterEntity = GemCounterEntity(initialNodePosition: .zero)
    
    static func playerEntity(at checkpoint: Checkpoint,
                             numberOfRespawnsLeft: Int,
                             tileSize: CGSize,
                             gemCounterEntity: GemCounterEntity) -> GlideEntity {
        let playerEntity = SimplePlayerEntity(initialNodePosition: (checkpoint.bottomLeftPosition + TiledPoint(0, 2)).point(with: tileSize), playerIndex: 0)
        
        let checkpointRecognizerComponent = CheckpointRecognizerComponent(numberOfRespawnsLeft: numberOfRespawnsLeft)
        
        checkpointRecognizerComponent.respawnedEntity = { [weak checkpointRecognizerComponent] numberOfRespawns in
            let lastCheckpoint = checkpointRecognizerComponent?.passedCheckpoints.last ?? checkpoint
            return RestartAtCheckpointScene.playerEntity(at: lastCheckpoint,
                                                         numberOfRespawnsLeft: numberOfRespawns - 1,
                                                         tileSize: tileSize,
                                                         gemCounterEntity: gemCounterEntity)
        }
        
        checkpointRecognizerComponent.checkpointPassed = { [weak checkpointRecognizerComponent] checkpoint in
            if checkpoint.location == .finish {
                checkpointRecognizerComponent?.scene?.endScene(reason: .playableCharacterReachedFinishCheckpoint)
            }
        }
        
        playerEntity.addComponent(checkpointRecognizerComponent)
        
        let updateGemCounterComponent = UpdateGemCounterComponent(gemCounterEntity: gemCounterEntity)
        playerEntity.addComponent(updateGemCounterComponent)
        
        return playerEntity
    }
    
    static func gemEntity(at position: TiledPoint,
                          checkpointId: String,
                          tileSize: CGSize,
                          gemCounterEntity: GemCounterEntity) -> GlideEntity {
        let entity = GemEntity(bottomLeftPosition: position.point(with: tileSize))
        
        let respawnAtCheckpointOnRestartComponent = RespawnAtCheckpointOnRestartComponent(checkpointId: checkpointId) { () -> GlideEntity in
            
            if entity.component(ofType: CollectibleComponent.self)?.isCollected == true {
                // Decrease current gem count by the number of respawned gems to not count unearned gems.
                gemCounterEntity.numberOfGems -= 1
            }
            
            return RestartAtCheckpointScene.gemEntity(at: position,
                                                      checkpointId: checkpointId,
                                                      tileSize: tileSize,
                                                      gemCounterEntity: gemCounterEntity)
        }
        entity.addComponent(respawnAtCheckpointOnRestartComponent)
        
        return entity
    }
    
    static func someEntity(position: TiledPoint, checkpointId: String, tileSize: CGSize) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: position.point(with: tileSize))
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 20, height: 20))
        spriteNodeComponent.spriteNode.color = .yellow
        entity.addComponent(spriteNodeComponent)
        
        let respawnAtCheckpointOnRestartComponent = RespawnAtCheckpointOnRestartComponent(checkpointId: checkpointId) { () -> GlideEntity in
            
            return RestartAtCheckpointScene.someEntity(position: position,
                                                       checkpointId: checkpointId,
                                                       tileSize: tileSize)
        }
        entity.addComponent(respawnAtCheckpointOnRestartComponent)
        
        return entity
    }
    
    func setupTips() {
        var tipWidth: CGFloat = 280.0
        var location = TiledPoint(5, 13)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 250.0
        }
        #elseif os(tvOS)
        tipWidth = 600.0
        location = TiledPoint(7, 16)
        #endif
        
        let text = """
                    There is a checkpoint near each pillar on this map.
                    Try falling from some holes to see the gems which belong to a specific checkpoint be respawned.
                    Notice that the gem counter also resets for each respawned entity.
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: text,
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
