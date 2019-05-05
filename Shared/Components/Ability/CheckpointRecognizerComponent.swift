//
//  CheckpointRecognizerComponent.swift
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

/// Component that gives an entity the ability to recognize the checkpoints and save
/// them in a list upon contact.
public final class CheckpointRecognizerComponent: GKComponent, GlideComponent, RespawnableEntityComponent {
    
    public static let componentPriority: Int = 650
    
    // MARK: - RespawnableEntityComponent
    
    /// Scene will ask for a new entity to be added to after this entity is removed from the scene.
    /// Provide this callback to return a new entity to be respawned.
    public var respawnedEntity: ((_ numberOfRespawnsLeft: Int) -> GlideEntity)?
    
    /// Represents the number of times this entity can be respawned from any of its recognized
    /// checkpoints.
    public internal(set) var numberOfRespawnsLeft: Int
    
    /// Provide this call back to be informed when this component's entity passes checkpoints in the scene.
    public var checkpointPassed: ((_ checkpoint: Checkpoint) -> Void)?
    
    /// List of the checkpoints in the scene that the entity has made contact with
    /// for at least once.
    public internal(set) var passedCheckpoints: [Checkpoint] = [] {
        didSet {
            let difference = passedCheckpoints.difference(from: oldValue)
            for checkpoint in difference {
                checkpointPassed?(checkpoint)
            }
        }
    }
    
    // MARK: - Initialize
    
    /// Create a checkpoint recognizer component.
    ///
    /// - Parameters:
    ///     - numberOfRespawns: Number of times that this component's entity can respawn.
    public init(numberOfRespawnsLeft: Int) {
        self.numberOfRespawnsLeft = numberOfRespawnsLeft
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
