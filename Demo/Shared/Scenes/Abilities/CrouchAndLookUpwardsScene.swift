//
//  CrouchAndLookUpwardsScene.swift
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

class CrouchAndLookUpwardsScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(iOS)
        additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Vertical", isNegative: false)])
        shouldDisplayAdditionalTouchButton = true
        
        secondAdditionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Vertical", isNegative: true)])
        shouldDisplaySecondAdditionalTouchButton = true
        #endif
        
        #if os(OSX)
        #endif
        
        addEntity(playerEntity)
        
        setupTips()
    }

    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)

        let croucherComponent = CroucherComponent()
        playerEntity.addComponent(croucherComponent)

        let crouchingPlayerComponent = CrouchingPlayerComponent()
        playerEntity.addComponent(crouchingPlayerComponent)
        
        let upwardsLookerComponent = UpwardsLookerComponent()
        playerEntity.addComponent(upwardsLookerComponent)

        return playerEntity
    }()
    
    func setupTips() {
        #if os(OSX)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the vertical direction keys (w - s) to look upwards and crouch.",
                                          frameWidth: 220.0)
        addEntity(tipEntity)
        #elseif os(iOS)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the vertical direction touch buttons or game controller keys to look upwards and crouch.",
                                          frameWidth: 220.0)
        addEntity(tipEntity)
        #elseif os(tvOS)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 14).point(with: tileSize),
                                          text: "Use vertical swiping on the remote or game controller vertical direction keys to look upwards and crouch.",
                                          frameWidth: 400.0)
        addEntity(tipEntity)
        #endif
        
        var tip2Width: CGFloat = 220.0
        #if os(tvOS)
        tip2Width = 300.0
        #endif
        let tip2Entity = GameplayTipEntity(initialNodePosition: TiledPoint(20, 15).point(with: tileSize),
                                           text: "Crouch over this platform to pass through it downwards.",
                                           frameWidth: tip2Width)
        addEntity(tip2Entity)
    }
}
