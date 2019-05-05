//
//  SwingsScene.swift
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

class SwingsScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        let swing = EntityFactory.swingEntity(initialNodePosition: TiledPoint(8, 20),
                                              chainLengthInTiles: 5,
                                              tileSize: tileSize)
        swing.component(ofType: SwingComponent.self)?.chainEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode.texture = SKTexture(nearestFilteredImageName: "swing_chain")
        swing.component(ofType: SpriteNodeComponent.self)?.zPositionContainer = DemoZPositionContainer.platforms
        swing.component(ofType: SpriteNodeComponent.self)?.spriteNode.texture = SKTexture(nearestFilteredImageName: "swing_handle")
        swing.component(ofType: SpriteNodeComponent.self)?.offset = CGPoint(x: 0, y: -5)
        addEntity(swing)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let swingHolderComponent = SwingHolderComponent()
        playerEntity.addComponent(swingHolderComponent)
        
        return playerEntity
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        #if os(tvOS)
        tipWidth = 500.0
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(17, 12).point(with: tileSize),
                                          text: "Use horizontal direction keys to fasten or slow down the swing in desired direction.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
