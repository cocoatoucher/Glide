//
//  LightNodeComponent.swift
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

/// Protocol to adopt to for light mask types.
/// This is used for the `lightingBitMask` of `LightNodeComponent`'s node.
public protocol LightMask {
    var rawValue: UInt32 { get }
}

/// Component that renders a light node as a child of its entity's transform node.
public final class LightNodeComponent: GKSKNodeComponent, GlideComponent, ZPositionContainerIndicatorComponent {
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Same as this component's `node` value, referenced as a SKLightNode for
    /// convenience.
    public let lightNode: SKLightNode
    
    /// Position of the light node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a light node component.
    ///
    /// - Parameters:
    ///     - mask: `categoryBitMask` for this light to be used to assign as
    /// `lightingBitMask` value of other nodes.
    public init(mask: LightMask) {
        self.lightNode = SKLightNode()
        super.init(node: lightNode)
        lightNode.categoryBitMask = mask.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        if let transform = transform {
            transform.node.addChild(node)
        }
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        let rounded = (offset + additionalOffset).glideRound
        lightNode.position = rounded
    }
}
