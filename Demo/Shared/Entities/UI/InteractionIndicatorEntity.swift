//
//  InteractionIndicatorEntity.swift
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

class InteractionIndicatorEntity: GlideEntity {
    
    lazy var spriteNodeComponent: SpriteNodeComponent = {
        let component = SpriteNodeComponent(nodeSize: size)
        return component
    }()
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

    let size: CGSize
    let yOffset: CGFloat
    let inputProfile: String
    
    var inputMethodDidChangeObservation: Any?
    
    init(size: CGSize, yOffset: CGFloat, inputProfile: String) {
        self.size = size
        self.yOffset = yOffset
        self.inputProfile = inputProfile
        super.init(initialNodePosition: CGPoint.zero, positionOffset: CGPoint(x: 0, y: yOffset))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        addComponent(spriteNodeComponent)
        addComponent(focusableComponent)
        
        let layoutComponent = SceneAnchoredSpriteLayoutComponent()
        layoutComponent.widthConstraint = .constant(size.width)
        layoutComponent.heightConstraint = .constant(size.height)
        addComponent(layoutComponent)
        
        #if os(iOS)
        addComponent(touchButtonComponent)
        #endif
        
        inputMethodDidChangeObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { [weak self] _ in
            self?.updateTexture()
        }
        
        updateTexture()
    }
    
    func updateTexture() {
        switch Input.shared.inputMethod {
        case .native:
            #if os(iOS)
            spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "touch_submit")
            #else
            spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "key_submit")
            #endif
        case .gameController:
            spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "gamepad_submit")
        }
    }
    
    deinit {
        if let observation = inputMethodDidChangeObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}
