//
//  MovingPlatformsScene.swift
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

class MovingPlatformsScene: BaseLevelScene {
    
    let horizontalPlatformTileSet = DemoTileSet.horizontalPlatformsTileSet()
    
    var verticalMovingPlatform: MovingPlatformEntity {
        let changeDirectionProfile = SelfChangeDirectionComponent.Profile(condition: .displacement(-100.0), axes: .vertical, delay: 0.3, shouldKinematicsBodyStopOnDirectionChange: false)
        let movingPlatform = MovingPlatformEntity(bottomLeftPosition: TiledPoint(13, 14),
                                                  colliderSize: TiledSize(5, 1).size(with: tileSize),
                                                  movementAxes: [.vertical],
                                                  changeDirectionProfiles: [changeDirectionProfile],
                                                  providesOneWayCollision: false,
                                                  tileSize: tileSize)
        
        let tiledNodeComponent = TileMapNodeComponent(numberOfColumns: 5, tileSet: horizontalPlatformTileSet, tileSize: tileSize)
        tiledNodeComponent.zPositionContainer = DemoZPositionContainer.platforms
        movingPlatform.addComponent(tiledNodeComponent)
        return movingPlatform
    }
    
    var horizontalMovingPlatform: MovingPlatformEntity {
        let changeDirectionProfile = SelfChangeDirectionComponent.Profile(condition: .displacement(100.0), axes: .horizontal, delay: 0.3, shouldKinematicsBodyStopOnDirectionChange: false)
        let movingPlatform = MovingPlatformEntity(bottomLeftPosition: TiledPoint(20, 14),
                                                  colliderSize: TiledSize(5, 1).size(with: tileSize),
                                                  movementAxes: [.horizontal],
                                                  changeDirectionProfiles: [changeDirectionProfile],
                                                  providesOneWayCollision: true,
                                                  tileSize: tileSize)
        
        let tiledNodeComponent = TileMapNodeComponent(numberOfColumns: 5, tileSet: horizontalPlatformTileSet, tileSize: tileSize)
        tiledNodeComponent.zPositionContainer = DemoZPositionContainer.platforms
        movingPlatform.addComponent(tiledNodeComponent)
        return movingPlatform
    }
    
    var circularMovingPlatform: MovingPlatformEntity {
        let changeDirectionProfile = SelfChangeDirectionComponent.Profile(condition: .displacement(90.0), axes: .circular, delay: 0.3, shouldKinematicsBodyStopOnDirectionChange: false)
        let movingPlatform = MovingPlatformEntity(bottomLeftPosition: TiledPoint(30, 14),
                                                  colliderSize: TiledSize(3, 1).size(with: tileSize),
                                                  movementAxes: [.circular],
                                                  changeDirectionProfiles: [changeDirectionProfile],
                                                  providesOneWayCollision: false,
                                                  tileSize: tileSize)
        
        let tiledNodeComponent = TileMapNodeComponent(numberOfColumns: 3, tileSet: horizontalPlatformTileSet, tileSize: tileSize)
        tiledNodeComponent.zPositionContainer = DemoZPositionContainer.platforms
        movingPlatform.addComponent(tiledNodeComponent)
        return movingPlatform
    }
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(verticalMovingPlatform)
        addEntity(horizontalMovingPlatform)
        addEntity(circularMovingPlatform)
        
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        addEntity(playerEntity)
        
        setupTips()
    }
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        var location = TiledPoint(5, 12)
        #if os(tvOS)
        tipWidth = 320.0
        location = TiledPoint(5, 13)
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Platforms setup with different movement components.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
