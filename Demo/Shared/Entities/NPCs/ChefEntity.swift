//
//  ChefEntity.swift
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
import CoreGraphics
import Foundation

class ChefEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 32, height: 32)
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    override func setup() {
        name = "Chef"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let talkableNPCComponent = TalkableNPCComponent()
        addComponent(talkableNPCComponent)
        
        let talkerComponent = TalkerComponent()
        addComponent(talkerComponent)
        
        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = CGSize(width: 32, height: 32)
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "chef_idle_%d",
                                                 numberOfFrames: 12,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
    }
    
}
