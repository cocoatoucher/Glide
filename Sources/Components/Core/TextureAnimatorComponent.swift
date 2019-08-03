//
//  TextureAnimatorComponent.swift
//  glide
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

import GameplayKit
import SpriteKit

/// Component that is used to play texture animation actions on the entity's sprite node.
/// Uses `SKAction`s for the actual animations and uses predefined trigger ids to
/// switch between playing animations.
///
/// Required components: `SpriteNodeComponent`
public final class TextureAnimatorComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 920
    
    /// Create a texture animator component.
    ///
    /// - Parameters:
    ///     - entryAnimation: Animation to start playing from the first update.
    public init(entryAnimation: TextureAnimation) {
        self.entryAnimation = entryAnimation
        super.init()
        
        addAnimation(entryAnimation)
        currentAnimation = entryAnimation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add an animation which can be triggered at a later time.
    ///
    /// - Parameters:
    ///     - animation: Animation to be added.
    public func addAnimation(_ animation: TextureAnimation) {
        guard animations.contains(where: { $0.id == animation.id }) == false else {
            fatalError("An animation with same id already exists.")
        }
        guard animations.contains(where: { $0.triggerName == animation.triggerName }) == false else {
            fatalError("Animation trigger with same name already exists.")
        }
        animations.append(animation)
    }
    
    /// Retrieve the animation with the given trigger name.
    ///
    /// - Parameters:
    ///     - triggerName: Trigger name of the desired animation.
    public func animation(with triggerName: String) -> TextureAnimation? {
        return animations.first { $0.triggerName == triggerName }
    }
    
    /// Enable a trigger to be played at the next update.
    ///
    /// - Parameters:
    ///     - triggerName: Trigger name of the animation.
    public func enableAnimation(with triggerName: String) {
        let animation = animations.first { $0.triggerName == triggerName }
        animation?.isTriggerEnabled = true
        animation?.didPlayOnce = false
    }
    
    public func didFinishUpdate() {
        animations.forEach { $0.isTriggerEnabled = false }
    }
    
    // MARK: - Private
    
    /// Animation to be played at the first update.
    private let entryAnimation: TextureAnimation
    
    /// All animations that were added to this texture animator.
    private var animations: [TextureAnimation] = []
    
    /// Currently playing animation.
    private var currentAnimation: TextureAnimation?
    
    private func updateAnimations() {
        stopCurrentAnimationIfNeeded()
        playCurrentAnimationIfNeeded()
        setSpriteScaleForHeadingDirection()
    }
    
    private func stopCurrentAnimationIfNeeded() {
        guard let currentAnimation = currentAnimation else {
            return
        }
        
        let activatedAnimation = animations.filter { $0.isTriggerEnabled }.last
        if let activatedAnimation = activatedAnimation, currentAnimation.id != activatedAnimation.id {
            
            let canCurrentAnimationBeInterrupted = currentAnimation.allowsTransition == false &&
                currentAnimation.triggersToInterruptNonLoopingAnimation.contains { $0 == activatedAnimation.triggerName } == true
            if currentAnimation.allowsTransition == true || canCurrentAnimationBeInterrupted {
                let oldAnimation = currentAnimation
                self.currentAnimation = activatedAnimation
                
                oldAnimation.didPlayOnce = false
                oldAnimation.isPlayingAnimation = false
                entity?.component(ofType: SpriteNodeComponent.self)?.node.removeAction(forKey: oldAnimation.id)
            }
        }
    }
    
    private func playCurrentAnimationIfNeeded() {
        guard
            let currentAnimation = currentAnimation,
            currentAnimation.isPlayingAnimation == false,
            currentAnimation.didPlayOnce == false
        else {
            return
        }
        
        let spriteNodeComponent = entity?.component(ofType: SpriteNodeComponent.self)
        let node = spriteNodeComponent?.node
        (node as? SKSpriteNode)?.size = currentAnimation.size
        spriteNodeComponent?.additionalOffset = currentAnimation.offset
        
        currentAnimation.isPlayingAnimation = true
        
        if currentAnimation.loops == false {
            node?.run(currentAnimation.action) {
                self.currentAnimation?.isPlayingAnimation = false
            }
        } else {
            node?.run(currentAnimation.action, withKey: currentAnimation.id)
        }
    }
    
    private func setSpriteScaleForHeadingDirection() {
        guard let headingDirection = transform?.headingDirection else {
            return
        }
        guard let spriteNode = entity?.component(ofType: SpriteNodeComponent.self)?.spriteNode else {
            return
        }
        switch headingDirection {
        case .left:
            spriteNode.xScale = -abs(spriteNode.xScale)
        case .right:
            spriteNode.xScale = abs(spriteNode.xScale)
        }
    }
}

extension TextureAnimatorComponent: ActionsEvaluatorComponent {
    func sceneDidEvaluateActions() {
        updateAnimations()
    }
}
