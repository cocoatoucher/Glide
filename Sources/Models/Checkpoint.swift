//
//  Checkpoint.swift
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

/// Represents a checkpoint in a scene.
public class Checkpoint: Equatable {
    
    /// Unique identifier for the checkpoint.
    /// Duplicate identifiers are validated by a `GlideScene`.
    public let id: String
    
    /// Location category of the checkpoint.
    public let location: Location
    
    /// Bottom left position to be used for this checkpoint's entity transform in
    /// screen coordinates.
    public let bottomLeftPosition: TiledPoint
    
    /// Heading direction for the transform of an entity when it spawns from this
    /// checkpoint. Respawns are controlled by the scene.
    public let spawnDirection: TransformNodeComponent.HeadingDirection
    
    // MARK: - Initialize
    
    /// Create a checkpoint.
    ///
    /// - Parameters:
    ///     - id: Unique identifier for the checkpoint.
    /// Duplicate identifiers are validated by a `GlideScene`.
    ///     - location: Location category of the checkpoint.
    ///     - bottomLeftPosition: Bottom left position to be used for this checkpoint's
    /// entity transform in screen coordinates.
    ///     - spawnDirection: Heading direction for the transform of an entity when
    /// it spawns from this checkpoint. Respawns are controlled by the scene.
    public init(id: String,
                location: Location,
                bottomLeftPosition: TiledPoint,
                spawnDirection: TransformNodeComponent.HeadingDirection) {
        self.id = id
        self.location = location
        self.bottomLeftPosition = bottomLeftPosition
        self.spawnDirection = spawnDirection
    }
    
    public static func == (lhs: Checkpoint, rhs: Checkpoint) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Checkpoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Checkpoint {
    public enum Location: String {
        /// Checkpoint that is at the beginning of a scene.
        /// There can only be 1 of this type of checkpoint in a scene.
        case start
        /// Checkpoint that is in the middle of start and finish checkpoints.
        case middle
        /// Checkpoint that is at the end of a scene.
        /// There can only be 1 of this type of checkpoint in a scene.
        case finish
    }
}
