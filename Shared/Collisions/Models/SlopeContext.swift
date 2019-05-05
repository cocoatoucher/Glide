//
//  SlopeContext.swift
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

import CoreGraphics

/// Represents information about the member tiles of a slope.
public struct SlopeContext: Equatable {
    
    /// Positions of the tiles which compose a slope.
    public let tilePositions: [TiledPoint]
    
    /// `true` if the slope is declining from left to right.
    public var isInverse: Bool
    
    /// Inclination of the slope.
    public var inclination: Int {
        return tilePositions.count
    }
    
    // MARK: - Initialize
    
    /// Create a slope context with given tile positions.
    ///
    /// - Parameters:
    ///     - tilePositions: Positions of the tiles that compose this slope.
    ///     - isInverse: `true` if the slope is declining from left to right.
    public init?(tilePositions: [TiledPoint], isInverse: Bool) {
        guard
            let leftmostTilePosition = tilePositions.first,
            let rightmostTilePosition = tilePositions.last
            else {
                return nil
        }
        self.leftmostTilePosition = leftmostTilePosition
        self.rightmostTilePosition = rightmostTilePosition
        self.tilePositions = tilePositions
        self.isInverse = isInverse
    }
    
    public static func == (lhs: SlopeContext, rhs: SlopeContext) -> Bool {
        return lhs.leftmostTilePosition == rhs.leftmostTilePosition &&
            lhs.rightmostTilePosition == rhs.rightmostTilePosition &&
            lhs.tilePositions == rhs.tilePositions &&
            lhs.isInverse == rhs.isInverse && lhs.inclination == rhs.inclination
    }
    
    // MARK: - Private
    
    let leftmostTilePosition: TiledPoint
    let rightmostTilePosition: TiledPoint
}
