//
//  TalkerComponent.swift
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

/// Component that gives an entity the ability to keep a reference for being
/// in a conversation.
public class TalkerComponent: GKComponent, GlideComponent {
    
    /// `true` if the entity was in a conversation in the last frame.
    public private(set) var wasInConversation: Bool = false
    
    /// `true` if the entity is in a conversation in the current frame.
    /// This component blocks inputs for its entity while this value is `true`.
    public internal(set) var isInConversation: Bool = false
}

extension TalkerComponent: StateResettingComponent {
    public func resetStates() {
        wasInConversation = isInConversation
    }
}

extension TalkerComponent: InputControllingComponent {
    
    public static let componentPriority: Int = 610
    
    /// This entity will block inputs for its entity, if its scene's `activeConversation`
    /// contains this component in any of its speeches and this conversation's `blocksInputs`
    /// is `true`.
    public var shouldBlockInputs: Bool {
        if scene?.activeConversation?.containsTalker(self) == true {
            return scene?.activeConversation?.blocksInputs == true
        }
        return false
    }
}
