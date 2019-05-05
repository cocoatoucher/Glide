//
//  SelfShootOnObserveScene.swift
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

class SelfShootOnObserveScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: DemoCategoryMask.projectile, and: GlideCategoryMask.colliderTile)
        mapContact(between: DemoCategoryMask.projectile, and: GlideCategoryMask.snappable)
        
        addEntity(shootingNPC)
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    lazy var shootingNPC: GlideEntity = {
        let entity = MagicianEntity(initialNodePosition: TiledPoint(22, 14).point(with: tileSize))
        
        let changeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .gapContact, axes: .horizontal, delay: 2.0, shouldKinematicsBodyStopOnDirectionChange: true)
        changeDirectionComponent.profiles.append(profile)
        entity.addComponent(changeDirectionComponent)
        
        var entityObserverConfig = EntityObserverComponent.sharedConfiguration
        entityObserverConfig.shouldKinematicsBodyStopWhenObserving = true
        let observingArea = EntityObserverComponent.ObservingArea(frame: TiledRect(origin: TiledPoint(x: 15, y: 11), size: TiledSize(17, 12)), isLocal: false)
        let entityObserver = EntityObserverComponent(entityTags: ["Player"],
                                                     observingAreas: [observingArea],
                                                     configuration: entityObserverConfig)
        entity.addComponent(entityObserver)
        
        return entity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 260.0
        var location = TiledPoint(5, 12)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 220.0
        }
        #elseif os(tvOS)
        tipWidth = 350.0
        location = TiledPoint(5, 15)
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "This NPC is serious and will shoot if you enter her observation area. Luckily, our adventurer is immortal in this scene.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
    
}
