//
//  GemCounterEntity.swift
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

class GemCounterEntity: GlideEntity {
    
    var numberOfGems: Int = 0 {
        didSet {
            updateNumberOfGems(to: numberOfGems)
        }
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 42, height: 42))
        spriteNodeComponent.zPositionContainer = GlideZPositionContainer.camera
        spriteNodeComponent.offset = CGPoint(x: 31, y: -31)
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "gem_counter_icon")
        addComponent(spriteNodeComponent)
        
        let labelNodeComponent = LabelNodeComponent()
        labelNodeComponent.labelNode.zPosition = 2
        labelNodeComponent.labelNode.fontName = Font.gemCountTextFont(ofSize: gameplayTipTextFontSize).familyName
        labelNodeComponent.labelNode.fontSize = gemCountTextFontSize
        labelNodeComponent.labelNode.numberOfLines = 0
        labelNodeComponent.labelNode.horizontalAlignmentMode = .left
        labelNodeComponent.labelNode.verticalAlignmentMode = .center
        labelNodeComponent.offset = CGPoint(x: 65, y: -31)
        addComponent(labelNodeComponent)
        
        let gemCounterComponent = GemCounterComponent()
        addComponent(gemCounterComponent)
        
        updateNumberOfGems(to: 0)
    }
    
    func updateNumberOfGems(to gemCount: Int) {
        let labelNode = component(ofType: LabelNodeComponent.self)?.labelNode
        labelNode?.text = "\(gemCount)"
    }
}

class GemCounterComponent: GKComponent, GlideComponent, NodeLayoutableComponent {
    
    func layout(scene: GlideScene, previousSceneSize: CGSize) {
        transform?.currentPosition = CGPoint(x: -scene.size.width / 2, y: scene.size.height / 2)
    }
}
