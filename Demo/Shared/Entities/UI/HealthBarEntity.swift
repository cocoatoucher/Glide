//
//  HealthBarEntity.swift
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

class HealthBarEntity: GlideEntity {
    
    let numberOfHearts: Int
    
    init(numberOfHearts: Int) {
        self.numberOfHearts = numberOfHearts
        super.init(initialNodePosition: .zero, positionOffset: .zero)
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 120, height: 32))
        spriteNodeComponent.zPositionContainer = GlideZPositionContainer.camera
        spriteNodeComponent.offset = CGPoint(x: 80, y: -36)
        addComponent(spriteNodeComponent)
        
        let healthBarComponent = HealthBarComponent()
        addComponent(healthBarComponent)
        
        let updatableHealthBarComponent = UpdatableHealthBarComponent(numberOfHearts: numberOfHearts) { [weak self] remainingHearts in
            guard let self = self else { return }
            let texture = SKTexture(nearestFilteredImageName: String(format: "hearts_%d", remainingHearts))
            self.component(ofType: SpriteNodeComponent.self)?.spriteNode.texture = texture
        }
        addComponent(updatableHealthBarComponent)
    }
}

class HealthBarComponent: GKComponent, GlideComponent, NodeLayoutableComponent {
    
    func layout(scene: GlideScene, previousSceneSize: CGSize) {
        transform?.currentPosition = CGPoint(x: -scene.size.width / 2, y: scene.size.height / 2)
    }
}
