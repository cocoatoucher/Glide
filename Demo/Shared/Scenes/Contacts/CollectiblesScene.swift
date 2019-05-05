//
//  CollectiblesScene.swift
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

class CollectiblesScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.collectible)
        
        addEntity(gemEntity(at: TiledPoint(13, 12)))
        addEntity(gemEntity(at: TiledPoint(16, 12)))
        addEntity(gemEntity(at: TiledPoint(19, 12)))
        addEntity(playerEntity)
        addEntity(gemCounterEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let updateGemCounterComponent = UpdateGemCounterComponent(gemCounterEntity: gemCounterEntity)
        entity.addComponent(updateGemCounterComponent)
        
        return entity
    }()
    
    var gemCounterEntity = GemCounterEntity(initialNodePosition: .zero)
    
    func gemEntity(at position: TiledPoint) -> GlideEntity {
        return GemEntity(bottomLeftPosition: position.point(with: tileSize))
    }
    
    func setupTips() {
        var tipWidth: CGFloat = 240.0
        var location = TiledPoint(5, 12)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        #elseif os(tvOS)
        tipWidth = 350.0
        location = TiledPoint(5, 13)
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Collect some gems and track them via the gem counter.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
