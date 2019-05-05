//
//  JetpackOperatingPlayerComponent.swift
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
import GameplayKit

class JetpackOperatingPlayerComponent: GKComponent, GlideComponent {
    
    func start() {
        let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
        
        let idleAnimation = textureAnimatorComponent?.animation(with: "Idle")
        idleAnimation?.addTriggersToInterruptNonLoopingAnimation(["Jetpack"])
        
        let landAnimation = textureAnimatorComponent?.animation(with: "Land")
        landAnimation?.addTriggersToInterruptNonLoopingAnimation(["Jetpack"])
        
        //wallJumpAnimation.triggersToInterruptNonLoopingAnimation = ["Land", "Run", "WallPush", "Paraglide"]
        
        let animationSize = CGSize(width: 50, height: 37)
        let paraglideAction = TextureAnimation.Action(textureFormat: "adventurer_jetpack_%d",
                                                      numberOfFrames: 2,
                                                      timePerFrame: 0.1,
                                                      shouldGenerateNormalMaps: true)
        let paraglideAnimation = TextureAnimation(triggerName: "Jetpack",
                                                  offset: .zero,
                                                  size: animationSize,
                                                  action: paraglideAction,
                                                  loops: true)
        textureAnimatorComponent?.addAnimation(paraglideAnimation)
    }
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        
        let jetpackOperator = entity?.component(ofType: JetpackOperatorComponent.self)
        
        if jetpackOperator?.isOperatingJetpack == true {
            let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
            textureAnimatorComponent?.enableAnimation(with: "Jetpack")
        }
    }
}
