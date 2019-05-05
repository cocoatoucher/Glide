//
//  CollisionTileMapRepresentationTests.swift
//  glide
//
//  Copyright (c) 2019 cocoatoucher on Github.com (https://github.com/cocoatoucher/)
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

@testable import Glide
import SpriteKit
import XCTest

class CollisionTileMapRepresentationTests: XCTestCase {
    func testCollisionTileMapRepresentationCornerJumps() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil],
                                   [ground, nil],
                                   [nil, nil],
                                   [nil, nil],
                                   [nil, nil],
                                   [ground, nil],
                                   [ground, nil]]

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)

        XCTAssertTrue(mapRepresentation.cornerJumps.isEmpty == false)
        XCTAssertEqual(mapRepresentation.cornerJumps.count, 2)
        XCTAssertTrue(mapRepresentation.cornerJumps.contains(TiledPoint(x: 2, y: 0)))
        XCTAssertTrue(mapRepresentation.cornerJumps.contains(TiledPoint(x: 4, y: 0)))
    }
    
    func testCollisionTileMapRepresentationGaps() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[nil, nil, ground, nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        
        XCTAssertEqual(mapRepresentation.columnsToGaps.values.first?[0].0, 0)
        XCTAssertEqual(mapRepresentation.columnsToGaps.values.first?[0].1, 1)
        XCTAssertEqual(mapRepresentation.columnsToGaps.values.first?[1].0, 3)
        XCTAssertEqual(mapRepresentation.columnsToGaps.values.first?[1].1, 3)
    }

    func testSlopeContexts() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let slope0 = ColliderTileRepresentation(tile: .slope(fullValue: "slope_15_12"),
                                        userData: nil)
        let slope1 = ColliderTileRepresentation(tile: .slope(fullValue: "slope_11_8"),
                                        userData: nil)
        let slope2 = ColliderTileRepresentation(tile: .slope(fullValue: "slope_7_4"),
                                        userData: nil)
        let slope3 = ColliderTileRepresentation(tile: .slope(fullValue: "slope_3_0"),
                                        userData: nil)
        let tileRepresentations = [[ground, nil],
                                   [ground, nil],
                                   [ground, slope0],
                                   [ground, slope1],
                                   [ground, slope2],
                                   [ground, slope3],
                                   [ground, ground]]

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)

        XCTAssertEqual(mapRepresentation.slopeContexts.first?.leftmostTilePosition, TiledPoint(x: 2, y: 1))
        XCTAssertEqual(mapRepresentation.slopeContexts.first?.rightmostTilePosition, TiledPoint(x: 5, y: 1))
    }
    
    func testCollisionTileMapRepresentationReturnsCorrectTiledRangeWhenFrameIsInTheMiddleOfTiles() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, ground],
                                   [ground, ground]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        
        let tileRange = mapRepresentation.tileRangeAroundFrame(CGRect(x: 8, y: 8, width: 16, height: 16))
        XCTAssertEqual(tileRange.left, 0)
        XCTAssertEqual(tileRange.right, 1)
        XCTAssertEqual(tileRange.bottom, 0)
        XCTAssertEqual(tileRange.top, 1)
    }
    
    func testCollisionTileMapRepresentationReturnsCorrectTiledRangeWhenFrameIsOutsideOfTiles() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, ground],
                                   [ground, ground]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        
        let tileRange = mapRepresentation.tileRangeAroundFrame(CGRect(x: 32, y: 32, width: 16, height: 16))
        XCTAssertEqual(tileRange.left, 1)
        XCTAssertEqual(tileRange.right, 1)
        XCTAssertEqual(tileRange.bottom, 1)
        XCTAssertEqual(tileRange.top, 1)
    }
}
