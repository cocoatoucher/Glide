//
//  ItemChestEntity.swift
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

class ItemChestEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 20, height: 12)
    
    init(bottomLeftPosition: CGPoint) {
        super.init(initialNodePosition: bottomLeftPosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let collider = ColliderComponent(categoryMask: DemoCategoryMask.itemChest,
                                         size: colliderSize,
                                         offset: .zero,
                                         leftHitPointsOffsets: (0, 0),
                                         rightHitPointsOffsets: (0, 0),
                                         topHitPointsOffsets: (0, 0),
                                         bottomHitPointsOffsets: (0, 0))
        addComponent(collider)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        addComponent(snappableComponent)
        
        let itemChestComponent = ItemChestComponent()
        addComponent(itemChestComponent)
        
        let animationSize = CGSize(width: 32, height: 32)
        let animationOffset = CGPoint(x: 0, y: 10)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: animationSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.items
        spriteNodeComponent.offset = animationOffset
        addComponent(spriteNodeComponent)
        
        setupTextureAnimator()
    }
    
    func setupTextureAnimator() {
        let animationSize = CGSize(width: 32, height: 32)
        
        let closedAction = TextureAnimation.Action(textureFormat: "chest_closed_%d",
                                                   numberOfFrames: 1,
                                                   timePerFrame: 0.1)
        let closedAnimation = TextureAnimation(triggerName: "Closed",
                                               offset: .zero,
                                               size: animationSize,
                                               action: closedAction,
                                               loops: true)
        let textureAnimatorComponent = TextureAnimatorComponent(entryAnimation: closedAnimation)
        
        let openingAction = TextureAnimation.Action(textureFormat: "chest_opening_%d",
                                                    numberOfFrames: 3,
                                                    timePerFrame: 0.1)
        let openingAnimation = TextureAnimation(triggerName: "Opening",
                                                offset: .zero,
                                                size: animationSize,
                                                action: openingAction,
                                                loops: false)
        textureAnimatorComponent.addAnimation(openingAnimation)
        
        let openedAction = TextureAnimation.Action(textureFormat: "chest_opened_%d",
                                                   numberOfFrames: 1,
                                                   timePerFrame: 0.1)
        let openedAnimation = TextureAnimation(triggerName: "Opened",
                                               offset: .zero,
                                               size: animationSize,
                                               action: openedAction,
                                               loops: true)
        textureAnimatorComponent.addAnimation(openedAnimation)
        
        addComponent(textureAnimatorComponent)
    }
    
}
