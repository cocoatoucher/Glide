//
//  ParaglideScene.swift
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

class ParaglideScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(iOS)
        jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Jump", isNegative: false), (name: "Player1_Paraglide", isNegative: false)])
        #endif
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: TiledPoint(5, 41).point(with: tileSize), playerIndex: 0)
        
        let paragliderComponent = ParagliderComponent()
        playerEntity.addComponent(paragliderComponent)
        
        let paraglidingPlayerComponent = ParaglidingPlayerComponent()
        playerEntity.addComponent(paraglidingPlayerComponent)
        
        return playerEntity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        #if os(tvOS)
        tipWidth = 350.0
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 44).point(with: tileSize),
                                          text: "Jump into the emptiness and use the jump key on mid air to fly...",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
