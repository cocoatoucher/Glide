//
//  SKTileMapNode+TileRepresentations.swift
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

extension SKTileMapNode {
    
    /// Values that represent this tile map node in the model level.
    /// Outer array contains columns of tiles, and inner array contains rows of tiles for that column.
    var tileRepresentations: [[ColliderTileRepresentation?]] {
        var result = [[ColliderTileRepresentation?]]()
        for column in 0 ..< numberOfColumns {
            var tileRepresentationsForColumn = [ColliderTileRepresentation?]()
            for row in 0 ..< numberOfRows {
                let tileDefinition = self.tileDefinition(atColumn: column, row: row)
                if let tileName = tileDefinition?.name, let tile = ColliderTile(tileName) {
                    let representation = ColliderTileRepresentation(tile: tile, userData: tileDefinition?.userData)
                    tileRepresentationsForColumn.append(representation)
                } else {
                    tileRepresentationsForColumn.append(nil)
                }
            }
            result.append(tileRepresentationsForColumn)
        }
        return result
    }
}
