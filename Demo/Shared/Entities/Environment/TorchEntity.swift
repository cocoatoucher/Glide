//
//  TorchEntity.swift
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

class TorchEntity: GlideEntity {
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let size = CGSize(width: 16, height: 32)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: size)
        spriteNodeComponent.offset = CGPoint(x: 0, y: -5)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNodeComponent)
        
        let animationAction = TextureAnimation.Action(textureFormat: "torch_%d",
                                                      numberOfFrames: 9,
                                                      timePerFrame: 0.1)
        let idleAnimation = TextureAnimation(triggerName: "idle",
                                             offset: .zero,
                                             size: size,
                                             action: animationAction,
                                             loops: true)
        let textureAnimatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(textureAnimatorComponent)
        
        let lightNodeComponent = LightNodeComponent(mask: DemoLightMask.torch)
        lightNodeComponent.lightNode.falloff = 2.0
        lightNodeComponent.lightNode.ambientColor = .black
        lightNodeComponent.lightNode.lightColor = .orange
        addComponent(lightNodeComponent)
        
        lightNodeComponent.lightNode.run(brightnessAction())
    }
    
    func brightnessAction() -> SKAction {
        
        var actions: [SKAction] = []
        var sign: CGFloat = 1.0
        var startBrightness: CGFloat = 2.0
        for _ in 0..<3 {
            let duration = TimeInterval.random(in: 0.1 ..< 0.3)
            let factor = CGFloat(Int.random(in: 1 ..< 4))
            
            let action = SKAction.customAction(withDuration: duration) { (node, secondsPassed) in
                if let lightNode = node as? SKLightNode {
                    lightNode.falloff = startBrightness + secondsPassed * factor * sign
                }
            }
            actions.append(action)
            
            startBrightness += CGFloat(duration) * factor * sign
            sign *= -1
        }
        
        return SKAction.repeatForever(SKAction.sequence(actions))
    }
}
