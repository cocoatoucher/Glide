//
//  OneWayGroundsScene.swift
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

class OneWayGroundsScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(iOS)
        additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Vertical", isNegative: true)])
        shouldDisplayAdditionalTouchButton = true
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
        
        return playerEntity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 250.0
        var location = TiledPoint(24, 16)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 220.0
        }
        #elseif os(tvOS)
        location = TiledPoint(24, 18)
        tipWidth = 550.0
        #endif
        let text = """
                    Meet the one way ground. It can be contacted only when approached from top. However, adventurer can use crouching while on top of it to pass through it.
                    """
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: text,
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
