//
//  LadderClimbingPlayerComponent.swift
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

class LadderClimbingPlayerComponent: GKComponent, GlideComponent {
    
    func start() {
        let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
        
        let jumpAnimation = textureAnimatorComponent?.animation(with: "Jump")
        jumpAnimation?.addTriggersToInterruptNonLoopingAnimation(["ClimbLadder", "ClimbLadderIdle"])
        
        let landAnimation = textureAnimatorComponent?.animation(with: "Land")
        landAnimation?.addTriggersToInterruptNonLoopingAnimation(["ClimbLadder", "ClimbLadderIdle"])
        
        let animationSize = CGSize(width: 50, height: 37)
        
        let climbIdleAction = TextureAnimation.Action(textureFormat: "adventurer_climb_idle_%d",
                                                      numberOfFrames: 1,
                                                      timePerFrame: 0.1,
                                                      shouldGenerateNormalMaps: true)
        let climbIdleAnimation = TextureAnimation(triggerName: "ClimbLadderIdle",
                                                  offset: .zero,
                                                  size: animationSize,
                                                  action: climbIdleAction,
                                                  loops: true)
        climbIdleAnimation.addTriggersToInterruptNonLoopingAnimation(["ClimbLadder"])
        textureAnimatorComponent?.addAnimation(climbIdleAnimation)
        
        let climbAction = TextureAnimation.Action(textureFormat: "adventurer_climb_%d",
                                                  numberOfFrames: 4,
                                                  timePerFrame: 0.1,
                                                  shouldGenerateNormalMaps: true)
        let climbLadderAnimation = TextureAnimation(triggerName: "ClimbLadder",
                                                    offset: .zero,
                                                    size: animationSize,
                                                    action: climbAction,
                                                    loops: true)
        climbLadderAnimation.addTriggersToInterruptNonLoopingAnimation(["ClimbLadderIdle"])
        textureAnimatorComponent?.addAnimation(climbLadderAnimation)
    }
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        
        let ladderClimber = entity?.component(ofType: LadderClimberComponent.self)
        
        if ladderClimber?.isHolding == true {
            let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
            
            if entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dy != 0 {
                textureAnimatorComponent?.enableAnimation(with: "ClimbLadder")
            } else {
                textureAnimatorComponent?.enableAnimation(with: "ClimbLadderIdle")
            }
        }
    }
}
