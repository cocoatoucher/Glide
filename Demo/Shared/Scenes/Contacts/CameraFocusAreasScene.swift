//
//  CameraFocusAreasScene.swift
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

class CameraFocusAreasScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(iOS)
        additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Vertical", isNegative: false)])
        shouldDisplayAdditionalTouchButton = true
        
        secondAdditionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Vertical", isNegative: true)])
        shouldDisplaySecondAdditionalTouchButton = true
        #endif
        
        addEntity(cameraFocusAreaEntity)
        
        let ladder = EntityFactory.ladderEntity(initialNodePosition: TiledPoint(1, 12),
                                                colliderSize: TiledSize(2, 13).size(with: tileSize),
                                                tileSize: tileSize)
        addEntity(ladder)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let cameraFocusAreaRecognizer = CameraFocusAreaRecognizerComponent()
        entity.addComponent(cameraFocusAreaRecognizer)
        
        let ladderClimberComponent = LadderClimberComponent()
        entity.addComponent(ladderClimberComponent)
        
        let croucherComponent = CroucherComponent()
        entity.addComponent(croucherComponent)
        
        let ladderClimbingPlayerComponent = LadderClimbingPlayerComponent()
        entity.addComponent(ladderClimbingPlayerComponent)
        
        return entity
    }()
    
    lazy var cameraFocusAreaEntity: GlideEntity = {
        let colliderFrame = TiledRect(origin: TiledPoint(x: 9, y: 25), size: TiledSize(3, 2)).rect(with: tileSize)
        let zoomArea = TiledRect(origin: TiledPoint(x: 12, y: 8), size: TiledSize(40, 25))
        return GlideEngine.EntityFactory.cameraFocusAreaEntity(colliderFrame: colliderFrame, zoomArea: zoomArea)
    }()
    
    func setupTips() {
        var tipWidth: CGFloat = 220.0
        var location = TiledPoint(14, 12)
        #if os(tvOS)
        tipWidth = 350.0
        location = TiledPoint(14, 14)
        #endif
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Climb the ladders and enjoy the view from the top of our terrace.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
