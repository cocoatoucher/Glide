//
//  ConversationFlowControllerComponent.swift
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

public extension Notification.Name {
    static let ConversationDidStart = Notification.Name("GlideSceneConversationDidStart")
    static let ConversationDidEnd = Notification.Name("GlideSceneConversationDidEnd")
}

/// Component that controls the flow of speech bubble entities for a given conversation
/// in its entity's scene.
final class ConversationFlowControllerComponent: GKComponent, GlideComponent {
    
    /// Conversation that this flow controller is currently managing.
    var conversation: Conversation? {
        didSet {
            if oldValue == nil && conversation != nil {
                NotificationCenter.default.post(name: .ConversationDidStart,
                                                object: self,
                                                userInfo: nil)
            } else if oldValue != nil && conversation == nil {
                NotificationCenter.default.post(name: .ConversationDidEnd,
                                                object: self,
                                                userInfo: nil)
            }
            
            oldValue?.speeches.forEach {
                $0.talker?.isInConversation = false
            }
            if let speechEntity = speechEntity {
                scene?.removeEntity(speechEntity)
                self.speechEntity = nil
            }
            conversation?.speeches.forEach {
                $0.talker?.isInConversation = true
            }
            currentSpeech = conversation?.speeches[0]
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard conversation != nil else {
            return
        }
        
        displaySpeechIfNeeded(deltaTime: seconds)
        proceedToNextSpeechIfNeeded()
    }
    
    /// MARK: - Private
    
    /// Speech that's being currently displayed.
    private var currentSpeech: Speech?
    
    /// Entity for the speech that was being displayed in the last frame.
    private var speechEntity: GlideEntity?
    
    private func displaySpeechIfNeeded(deltaTime: TimeInterval) {
        guard let currentSpeech = currentSpeech else {
            return
        }
        if speechEntity == nil {
            let entity = speechEntity(currentSpeech, at: .zero)
            speechEntity = entity
            scene?.addEntity(entity)
        }
    }
    
    private func proceedToNextSpeechIfNeeded() {
        guard speechEntity?.component(ofType: SpeechFlowControllerComponent.self)?.isFinished == true else {
            return
        }
        guard let nextSpeech = speechEntity?.component(ofType: SpeechFlowControllerComponent.self)?.nextSpeech else {
            self.conversation = nil
            return
        }
        
        if let speechEntity = speechEntity {
            scene?.removeEntity(speechEntity)
            self.speechEntity = nil
        }
        currentSpeech = nextSpeech
    }
    
    private func speechEntity(_ speech: Speech, at position: CGPoint) -> GlideEntity {
        let entity = speech.speechBubbleTemplate.init(initialNodePosition: position, speech: speech)
        return entity
    }
}
