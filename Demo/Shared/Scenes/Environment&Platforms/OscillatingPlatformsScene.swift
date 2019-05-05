//
//  OscillatingPlatformsScene.swift
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

class OscillatingPlatformsScene: BaseLevelScene {
    
    let horizontalPlatformTileSet = DemoTileSet.horizontalPlatformsTileSet()
    
    var oscillatingPlatform: GlideEntity {
        let platformSize = TiledSize(width: 3, height: 1).size(with: tileSize)
        let offsetSize = platformSize
        let offset = CGPoint(x: offsetSize.width, y: offsetSize.height)
        let platform = GlideEntity(initialNodePosition: TiledPoint(10, 14).point(with: tileSize),
                                   positionOffset: offset)
        
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: platformSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        platform.addComponent(colliderComponent)
        
        let tiledNodeComponent = TileMapNodeComponent(numberOfColumns: 3, tileSet: horizontalPlatformTileSet, tileSize: tileSize)
        tiledNodeComponent.zPositionContainer = DemoZPositionContainer.platforms
        platform.addComponent(tiledNodeComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 5.0
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 3.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        platform.addComponent(kinematicsBodyComponent)
        
        let platformComponent = PlatformComponent()
        platform.addComponent(platformComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        platform.addComponent(snappableComponent)
        
        let oscillatingMovementComponent = OscillatingMovementComponent(period: 0.5, axesAndSpeed: CGVector(dx: 40, dy: 20))
        platform.addComponent(oscillatingMovementComponent)
        return platform
    }
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(oscillatingPlatform)
        
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        addEntity(playerEntity)
        
        setupTips()
    }
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        #if os(tvOS)
        tipWidth = 300.0
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Who doesn't like sine waves?",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
