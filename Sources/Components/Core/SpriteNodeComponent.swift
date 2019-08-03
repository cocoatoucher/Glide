//
//  SpriteNodeComponent.swift
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

/// Component that renders a sprite node as a child of its entity's transform node.
public final class SpriteNodeComponent: GKSKNodeComponent, GlideComponent, ZPositionContainerIndicatorComponent {
    
    public static let componentPriority: Int = 990
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Same as this component's `node` value, referenced as a SKSpriteNode for convenience.
    public let spriteNode: SKSpriteNode
    
    /// Position of the sprite node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a sprite node component with a sprite node of given size.
    ///
    /// - Parameters:
    ///     - nodeSize: Size of the sprite node.
    public init(nodeSize: CGSize) {
        self.spriteNode = SKSpriteNode(color: .clear, size: nodeSize)
        super.init(node: spriteNode)
    }
    
    /// Create a sprite node component with a sprite node of given size.
    ///
    /// - Parameters:
    ///     - tiledNodeSize: Size of the sprite node in tile units. Note that the node
    /// will get this size after scene's update loop starts.
    public convenience init(tiledNodeSize: TiledSize) {
        self.init(nodeSize: .zero)
        self.initialTiledNodeSize = tiledNodeSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        guard let transform = transform else {
            return
        }
        guard let scene = scene else {
            return
        }
        
        if let initialTiledNodeSize = initialTiledNodeSize {
            spriteNode.size = initialTiledNodeSize.size(with: scene.tileSize)
        }
        
        transform.node.addChild(spriteNode)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        let rounded = (offset + additionalOffset).glideRound
        spriteNode.position = rounded
    }
    
    // MARK: - Private
    
    private var initialTiledNodeSize: TiledSize?
}
