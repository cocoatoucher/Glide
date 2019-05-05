//
//  CollisionTileMapRepresentation.swift
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

/// Represents a tile map populated with collider tiles.
struct CollisionTileMapRepresentation {
    
    let mapSize: CGSize
    let tileSize: CGSize
    private let tileRepresentations: [[ColliderTileRepresentation?]]
    private(set) var cornerJumps: [TiledPoint] = []
    private(set) var columnsToGaps: [Int: [(Int, Int)]] = [:]
    private(set) var slopeContexts: [SlopeContext] = []
    
    var numberOfColumns: Int {
        return tileRepresentations.count
    }
    
    var numberOfRows: Int {
        return tileRepresentations.first?.count ?? 0
    }
    
    init(tileMap: SKTileMapNode) {
        self.init(tileRepresentations: tileMap.tileRepresentations, tileSize: tileMap.tileSize)
    }
    
    init(tileRepresentations: [[ColliderTileRepresentation?]], tileSize: CGSize) {
        let columnCount = tileRepresentations.count
        let rowCount = tileRepresentations.first?.count ?? 0
        assert(tileRepresentations.reduce(true) { (result, row) -> Bool in
            return result && (row.count == rowCount)
        })
        
        self.mapSize = TiledSize(columnCount, rowCount).size(with: tileSize)
        self.tileSize = tileSize
        self.tileRepresentations = tileRepresentations
        self.slopeContexts = slopeContextsFromTileRepresentations()
        self.cornerJumps = cornerJumpsAndGaps.cornerJumps
        self.columnsToGaps = cornerJumpsAndGaps.columnsToGaps
    }
    
    func slopeContext(at location: TiledPoint) -> SlopeContext? {
        return slopeContexts.first { $0.tilePositions.first { $0 == location } != nil }
    }
    
    /// Returns tiled range of tiles around a given frame.
    func tileRangeAroundFrame(_ frame: CGRect) -> TiledRange {
        var leftwardsTileColumnIndex = tileColumnIndex(at: frame.origin.x) - 1
        leftwardsTileColumnIndex = leftwardsTileColumnIndex.clamped(0 ..< numberOfColumns)
        
        var rightwardsTileColumnIndex = tileColumnIndex(at: frame.maxX) + 1
        rightwardsTileColumnIndex = rightwardsTileColumnIndex.clamped(0 ..< numberOfColumns)
        
        var upwardsTileRowIndex = tileRowIndex(at: frame.maxY) + 1
        upwardsTileRowIndex = upwardsTileRowIndex.clamped(0 ..< numberOfRows)
        
        var downwardsTileRowIndex = tileRowIndex(at: frame.origin.y) - 1
        downwardsTileRowIndex = downwardsTileRowIndex.clamped(0 ..< numberOfRows)
        
        return TiledRange(left: leftwardsTileColumnIndex,
                          right: rightwardsTileColumnIndex,
                          top: upwardsTileRowIndex,
                          bottom: downwardsTileRowIndex)
    }
    
    func tileRepresentationAt(column: Int, row: Int) -> ColliderTileRepresentation? {
        return tileRepresentations[column][row]
    }
    
    // MARK: - Private
    
    private func tileColumnIndex(at xPosition: CGFloat) -> Int {
        return Int(xPosition / tileSize.width)
    }
    
    private func tileRowIndex(at yPosition: CGFloat) -> Int {
        return Int(yPosition / tileSize.height)
    }
    
    private func slopeContextsFromTileRepresentations() -> [SlopeContext] {
        
        class TemporarySlopeContext {
            var tilePositions: [TiledPoint] = []
            let isInverse: Bool
            
            init(isInverse: Bool) {
                self.isInverse = isInverse
            }
        }
        
        var result = [SlopeContext]()
        var lastSlopeContext: TemporarySlopeContext?
        for column in 0 ..< numberOfColumns {
            for row in 0 ..< numberOfRows {
                guard let tileRepresentation = tileRepresentations[column][row] else {
                    continue
                }
                
                if tileRepresentation.tile.isSlope == true {
                    let leftValue = tileRepresentation.tile.slopeLeftValue
                    let rightValue = tileRepresentation.tile.slopeRightValue
                    
                    let direction = (leftValue < rightValue) ? -1 : 1
                    let isInverseSlope = direction == -1
                    
                    if direction == 1 && leftValue == 15 || direction == -1 && leftValue == 0 {
                        if
                            let lastContext = lastSlopeContext,
                            let slopeContext = SlopeContext(tilePositions: lastContext.tilePositions, isInverse: lastContext.isInverse)
                        {
                            result.append(slopeContext)
                        }
                        
                        lastSlopeContext = TemporarySlopeContext(isInverse: isInverseSlope)
                        lastSlopeContext?.tilePositions.append(TiledPoint(column, row))
                    } else {
                        if let lastContext = lastSlopeContext {
                            lastContext.tilePositions.append(TiledPoint(column, row))
                        } else {
                            lastSlopeContext = TemporarySlopeContext(isInverse: isInverseSlope)
                            lastSlopeContext?.tilePositions.append(TiledPoint(column, row))
                        }
                    }
                }
            }
        }
        
        if
            let lastContext = lastSlopeContext,
            let slopeContext = SlopeContext(tilePositions: lastContext.tilePositions, isInverse: lastContext.isInverse)
        {
            result.append(slopeContext)
            lastSlopeContext = nil
        }
        
        return result
    }
    
    private lazy var cornerJumpsAndGaps: (cornerJumps: [TiledPoint], columnsToGaps: [Int: [(Int, Int)]]) = {
        var columnsToGaps: [Int: [(Int, Int)]] = [:]
        var cornerJumps: [TiledPoint] = []
        for column in 0 ..< tileRepresentations.count {
            var currentGaps: [(Int, Int)] = []
            var lastGapStartRow: Int?
            let tileRepresentationsForCurrentColumn = tileRepresentations[column]
            
            for row in 0 ..< tileRepresentationsForCurrentColumn.count {
                let tileRepresentation = tileRepresentationsForCurrentColumn[row]
                if let tileRep = tileRepresentation, tileRep.tile.isGroundOrOneWay {
                    if column - 1 >= 0 && row + 1 < tileRepresentationsForCurrentColumn.count {
                        let leftTileRepresentation = tileRepresentations[column - 1][row]
                        let upTileRepresentation = tileRepresentations[column][row + 1]
                        if leftTileRepresentation == nil && upTileRepresentation == nil {
                            if cornerJumps.contains(TiledPoint(column - 1, row)) == false {
                                cornerJumps.append(TiledPoint(column - 1, row))
                            }
                        }
                    }
                    if column + 1 < tileRepresentations.count && row + 1 < tileRepresentationsForCurrentColumn.count {
                        let rightTileRepresentation = tileRepresentations[column + 1][row]
                        let upTileRepresentation = tileRepresentations[column][row + 1]
                        if rightTileRepresentation == nil && upTileRepresentation == nil {
                            if cornerJumps.contains(TiledPoint(column + 1, row)) == false {
                                cornerJumps.append(TiledPoint(column + 1, row))
                            }
                        }
                    }
                }
                
                if tileRepresentation == nil {
                    if lastGapStartRow == nil {
                        lastGapStartRow = row
                    }
                } else {
                    if let startRow = lastGapStartRow {
                        currentGaps.append((startRow, row - 1))
                        lastGapStartRow = nil
                    }
                }
            }
            
            if let startRow = lastGapStartRow {
                currentGaps.append((startRow, tileRepresentationsForCurrentColumn.count - 1))
            }
            
            columnsToGaps[column] = currentGaps
        }
        
        return (cornerJumps: cornerJumps, columnsToGaps: columnsToGaps)
    }()
}
