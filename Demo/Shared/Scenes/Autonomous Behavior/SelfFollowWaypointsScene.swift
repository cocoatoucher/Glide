//
//  SelfFollowWaypointsScene.swift
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

class SelfFollowWaypointsScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(patrollingViaLerpingNPC)
        addEntity(patrollingViaApproachingNPC)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    lazy var patrollingViaLerpingNPC: GlideEntity = {
        let entity = CrusherEntity(initialNodePosition: TiledPoint(15, 17).point(with: tileSize), isRed: false)

        let lerpingMovementComponent = LerpingMovementComponent(speed: 5.0)
        entity.addComponent(lerpingMovementComponent)
        
        let followWaypointsComponent = SelfFollowWaypointsComponent(waypoints: [TiledPoint(15, 17), TiledPoint(20, 17), TiledPoint(20, 12), TiledPoint(15, 12)], movementStyle: .lerp)
        entity.addComponent(followWaypointsComponent)
        
        return entity
    }()
    
    lazy var patrollingViaApproachingNPC: GlideEntity = {
        let entity = CrusherEntity(initialNodePosition: TiledPoint(24, 12).point(with: tileSize), isRed: true)
        
        let size = CGSize(width: 20, height: 20)
        
        let approachingMovementComponent = ApproachingMovementComponent(speed: 10.0)
        entity.addComponent(approachingMovementComponent)
        
        let followWaypointsComponent = SelfFollowWaypointsComponent(waypoints: [TiledPoint(24, 17), TiledPoint(29, 15), TiledPoint(24, 12)], movementStyle: .approach)
        entity.addComponent(followWaypointsComponent)
        
        return entity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 240.0
        var location = TiledPoint(5, 12)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 220.0
        }
        #elseif os(tvOS)
        tipWidth = 300.0
        location = TiledPoint(5, 14)
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Those NPCs are just following the waypoints given to them and they mean no harm.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
    
}
