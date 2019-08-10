//
//  SpeechBubbleOptionButtonEntity.swift
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
import SpriteKit

class SpeechBubbleOptionButtonEntity: GlideEntity {
    lazy var spriteNodeComponent: SpriteNodeComponent = {
        let component = SpriteNodeComponent(nodeSize: size)
        return component
    }()
    let labelNodeComponent = LabelNodeComponent()
    lazy var focusableComponent: FocusableComponent = {
        let component = FocusableComponent(selectionInputProfile: inputProfile)
        return component
    }()
    #if os(iOS)
    lazy var touchButtonComponent: TouchButtonComponent = {
        let component = TouchButtonComponent(size: size, triggersOnTouchUpInside: true, input: .profiles([(name: inputProfile, isNegative: false)]))
        return component
    }()
    #endif
    
    let inputProfile: String
    var size: CGSize
    init(text: String, size: CGSize, inputProfile: String) {
        self.inputProfile = inputProfile
        self.size = size
        self.labelNodeComponent.labelNode.text = text
        super.init(initialNodePosition: CGPoint.zero, positionOffset: .zero)
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        addComponent(spriteNodeComponent)
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "frame")
        spriteNodeComponent.spriteNode.centerRect = CGRect(x: 3.0/7.0, y: 3.0/7.0, width: 1.0/7.0, height: 1.0/7.0)
        spriteNodeComponent.spriteNode.zPosition = 1
        
        addComponent(focusableComponent)
        
        labelNodeComponent.labelNode.verticalAlignmentMode = .center
        labelNodeComponent.labelNode.fontName = Font.speechBubbleTextFont(ofSize: speechBubbleTextFontSize).familyName
        labelNodeComponent.labelNode.fontSize = speechBubbleTextFontSize
        labelNodeComponent.labelNode.zPosition = 2
        addComponent(labelNodeComponent)
        
        #if os(iOS)
        addComponent(touchButtonComponent)
        #endif
    }
    
    override func didMoveToScene(_ scene: GlideScene) {
        labelNodeComponent.labelNode.removeFromParent()
        spriteNodeComponent.spriteNode.addChild(labelNodeComponent.labelNode)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if focusableComponent.isFocused {
            #if os(iOS)
            if Input.shared.inputMethod.isTouchesEnabled {
                return
            }
            #endif
            
            labelNodeComponent.labelNode.fontColor = .blue
        } else {
            labelNodeComponent.labelNode.fontColor = .white
        }
    }
    
    override func layout(scene: GlideScene, previousSceneSize: CGSize) {
        #if os(iOS)
        touchButtonComponent.hitBoxNode.size = spriteNodeComponent.spriteNode.size
        #endif
    }
}
