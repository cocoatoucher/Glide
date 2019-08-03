//
//  TextureAnimationAction.swift
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

extension TextureAnimation {
    
    /// Representation of the values for creating a `SKAction` that animates textures.
    public struct Action {
        public let textureFormat: String
        public let numberOfFrames: Int
        public let timePerFrame: TimeInterval
        public let isReverse: Bool
        public let textureAtlas: SKTextureAtlas?
        public let shouldGenerateNormalMaps: Bool
        
        // MARK: - Initialize
        
        /// Create a texture animation action.
        ///
        /// - Parameters:
        ///     - textureFormat: Format string for the image file name of the texture. E.g. `idle_%d`.
        ///     - numberOfFrames: Number of images that the action has. Index of each frame will be
        /// replaced within the `textureFormat` e.g. idle_0, idle_1 for `numberOfFrames` = 2.
        ///     - timePerFrame: How many seconds each frame of the animation will play.
        ///     - isReverse: Wheter the textures will be places in reverse ordered index list of
        /// `numberOfFrames`.
        ///     - textureAtlas: Texture atlas to be used for the textures of the action.
        ///     - shouldGenerateNormalMaps: `true` if a normal map should be generated for each
        /// texture of this animation.
        public init(textureFormat: String,
                    numberOfFrames: Int,
                    timePerFrame: TimeInterval,
                    isReverse: Bool = false,
                    textureAtlas: SKTextureAtlas? = nil,
                    shouldGenerateNormalMaps: Bool = false) {
            self.textureFormat = textureFormat
            self.numberOfFrames = numberOfFrames
            self.timePerFrame = timePerFrame
            self.isReverse = isReverse
            self.textureAtlas = textureAtlas
            self.shouldGenerateNormalMaps = shouldGenerateNormalMaps
        }
        
        // MARK: - Internal
        
        func animation(withLoops loops: Bool) -> SKAction {
            return SKAction.textureAnimation(textureFormat: textureFormat,
                                             numberOfFrames: numberOfFrames,
                                             timePerFrame: timePerFrame,
                                             loops: loops,
                                             isReverse: isReverse,
                                             textureAtlas: textureAtlas,
                                             shouldGenerateNormalMaps: shouldGenerateNormalMaps)
        }
    }
}
