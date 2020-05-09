//
//  GlideScene+SpeechBubbles.swift
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

extension GlideScene {
    
    /// Call this function to start the flow of the speeches of a conversation.
    /// After calling this function provided template entities in the `Speech` objects will be
    /// initialized and added to the scene in accordance with the flow.
    ///
    /// - Parameters:
    ///     - conversation: Conversation to start the flow for.
    public func startFlowForConversation(_ conversation: Conversation) {
        conversationFlowControllerEntity.component(ofType: ConversationFlowControllerComponent.self)?.conversation = conversation
    }
    
    // MARK: - End scene
    
    /// Informs `glideSceneDelegate` of this scene to end the scene.
    ///
    /// - Parameters:
    ///     - reason: A predefined reason for ending the scene if any.
    ///     - context: Additional information to be used in context of ending the scene.
    public func endScene(reason: GlideScene.EndReason?, context: [String: Any]? = nil) {
        glideSceneDelegate?.glideSceneDidEnd(self, reason: reason, context: context)
    }
}
