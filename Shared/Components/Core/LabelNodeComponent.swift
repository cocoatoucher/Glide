//
//  LabelNodeComponent.swift
//  glide
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
import SpriteKit

/// Component that renders a label node as a child of its entity's transform node.
public final class LabelNodeComponent: GKSKNodeComponent, GlideComponent, ZPositionContainerIndicatorComponent {
    
    public static let componentPriority: Int = 970
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Same as this component's `node` value, referenced as a SKLabelNode for
    /// convenience.
    public let labelNode = SKLabelNode()
    
    /// Position of the label node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    public override init() {
        super.init(node: labelNode)
        labelNode.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        transform?.node.addChild(labelNode)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        let rounded = (offset + additionalOffset).glideRound
        labelNode.position = rounded
    }
}
