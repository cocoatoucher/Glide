//
//  GemEntity.swift
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

class GemEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 14, height: 14)
    
    init(bottomLeftPosition: CGPoint) {
        super.init(initialNodePosition: bottomLeftPosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let collider = ColliderComponent(categoryMask: DemoCategoryMask.collectible,
                                         size: colliderSize,
                                         offset: .zero,
                                         leftHitPointsOffsets: (0, 0),
                                         rightHitPointsOffsets: (0, 0),
                                         topHitPointsOffsets: (0, 0),
                                         bottomHitPointsOffsets: (0, 0))
        addComponent(collider)
        
        let spriteNode = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNode.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNode)
        
        let textureAction = TextureAnimation.Action(textureFormat: "gem_red_%d",
                                                    numberOfFrames: 2,
                                                    timePerFrame: 0.1)
        let textureAnimation = TextureAnimation(triggerName: "idle",
                                                offset: .zero,
                                                size: colliderSize,
                                                action: textureAction,
                                                loops: true)
        let textureAnimator = TextureAnimatorComponent(entryAnimation: textureAnimation)
        addComponent(textureAnimator)
        
        let collectibleComponent = CollectibleComponent()
        addComponent(collectibleComponent)
    }
    
}
