//
//  SpikeEntity.swift
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

class SpikeEntity: GlideEntity {
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 32, height: 32))
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNodeComponent)
        
        let hazardComponent = HazardComponent()
        addComponent(hazardComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.hazard,
                                                  size: CGSize(width: 20, height: 32),
                                                  offset: CGPoint(x: 0, y: -32),
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        addComponent(colliderComponent)
        
        let animationSize = CGSize(width: 32, height: 32)
        let animationAction = TextureAnimation.Action(textureFormat: "spike_%d", numberOfFrames: 20, timePerFrame: 0.1)
        let openAndCloseAnimation = TextureAnimation(triggerName: "openAndClose",
                                                     offset: .zero,
                                                     size: animationSize,
                                                     action: animationAction,
                                                     loops: true)
        let textureAnimatorComponent = TextureAnimatorComponent(entryAnimation: openAndCloseAnimation)
        
        addComponent(textureAnimatorComponent)
        
        textureAnimatorComponent.enableAnimation(with: "openAndClose")
        
        let moveColliderDelay = SKAction.wait(forDuration: 1.0)
        let moveColliderUp = SKAction.customAction(withDuration: 0.5) { (_, secondsPassed) in
            colliderComponent.offset = CGPoint(x: 0, y: -32 + (secondsPassed / 0.5) * 32)
        }
        let moveColliderDown = SKAction.customAction(withDuration: 0.5) { (_, secondsPassed) in
            colliderComponent.offset = CGPoint(x: 0, y: (secondsPassed / 0.5) * -32)
        }
        let moveColliderUpAndDown = SKAction.repeatForever(SKAction.sequence([moveColliderDelay, moveColliderUp, moveColliderDown]))

        transform.node.run(moveColliderUpAndDown)
    }
    
}
