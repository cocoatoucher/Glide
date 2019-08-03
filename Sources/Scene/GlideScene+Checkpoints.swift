//
//  GlideScene+Checkpoints.swift
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

public extension GlideScene {
    
    var startCheckpoint: Checkpoint? {
        return entities.compactMap {
            $0.component(ofType: CheckpointComponent.self)?.checkpoint
            }.filter { $0.location == .start }.first
    }
    
    var finishCheckpoint: Checkpoint? {
        return entities.compactMap {
            $0.component(ofType: CheckpointComponent.self)?.checkpoint
            }.filter { $0.location == .finish }.first
    }
    
    func validateCheckpoint(_ checkpointComponent: CheckpointComponent) {
        if checkpointComponent.checkpoint.location == .start && startCheckpoint != nil {
            fatalError("Start checkpoint already added")
        }
        if checkpointComponent.checkpoint.location == .finish && finishCheckpoint != nil {
            fatalError("Finish checkpoint already added")
        }
    }
    
    func checkpoint(with checkpointId: String) -> Checkpoint? {
        return entities.compactMap {
            $0.component(ofType: CheckpointComponent.self)?.checkpoint
            }.first { $0.id == checkpointId }
    }
    
    func indexOfCheckpoint(with checkpointId: String) -> Int? {
        let checkpointEntities = entities.filter { $0.component(ofType: CheckpointComponent.self) != nil }
        return checkpointEntities.firstIndex(where: { entity -> Bool in
            entity.component(ofType: CheckpointComponent.self)?.checkpoint.id == checkpointId
        })
    }
}
