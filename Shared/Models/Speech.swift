//
//  Speech.swift
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

import Foundation

/// Represents options to choose from at the end of a speech.
public struct SpeechOption {
    public let text: String
    public let targetSpeech: Speech
    
    public init(text: String, targetSpeech: Speech) {
        self.text = text
        self.targetSpeech = targetSpeech
    }
}

/// Represents list of text chunks that is typically displayed in a visual speech bubble.
/// A speech might contain one or more text blocks, whereas one or more speeches compose
/// a conversation.
public class Speech {
    
    /// Text blocks that compose a speech when combined.
    public let textBlocks: [String]
    
    /// Options to choose from which will be displayed with the last text block of a speech.
    /// Default value is empty list.
    public var options: [SpeechOption] = []
    
    /// Talker component of the entity to which this speech belongs.
    public weak var talker: TalkerComponent?
    
    /// `true` if the speech entity displayed for this speech should be anchored to
    /// the entity of the given `talker`.
    /// `false` if speech entity should be displayed somewhere else in the scene.
    /// This is only a flag and it's up to the speech bubble entity to determine and
    /// handle the details of the layout.
    public let displaysOnTalkerPosition: Bool
    
    /// Entity that will be initialized to display this speech.
    public let speechBubbleTemplate: SpeechBubbleTemplateEntity.Type
    
    /// Represents any other information that should be carried along this speech.
    public let context: [String: Any]?
    
    // MARK: - Initialize
    
    /// Create a speech.
    ///
    /// - Parameters:
    ///     - textBlocks: Text blocks that compose a speech when combined.
    ///     - talker: Talker component of the entity to which this speech belongs.
    ///     - displaysOnTalkerPosition: `true` if the speech entity displayed for this
    /// speech should be anchored to the entity of the given `talker`.
    ///     - speechBubbleTemplate: Entity that will be initialized to display this speech.
    ///     - context: Represents any other information that should be carried along this speech.
    /// Might come in handy to use in your speech bubble template entity.
    public init(textBlocks: [String],
                talker: TalkerComponent?,
                displaysOnTalkerPosition: Bool,
                speechBubbleTemplate: SpeechBubbleTemplateEntity.Type,
                context: [String: Any]? = nil) {
        self.textBlocks = textBlocks
        self.talker = talker
        self.displaysOnTalkerPosition = displaysOnTalkerPosition
        self.speechBubbleTemplate = speechBubbleTemplate
        self.context = context
    }
    
    /// Create a speech composed of a single text block.
    ///
    /// - Parameters:
    ///     - text: Single text block that makes this speech.
    ///     - talker: Talker component of the entity to which this speech belongs.
    ///     - displaysOnTalkerPosition: `true` if the speech entity displayed for
    /// this speech should be anchored to the entity of the given `talker`.
    ///     - speechBubbleTemplate: Entity that will be initialized to display this speech.
    ///     - context: Represents any other information that should be carried along this speech.
    /// Might come in handy to use in your speech bubble template entity.
    public convenience init(text: String,
                            talker: TalkerComponent?,
                            displaysOnTalkerPosition: Bool,
                            speechBubbleTemplate: SpeechBubbleTemplateEntity.Type,
                            context: [String: Any]? = nil) {
        self.init(textBlocks: [text],
                  talker: talker,
                  displaysOnTalkerPosition: displaysOnTalkerPosition,
                  speechBubbleTemplate: speechBubbleTemplate,
                  context: context)
    }
    
    /// Adds an option to be display with last text block of this entity.
    public func addOption(_ option: SpeechOption) {
        options.append(option)
    }
}
