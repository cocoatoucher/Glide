//
//  TileMaps.swift
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

import SpriteKit

/// Collision and decoration tile maps to be provided for a `GlideScene`.
/// This is typically populated with loaded information from a level file
/// either a .sks file from `SpriteKit`, or .json map file from `Tiled Map Editor`.
public struct SceneTileMaps {
    
    /// Tile map that contains collidable tiles.
    public let collisionTileMap: SKTileMapNode
    /// Tile maps that is drawn for decoration purposes.
    public let decorationTileMaps: [SKTileMapNode]
    
    // MARK: - Initialize
    
    /// Create a scene tile maps.
    ///
    /// - Parameters:
    ///     - collisionTileMap: Tile map that contains collidable tiles.
    ///     - decorationTileMaps: Tile maps that is drawn for decoration purposes.
    public init(collisionTileMap: SKTileMapNode, decorationTileMaps: [SKTileMapNode]) {
        self.collisionTileMap = collisionTileMap
        self.decorationTileMaps = decorationTileMaps
    }
}
