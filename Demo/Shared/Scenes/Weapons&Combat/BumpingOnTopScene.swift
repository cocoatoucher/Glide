//
//  BumpingOnTopScene.swift
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
import GameplayKit

class BumpingOnTopScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.npc)
        
        addEntity(patrollingWithDisplacementNPC)
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
    
        let bumpAttackerComponent = BumpAttackerComponent()
        entity.addComponent(bumpAttackerComponent)
        
        let bouncerComponent = BouncerComponent(contactCategoryMasks: nil)
        entity.addComponent(bouncerComponent)
        
        return entity
    }()
    
    lazy var patrollingWithDisplacementNPC: GlideEntity = {
        let npc = EagleEntity(initialNodePosition: TiledPoint(14, 11).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let patrolArea = TiledRect(origin: TiledPoint(14, 11), size: TiledSize(1, 4)).rect(with: tileSize)
        
        let profile = SelfChangeDirectionComponent.Profile(condition: .patrolArea(patrolArea),
                                                           axes: .vertical,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 1.0)
        npc.addComponent(healthComponent)
        
        return npc
    }()
    
    func setupTips() {
        
        var tipWidth: CGFloat = 240.0
        var location = TiledPoint(5, 12)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        #elseif os(tvOS)
        tipWidth = 300.0
        location = TiledPoint(5, 13)
        #endif
        
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Try to bump on top of this harmless eagle to eliminate it.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
