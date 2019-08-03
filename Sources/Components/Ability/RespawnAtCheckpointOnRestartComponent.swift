//
//  RespawnAtCheckpointOnRestartComponent.swift
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

/// Component that gives an entity the ability to be respawned when scene restarts
/// at its checkpoint with `checkpointId` given to this component.
public final class RespawnAtCheckpointOnRestartComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 610
    
    /// If index of the checkpoint that the game is restarting from is smaller than or equal
    /// to the index of the checkpoint with this id, entity will be removed and added back.
    /// That is useful for restarting game elements like enemies and collectibles that appears
    /// after a completed checkpoint when a playable character is restarting from this checkpoint.
    public let checkpointId: String
    
    /// Callback to provide the respawned entity that will be added at restart.
    public let respawnedEntity: (() -> GlideEntity)
    
    // MARK: - Initialize
    
    /// Create a checkpoint recognizer component.
    ///
    /// - Parameters:
    ///     - checkpointId: Id of the checkpoint that this component's entity belong to.
    ///     - respawnedEntity: Callback to return the respawned entity.
    public init(checkpointId: String, respawnedEntity: @escaping () -> GlideEntity) {
        self.respawnedEntity = respawnedEntity
        self.checkpointId = checkpointId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
