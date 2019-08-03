//
//  TextureAnimation.swift
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

import SpriteKit

/// Represents an animation object that control animations actions for its given textures.
public class TextureAnimation {
    
    /// Id that will be used to trigger playing this animation.
    public let triggerName: String
    
    /// Position that the entity's sprite node will have once the animation is triggered.
    public let offset: CGPoint
    
    /// Size that the entity's sprite node will have once the animation is triggered
    public let size: CGSize
    
    /// All the texture animation actions that this animation has.
    /// Those actions are used to randomize the texture animations. Placement weight for each action
    /// determines how frequently an action will be displayed. Actions with higher placement weight
    /// are displayed more frequently than others. Actions with placement weight of 0 or below are
    /// never displayed.
    public let actionsAndPlacementWeights: [(action: Action, placementWeight: Int)]?
    
    /// `true` if the current loop will consist of a combination of
    /// different actions or one randomly chosen action on each animation start.
    public var combinesRandomActionsOnLoop: Bool = false
    
    /// `true` if the action of the animation is looped.
    public let loops: Bool
    
    /// List of triggers that can stop this animation and play, even if this animation
    /// is not looping.
    /// Looping animations can always be interrupted.
    public private(set) var triggersToInterruptNonLoopingAnimation: [String] = []
    
    /// Create a texture animation component.
    ///
    /// - Parameters:
    ///     - triggerName: Id that will be used to trigger playing this animation.
    ///     - offset: Position that the entity's sprite node will have once the animation
    /// is triggered.
    ///     - size: Size that the entity's sprite node will have once the animation is triggered.
    ///     - actionsAndPlacementWeights: All the texture animation actions that this animation
    /// has.
    /// Those actions are used to randomize the texture animations. Placement weight for each action
    /// determines how frequently an action will be displayed. Actions with higher placement weight
    /// are displayed more frequently than others. Actions with placement weight of 0 or below are
    /// never displayed.
    ///     - combinesRandomActionsOnLoop: `true` if the current loop will consist of a combination of
    /// different actions or one randomly chosen action on each animation start.
    ///     - loops: `true` if the action of the animation is looped.
    ///     - textureAtlas: Texture atlas to be used for populating texture animation actions.
    ///     - shouldGenerateNormalMaps: `true` if a normal map should be generated for each texture
    /// of this animation.
    public init(triggerName: String,
                offset: CGPoint,
                size: CGSize,
                actionsAndPlacementWeights: [(action: Action, placementWeight: Int)],
                combinesRandomActionsOnLoop: Bool,
                loops: Bool) {
        self.id = "\(mach_absolute_time())"
        self.triggerName = triggerName
        self.offset = offset
        self.size = size
        self.actionsAndPlacementWeights = actionsAndPlacementWeights
        self.loops = loops
        
        self.baseAction = actionsAndPlacementWeights[0].action.animation(withLoops: loops)
        self.combinesRandomActionsOnLoop = combinesRandomActionsOnLoop
    }
    
    /// Create a texture animation.
    ///
    /// - Parameters:
    ///     - triggerName: Id that will be used to trigger playing this animation.
    ///     - offset: Position that the entity's sprite node will have once the animation is triggered.
    ///     - size: Size that the entity's sprite node will have once the animation is triggered.
    ///     - action: Single action that will be used populate the animtion for the animation.
    ///     - loops: `true` if the action of the animation is looped.
    ///     - textureAtlas: Texture atlas to be used for populating texture animation actions.
    ///     - shouldGenerateNormalMaps: `true` if a normal map should be generated for each texture
    /// of this animation.
    public convenience init(triggerName: String,
                            offset: CGPoint,
                            size: CGSize,
                            action: Action,
                            loops: Bool) {
        self.init(triggerName: triggerName,
                  offset: offset,
                  size: size,
                  actionsAndPlacementWeights: [(action, 0)],
                  combinesRandomActionsOnLoop: false,
                  loops: loops)
    }
    
    /// Adds the trigger name of another animation to the List of triggers that
    /// can stop this animation and start playing, even if this animation is not
    /// looping.
    /// Looping animations can always be interrupted.
    public func addTriggerToInterruptNonLoopingAnimation(_ triggerName: String) {
        triggersToInterruptNonLoopingAnimation.append(triggerName)
    }
    
    /// Adds the trigger name of other animations to the List of triggers that
    /// can stop this animation and start playing, even if this animation is not
    /// looping.
    /// Looping animations can always be interrupted.
    public func addTriggersToInterruptNonLoopingAnimation(_ triggerNames: [String]) {
        triggerNames.forEach { triggersToInterruptNonLoopingAnimation.append($0) }
    }
    
    /// Removes the trigger name of another animation from the List of triggers that
    /// can interrupt this animation.
    public func removeTriggerToInterruptNonLoopingAnimation(_ triggerName: String) {
        if let index = triggersToInterruptNonLoopingAnimation.firstIndex(of: triggerName) {
            triggersToInterruptNonLoopingAnimation.remove(at: index)
        }
    }
    
    /// Removes the trigger name of other animations from the List of triggers that
    /// can interrupt this animation.
    public func removeTriggersToInterruptNonLoopingAnimation(_ triggerNames: [String]) {
        triggerNames.forEach { removeTriggerToInterruptNonLoopingAnimation($0) }
    }
    
    // MARK: - Private
    
    let id: String
    let baseAction: SKAction
    /// Whether that animation is currently triggered.
    var isTriggerEnabled: Bool = false
    /// Whether another animation could start while this animation is playing.
    var allowsTransition: Bool {
        return isPlayingAnimation == false || loops
    }
    var didPlayOnce: Bool = false
    /// `true` if the animation action of the animation is currently playing
    var isPlayingAnimation: Bool = false {
        didSet {
            if isPlayingAnimation {
                didPlayOnce = true
            }
        }
    }
    
    /// Action of the animation to play. Possible return values are a combination of randomly
    /// chosen actions or a single randomly chosen action or the single base action of the
    /// animation if there was no randomization specified at the initialization.
    var action: SKAction {
        if let actionsAndPlacementWeights = actionsAndPlacementWeights,
            actionsAndPlacementWeights.isEmpty == false,
            actionsAndPlacementWeights.filter({ $0.placementWeight > 0 }).isEmpty == false {
            
            if loops {
                if combinesRandomActionsOnLoop {
                    let randomActions = [0..<20].map { _ in randomAction(within: actionsAndPlacementWeights) }
                    return SKAction.repeatForever(SKAction.sequence(randomActions))
                } else {
                    let randomAction = self.randomAction(within: actionsAndPlacementWeights)
                    return SKAction.repeatForever(randomAction)
                }
            } else {
                return randomAction(within: actionsAndPlacementWeights)
            }
        }
        
        return baseAction
    }
    
    /// Returns a random action from the list of given actions respecting their placement weights
    private func randomAction(within actionsAndPlacementWeights: [(action: Action, placementWeight: Int)]) -> SKAction {
        var sumOfWeights: Int = 0
        for animationAndPlacementWeight in actionsAndPlacementWeights {
            sumOfWeights += animationAndPlacementWeight.placementWeight
        }
        var random = Int.random(in: 0 ..< actionsAndPlacementWeights.count)
        for animationAndWeight in actionsAndPlacementWeights {
            if random < animationAndWeight.placementWeight {
                return animationAndWeight.action.animation(withLoops: false)
            }
            random -= animationAndWeight.placementWeight
        }
        return actionsAndPlacementWeights[0].action.animation(withLoops: false)
    }
}
