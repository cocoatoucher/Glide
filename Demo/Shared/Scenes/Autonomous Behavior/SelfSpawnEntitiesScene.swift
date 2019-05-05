//
//  SelfSpawnEntitiesScene.swift
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
import GameplayKit

class SelfSpawnEntitiesScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(spawningWithTimeNPC)
        
        addEntity(spawningViaObservationNPC)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    lazy var spawningWithTimeNPC: GlideEntity = {
        let entity = MagicianEntity(initialNodePosition: TiledPoint(17, 10).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .wallContact,
                                                           axes: .horizontal,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        entity.addComponent(selfChangeDirectionComponent)
        
        let spawnComponent = SelfSpawnEntitiesComponent(spawnMethod: .onTimeInterval(interval: 3.0),
                                                        spawnEntityHandler: { [weak self] _ in
                                                            guard let self = self else { return nil }
                                                            return self.spawnedNPC(at: entity.transform.currentPosition)
        })
        entity.addComponent(spawnComponent)
        
        return entity
    }()
    
    lazy var spawningViaObservationNPC: GlideEntity = {
        let entity = MagicianEntity(initialNodePosition: TiledPoint(2, 14).point(with: tileSize))
        
        entity.removeGlideComponent(ofType: SelfMoveComponent.self)
        entity.removeGlideComponent(ofType: SelfShootOnObserveComponent.self)
        
        let observingArea = EntityObserverComponent.ObservingArea(frame: TiledRect(origin: TiledPoint(x: 1, y: 14), size: TiledSize(10, 4)), isLocal: false)
        let entityObserver = EntityObserverComponent(entityTags: ["Player"],
                                                     observingAreas: [observingArea])
        entity.addComponent(entityObserver)
        
        var spawnConfiguration = SelfSpawnEntitiesComponent.sharedConfiguration
        spawnConfiguration.minimumRestTimeBetweenSpawns = 3.0
        let spawnComponent = SelfSpawnEntitiesComponent(spawnMethod: .onEntityObserve(entityTags: ["Player"]),
                                                        configuration: spawnConfiguration,
                                                        spawnEntityHandler: { [weak self] _ in
            guard let self = self else { return nil }
            return self.spawnedNPC(at: entity.transform.currentPosition)
        })
        entity.addComponent(spawnComponent)
        
        return entity
    }()
    
    func spawnedNPC(at position: CGPoint) -> GlideEntity {
        return BirdEntity(initialNodePosition: position)
    }
    
    func setupTips() {
        var tipWidth: CGFloat = 200.0
        var location = TiledPoint(18, 14)
        #if os(tvOS)
        tipWidth = 400.0
        location = TiledPoint(18, 15)
        #endif
        
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(10, 18).point(with: tileSize),
                                          text: "On the other hand, this one spawns birds if you enter her observation area.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
        
        let tipEntity2 = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                           text: "This NPC spawns some harmless birds periodically.",
                                           frameWidth: tipWidth)
        addEntity(tipEntity2)
    }
    
}
