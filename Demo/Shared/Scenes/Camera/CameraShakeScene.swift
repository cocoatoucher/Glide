//
//  CameraShakeScene.swift
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

class CameraShakeScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.triggerZone)
        
        addEntity(triggerZoneEntity)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    lazy var triggerZoneEntity: GlideEntity = {
        let zoneSize = TiledSize(14, 1).size(with: tileSize)
        let offset = zoneSize / 2
        let entity = GlideEntity(initialNodePosition: TiledPoint(x: 18, y: 10).point(with: tileSize),
                                 positionOffset: CGPoint(x: offset.width, y: offset.height))
        entity.name = "TriggerZone"
        
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.none,
                                                  size: zoneSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0), 
                                                  bottomHitPointsOffsets: (0, 0))
        entity.addComponent(colliderComponent)
        
        let triggerZoneComponent = TriggerZoneComponent(callback: { didEnter in
            self.cameraEntity.component(ofType: ShakerComponent.self)?.shakes = didEnter
        })
        entity.addComponent(triggerZoneComponent)
        
        return entity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 240.0
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        #elseif os(tvOS)
        tipWidth = 300.0
        #endif
        
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Walk over the lava to shake it up...",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
