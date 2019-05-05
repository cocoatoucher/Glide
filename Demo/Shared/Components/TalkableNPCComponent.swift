//
//  TalkableNPCComponent.swift
//  glide Demo
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

import GlideEngine
import GameplayKit

class TalkableNPCComponent: GKComponent, GlideComponent {
    
    var inputIndicatorEntity: InteractionIndicatorEntity?
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        if entity?.component(ofType: TalkerComponent.self)?.isInConversation == true {
            removeIndicatorIfNeeded()
            return
        }
        
        guard let entityObserverComponent = entity?.component(ofType: EntityObserverComponent.self) else {
            return
        }
        
        let observes = entityObserverComponent.observesEntities.contains("Player")
        if observes {
            if inputIndicatorEntity == nil {
                let indicatorEntity = InteractionIndicatorEntity(size: CGSize(width: 44.0, height: 44.0), yOffset: 20.0, inputProfile: "Talk")
                inputIndicatorEntity = indicatorEntity
                scene?.addEntity(indicatorEntity)
                indicatorEntity.transform.parentTransform = transform
            }
        } else {
            removeIndicatorIfNeeded()
        }
    }
    
    private func removeIndicatorIfNeeded() {
        if let indicatorEntity = inputIndicatorEntity {
            scene?.removeEntity(indicatorEntity)
            inputIndicatorEntity = nil
        }
    }
}
