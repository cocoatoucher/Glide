//
//  TileMapNodeComponent.swift
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

/// Component that renders a tile map node as a child of its entity's transform node.
public final class TileMapNodeComponent: GKSKNodeComponent, GlideComponent, ZPositionContainerIndicatorComponent {
    
    public static let componentPriority: Int = 980
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Position of the tile map node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a tile map node component with the provided tile map node.
    ///
    /// - Parameters:
    ///     - tileMapNode: Tile map node that will be added as a child of the entity's
    /// transform.
    public init(tileMapNode: SKTileMapNode) {
        super.init(node: tileMapNode)
    }
    
    /// Create a single row tile map node component with provided number of columns
    /// and tile set.
    ///
    /// - Parameters:
    ///     - numberOfColumns: Number of columns of the tile map node.
    ///     - tileSet: Tile set to be used to populate the tile map node.
    public convenience init(numberOfColumns: Int, tileSet: SKTileSet, tileSize: CGSize) {
        let tileMapNode = TileMapNodeComponent.horizontalPlatformTileMapNode(numberOfColumns: numberOfColumns,
                                                                             tileSet: tileSet,
                                                                             tileSize: tileSize)
        self.init(tileMapNode: tileMapNode)
    }
    
    /// Create a single column tile map node component with provided number of rows
    /// and tile set.
    ///
    /// - Parameters:
    ///     - numberOfRows: Number of rows of the tile map node.
    ///     - tileSet: Tile set to be used to populate the tile map node.
    public convenience init(numberOfRows: Int, tileSet: SKTileSet, tileSize: CGSize) {
        let tileMapNode = TileMapNodeComponent.verticalPlatformTileMapNode(numberOfRows: numberOfRows,
                                                                           tileSet: tileSet,
                                                                           tileSize: tileSize)
        self.init(tileMapNode: tileMapNode)
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
        node.position = rounded
    }
    
    // MARK: - Private
    
    private static func horizontalPlatformTileMapNode(numberOfColumns: Int,
                                                      tileSet: SKTileSet,
                                                      tileSize: CGSize) -> SKTileMapNode {
        let platformNode = SKTileMapNode(tileSet: tileSet,
                                         columns: numberOfColumns,
                                         rows: 1,
                                         tileSize: tileSize)
        
        platformNode.enableAutomapping = false
        let leftGroup = tileSet.tileGroups[0]
        let middleGroup = tileSet.tileGroups[1]
        let rightGroup = tileSet.tileGroups[2]
        
        for column in 0 ..< numberOfColumns {
            if column == 0 {
                platformNode.setTileGroup(leftGroup, forColumn: column, row: 0)
            } else if column == numberOfColumns - 1 {
                platformNode.setTileGroup(rightGroup, forColumn: column, row: 0)
            } else {
                platformNode.setTileGroup(middleGroup, forColumn: column, row: 0)
            }
        }
        
        return platformNode
    }
    
    private static func verticalPlatformTileMapNode(numberOfRows: Int,
                                                    tileSet: SKTileSet,
                                                    tileSize: CGSize) -> SKTileMapNode {
        let platformNode = SKTileMapNode(tileSet: tileSet,
                                         columns: 1,
                                         rows: numberOfRows,
                                         tileSize: tileSize)
        
        platformNode.enableAutomapping = false
        let topGroup = tileSet.tileGroups[0]
        let middleGroup = tileSet.tileGroups[1]
        let bottomGroup = tileSet.tileGroups[2]
        
        for row in 0 ..< numberOfRows {
            if row == 0 {
                platformNode.setTileGroup(bottomGroup, forColumn: 0, row: row)
            } else if row == numberOfRows - 1 {
                platformNode.setTileGroup(topGroup, forColumn: 0, row: row)
            } else {
                platformNode.setTileGroup(middleGroup, forColumn: 0, row: row)
            }
        }
        
        return platformNode
    }
}
