//
//  SelfPatrollingScene.swift
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

class SelfPatrollingScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(patrollingWithWallContactNPC)
        addEntity(patrollingWithGapContactNPC)
        addEntity(patrollingWithTimeIntervalNPC)
        addEntity(patrollingWithDisplacementNPC)
        addEntity(patrollingWithPatrolAreaNPC)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    lazy var patrollingWithWallContactNPC: GlideEntity = {
        let npc = FoxEntity(initialNodePosition: TiledPoint(20, 10).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .wallContact,
                                                           axes: .horizontal,
                                                           delay: 0.3,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }()
    
    lazy var patrollingWithGapContactNPC: GlideEntity = {
        let npc = ImpEntity(initialNodePosition: TiledPoint(12, 16).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .gapContact,
                                                           axes: .horizontal,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: true)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }()
    
    lazy var patrollingWithTimeIntervalNPC: GlideEntity = {
        let npc = WitchEntity(initialNodePosition: TiledPoint(20, 16).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .timeInterval(2.5),
                                                           axes: .horizontal,
                                                           delay: 0.3,
                                                           shouldKinematicsBodyStopOnDirectionChange: true)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }()
    
    lazy var patrollingWithDisplacementNPC: GlideEntity = {
        let npc = DistanceWalkerEntity(initialNodePosition: TiledPoint(32, 10).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .displacement(100.0),
                                                           axes: .horizontal,
                                                           delay: 0.3,
                                                           shouldKinematicsBodyStopOnDirectionChange: true)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }()
    
    lazy var patrollingWithPatrolAreaNPC: GlideEntity = {
        let npc = EagleEntity(initialNodePosition: TiledPoint(34, 16).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let patrolArea = TiledRect(origin: TiledPoint(31, 18), size: TiledSize(9, 5)).rect(with: tileSize)
        
        let profile = SelfChangeDirectionComponent.Profile(condition: .patrolArea(patrolArea),
                                                           axes: .vertical,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 240.0
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 220.0
        }
        #elseif os(tvOS)
        tipWidth = 350.0
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(12, 12).point(with: tileSize),
                                          text: "Enjoy some NPCs that patrol on their own and don't care much about our adventurer.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
    
}
