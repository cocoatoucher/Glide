//
//  GameplayTipEntity.swift
//  Glide
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

class GameplayTipEntity: GlideEntity {
    
    let text: String
    let frameWidth: CGFloat
    
    init(initialNodePosition: CGPoint, text: String, frameWidth: CGFloat) {
        self.text = text
        self.frameWidth = frameWidth + 20.0
        super.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "gameplay_tip_frame")
        spriteNodeComponent.spriteNode.centerRect = CGRect(x: 8.0/18.0, y: 8.0/18.0, width: 2.0/18.0, height: 2.0/18.0)
        
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNodeComponent)
        
        let labelNodeComponent = LabelNodeComponent()
        labelNodeComponent.labelNode.zPosition = 10
        labelNodeComponent.labelNode.fontName = Font.gameplayTipTextFont(ofSize: gameplayTipTextFontSize).familyName
        labelNodeComponent.labelNode.fontSize = gameplayTipTextFontSize
        labelNodeComponent.labelNode.text = text
        labelNodeComponent.labelNode.numberOfLines = 0
        labelNodeComponent.labelNode.preferredMaxLayoutWidth = frameWidth - 20
        labelNodeComponent.labelNode.horizontalAlignmentMode = .center
        labelNodeComponent.labelNode.verticalAlignmentMode = .center
        addComponent(labelNodeComponent)
        
        let layoutComponent = SceneAnchoredSpriteLayoutComponent()
        layoutComponent.widthConstraint = NodeLayoutConstraint.constant(frameWidth)
        layoutComponent.heightConstraint = NodeLayoutConstraint.constant(labelNodeComponent.labelNode.frame.height + 20.0)
        addComponent(layoutComponent)
    }
    
}
