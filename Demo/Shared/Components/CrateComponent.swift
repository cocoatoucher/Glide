//
//  CrateComponent.swift
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

class CrateComponent: GKComponent, GlideComponent {
    
    var didPlayExplosionAnimation: Bool = false
    let explosionAnimationEntity = DemoEntityFactory.explosionAnimationEntity(at: .zero)
    
    func handleNewContact(_ contact: Contact) {
        guard let otherCategoryMask = contact.otherObject.colliderComponent?.categoryMask else {
            return
        }
        
        if otherCategoryMask == DemoCategoryMask.weapon || otherCategoryMask == DemoCategoryMask.projectile {
            
            if otherCategoryMask == DemoCategoryMask.projectile {
                contact.otherObject.colliderComponent?.entity?.component(ofType: HealthComponent.self)?.kill()
            }
            
            entity?.component(ofType: HealthComponent.self)?.kill()
        }
    }
    
    func didSkipUpdate() {
        let isDead = entity?.component(ofType: HealthComponent.self)?.isDead
        guard isDead == true && didPlayExplosionAnimation == false else {
            return
        }
        
        didPlayExplosionAnimation = true
        if let transform = transform {
            explosionAnimationEntity.transform.currentPosition = transform.node.position
            scene?.addEntity(explosionAnimationEntity)
        }
    }
}

extension CrateComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return didPlayExplosionAnimation
    }
}
