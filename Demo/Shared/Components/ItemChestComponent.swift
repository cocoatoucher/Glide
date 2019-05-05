//
//  ItemChestComponent.swift
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

import GameplayKit
import GlideEngine

class ItemChestComponent: GKComponent, GlideComponent {
    
    private(set) var wasOpen: Bool = false
    var isOpen: Bool = false
    
    private var didPlayOpeningAnimation: Bool = false
    
    let magicAnimationEntity = DemoEntityFactory.magicAnimationEntity(at: .zero)
    
    var inputIndicatorEntity: InteractionIndicatorEntity?
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        guard let entityObserverComponent = entity?.component(ofType: EntityObserverComponent.self) else {
            return
        }
        
        let observes = entityObserverComponent.observesEntities.contains("Player")
        if observes {
            if inputIndicatorEntity == nil && didPlayOpeningAnimation == false {
                let indicatorEntity = InteractionIndicatorEntity(size: CGSize(width: 44.0, height: 44.0), yOffset: 20.0, inputProfile: "PickUpItem")
                inputIndicatorEntity = indicatorEntity
                scene?.addEntity(indicatorEntity)
                indicatorEntity.transform.parentTransform = transform
            }
            
            if inputIndicatorEntity?.component(ofType: FocusableComponent.self)?.wasSelected == true {
                didPlayOpeningAnimation = true
                entity?.component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "Opening")
            } else if didPlayOpeningAnimation {
                didOpenChest()
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
    
    private func didOpenChest() {
        entity?.component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "Opened")
        if let transform = transform, isOpen == false {
            
            magicAnimationEntity.transform.currentPosition = transform.node.position
            
            isOpen = true
            scene?.addEntity(magicAnimationEntity)
            
            let itemEntity = GlideEntity(initialNodePosition: transform.node.position)
            let collider = ColliderComponent(categoryMask: DemoCategoryMask.chestItem,
                                             size: CGSize(width: 32, height: 32),
                                             offset: .zero,
                                             leftHitPointsOffsets: (0, 0),
                                             rightHitPointsOffsets: (0, 0),
                                             topHitPointsOffsets: (0, 0),
                                             bottomHitPointsOffsets: (0, 0))
            itemEntity.addComponent(collider)
            let itemComponent = ChestItemComponent()
            itemEntity.addComponent(itemComponent)
            scene?.addEntity(itemEntity)
            
            removeIndicatorIfNeeded()
            
            let speech = Speech(text: "Collected grenades.",
                                talker: nil,
                                displaysOnTalkerPosition: false,
                                speechBubbleTemplate: SpeechBubbleEntity.self)
            scene?.startFlowForConversation(Conversation(speeches: [speech], blocksInputs: true))
        }
    }
    
    deinit {
        Input.shared.removeInputProfilesNamed("PickUpItem")
    }
}

extension ItemChestComponent: StateResettingComponent {
    func resetStates() {
        wasOpen = isOpen
    }
}
