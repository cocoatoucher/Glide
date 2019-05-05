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

import GlideEngine
import SpriteKit
import GameplayKit

class TouchButtonComponent: GKSKNodeComponent, GlideComponent, TouchReceiverComponent, ZPositionContainerIndicatorComponent {
    
    var zPositionContainer: ZPositionContainer?
    
    // MARK: - Touch Receiver
    
    var input: TouchInputProfilesOrCallback
    let triggersOnTouchUpInside: Bool
    
    var currentTouchCount: Int = 0
    
    let hitBoxNode: SKSpriteNode
    var normalTexture: SKTexture?
    var highlightedTexture: SKTexture?
    
    var isHighlighted: Bool = false
    
    init(size: CGSize,
         triggersOnTouchUpInside: Bool,
         input: TouchInputProfilesOrCallback) {
        self.hitBoxNode = SKSpriteNode(color: .clear, size: size)
        self.triggersOnTouchUpInside = triggersOnTouchUpInside
        self.input = input
        super.init(node: hitBoxNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        transform?.node.addChild(hitBoxNode)
    }
    
    open override func update(deltaTime seconds: TimeInterval) {
        updateNodeTexture()
    }
    
    func updateNodeTexture() {
        if isHighlighted {
            hitBoxNode.texture = highlightedTexture
        } else {
            hitBoxNode.texture = normalTexture
        }
    }
    
    public func entityWillBeRemovedFromScene() {
        hitBoxNode.removeFromParent()
        currentTouchCount = 0
    }
}
