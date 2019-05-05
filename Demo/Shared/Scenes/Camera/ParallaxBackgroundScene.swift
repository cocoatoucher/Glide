//
//  ParallaxBackgroundScene.swift
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

class ParallaxBackgroundScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        addEntity(parallaxSkyEntity)
        addEntity(parallaxMoonEntity)
        addEntity(parallaxCloudsEntity)
        addEntity(parallaxBackgroundEntity)
        addEntity(parallaxDarkMountainsEntity)
        addEntity(parallaxDarkTreesEntity)
        addEntity(parallaxTreesEntity)
        
        addEntity(playerEntity)
    }
    
    lazy var playerEntity: GlideEntity = {
        let entity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        return entity
    }()
    
    lazy var parallaxSkyEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_bg"),
                                              widthConstraint: .proportionalToSceneSize(1.0),
                                              heightConstraint: .proportionalToSceneSize(1.0),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -2.0, verticalSpeed: nil))
        entity.transform.node.zPosition = 0
        return entity
    }()
    
    lazy var parallaxMoonEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_moon"),
                                              widthConstraint: .constant(1632),
                                              heightConstraint: .constant(480),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -2.0, verticalSpeed: nil),
                                              autoScrollSpeed: -5.0)
        entity.transform.node.zPosition = 1
        return entity
    }()
    
    lazy var parallaxCloudsEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_clouds"),
                                              widthConstraint: .constant(1632),
                                              heightConstraint: .constant(480),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -2.0, verticalSpeed: nil),
                                              autoScrollSpeed: -30.0)
        entity.transform.node.zPosition = 2
        return entity
    }()
    
    lazy var parallaxMountainsEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_mountains_back"),
                                              widthConstraint: .constant(1632),
                                              heightConstraint: .constant(480),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -6.0, verticalSpeed: nil))
        entity.transform.node.zPosition = 3
        return entity
    }()
    
    lazy var parallaxDarkMountainsEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_mountains_front"),
                                              widthConstraint: .constant(1632),
                                              heightConstraint: .constant(480),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -7.0, verticalSpeed: nil))
        entity.transform.node.zPosition = 4
        return entity
    }()
    
    lazy var parallaxDarkTreesEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_trees_dark"),
                                              widthConstraint: .constant(1632),
                                              heightConstraint: .constant(480),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -7.0, verticalSpeed: nil))
        entity.transform.node.zPosition = 5
        return entity
    }()
    
    lazy var parallaxTreesEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_trees"),
                                              widthConstraint: .constant(1632),
                                              heightConstraint: .constant(480),
                                              yOffsetConstraint: .proportionalToSceneSize(0.1),
                                              cameraFollowMethod: .linear(horizontalSpeed: -10.0, verticalSpeed: nil))
        entity.transform.node.zPosition = 6
        return entity
    }()
}
