//
//  ParallaxBackgroundEntity.swift
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

class ParallaxBackgroundEntity: GlideEntity {
    
    let followCameraComponent: CameraFollowerComponent
    let infiniteSpriteScroller: InfiniteSpriteScrollerComponent
    let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
    let layoutSpriteNodeComponent = SceneAnchoredSpriteLayoutComponent()
    let texture: SKTexture
    
    init(texture: SKTexture,
         widthConstraint: NodeLayoutConstraint,
         heightConstraint: NodeLayoutConstraint,
         yOffsetConstraint: NodeLayoutConstraint,
         cameraFollowMethod: CameraFollowerComponent.PositionUpdateMethod,
         autoScrollSpeed: CGFloat = 0.0) {
        
        self.followCameraComponent = CameraFollowerComponent(positionUpdateMethod: cameraFollowMethod)
        self.infiniteSpriteScroller = InfiniteSpriteScrollerComponent(scrollAxis: .horizontal, autoScrollSpeed: autoScrollSpeed)
        
        self.texture = texture
        
        super.init(initialNodePosition: CGPoint.zero, positionOffset: CGPoint.zero)
        
        layoutSpriteNodeComponent.widthConstraint = widthConstraint
        layoutSpriteNodeComponent.heightConstraint = heightConstraint
        layoutSpriteNodeComponent.yOffsetConstraint = yOffsetConstraint
    }
    
    override func setup() {
        
        transform.usesProposedPosition = false
        
        spriteNodeComponent.spriteNode.texture = texture
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.farBackground
        addComponent(spriteNodeComponent)
        
        addComponent(layoutSpriteNodeComponent)
        
        addComponent(followCameraComponent)
        
        addComponent(infiniteSpriteScroller)
    }
}
