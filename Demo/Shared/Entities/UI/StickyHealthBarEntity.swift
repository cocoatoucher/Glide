//
//  StickyHealthBarEntity.swift
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
import SpriteKit
import GameplayKit

class StickyHealthBarEntity: GlideEntity {
    
    let numberOfHearts: Int
    
    init(numberOfHearts: Int) {
        self.numberOfHearts = numberOfHearts
        super.init(initialNodePosition: .zero, positionOffset: .zero)
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 18, height: 7))
        addComponent(spriteNodeComponent)
        
        let updatableHealthBarComponent = UpdatableHealthBarComponent(numberOfHearts: numberOfHearts) { [weak self] remainingHearts in
            guard let self = self else { return }
            let texture = SKTexture(nearestFilteredImageName: String(format: "healthbar_%d", remainingHearts))
            self.component(ofType: SpriteNodeComponent.self)?.spriteNode.texture = texture
        }
        addComponent(updatableHealthBarComponent)
    }
}
