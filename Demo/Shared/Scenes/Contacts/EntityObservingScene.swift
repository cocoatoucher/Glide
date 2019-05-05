//
//  EntityObservingScene.swift
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

class EntityObservingScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(observingNPCWithLocalObserverArea)
        addEntity(observingNPCWithGlobalObserverArea)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    func observingNPC(at position: TiledPoint) -> GlideEntity {
        let entity = SpiderEntity(initialNodePosition: position.point(with: tileSize))
        
        let changeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .displacement(100), axes: .horizontal, delay: 0.3, shouldKinematicsBodyStopOnDirectionChange: false)
        changeDirectionComponent.profiles.append(profile)
        entity.addComponent(changeDirectionComponent)
        
        return entity
    }
    
    lazy var observingNPCWithLocalObserverArea: GlideEntity = {
        let entity = observingNPC(at: TiledPoint(15, 10))
        
        var configuration = EntityObserverComponent.sharedConfiguration
        configuration.shouldKinematicsBodyStopWhenObserving = true
        let observingArea = EntityObserverComponent.ObservingArea(frame: TiledRect(origin: TiledPoint(x: 0, y: 0), size: TiledSize(6, 6)), isLocal: true)
        let entityObserver = EntityObserverComponent(entityTags: ["Player"],
                                                     observingAreas: [observingArea],
                                                     configuration: configuration)
        entity.addComponent(entityObserver)
        
        return entity
    }()
    
    lazy var observingNPCWithGlobalObserverArea: GlideEntity = {
        let entity = observingNPC(at: TiledPoint(20, 15))
        
        var configuration = EntityObserverComponent.sharedConfiguration
        configuration.shouldKinematicsBodyStopWhenObserving = true
        let observingArea = EntityObserverComponent.ObservingArea(frame: TiledRect(origin: TiledPoint(x: 15, y: 15), size: TiledSize(14, 6)), isLocal: false)
        let entityObserver = EntityObserverComponent(entityTags: ["Player"],
                                                     observingAreas: [observingArea],
                                                     configuration: configuration)
        entity.addComponent(entityObserver)
        
        return entity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        #elseif os(tvOS)
        tipWidth = 400.0
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 14).point(with: tileSize),
                                          text: "These spiders will react in funny ways when our adventurer gets into their observation areas.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
