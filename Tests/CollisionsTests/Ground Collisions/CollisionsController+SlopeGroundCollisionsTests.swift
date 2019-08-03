//
//  CollisionsController+SlopeGroundCollisionsTests.swift
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

@testable import GlideEngine
import SpriteKit
import XCTest

class CollisionsControllerSlopeGroundCollisionsTests: XCTestCase {
    
    // MARK: - Slopes
    func testCollisionsControllerReturnsValidContactIfColliderTouchesSlopeTile() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let slope = ColliderTileRepresentation(tile: .slope(fullValue: "slope_15_8"), userData: nil)
        let tileRepresentations = [[ground, nil], [ground, slope]]
        
        let slopeTileCoordinates = TiledPoint(x: 1, y: 1)
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        guard let slopeContext = mapRepresentation.slopeContext(at: slopeTileCoordinates) else {
            XCTFail("Can't find a slope context")
            return
        }
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 26), to: CGPoint(x: 16, y: 26))
        
        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == slopeTileCoordinates }.first
        guard let slopeIntersection = tileIntersection else {
            XCTFail("Doesn't intersect slope")
            return
        }
        
        let contact = collisionsController.slopeTileContact(colliderMovement: colliderMovement,
                                                            shouldCollideGround: true,
                                                            tileIntersection: slopeIntersection,
                                                            slopeContext: slopeContext,
                                                            verticalVelocity: 0)
        guard let slopeContact = contact else {
            XCTFail("Slope contact shouldn't be empty")
            return
        }
        XCTAssertNotNil(slopeContact)
        XCTAssertTrue(colliderMovement.collider.onSlope)
        XCTAssertTrue(colliderMovement.collider.slopeContext == slopeContext)
        XCTAssertTrue(slopeContact.proposedPosition.y > colliderMovement.proposedPosition.y)
    }
    
    func testCollisionsControllerReturnsNoContactIfColliderTouchesSlopeTileFromReverseInclineOfSlope() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let slope = ColliderTileRepresentation(tile: .slope(fullValue: "slope_15_8"), userData: nil)
        let tileRepresentations = [[ground, nil], [ground, slope]]
        
        let slopeTileCoordinates = TiledPoint(x: 1, y: 1)
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        guard let slopeContext = mapRepresentation.slopeContext(at: slopeTileCoordinates) else {
            XCTFail("Can't find a slope context")
            return
        }
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 26), to: CGPoint(x: 32, y: 26))
        
        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == slopeTileCoordinates }.first
        guard let slopeIntersection = tileIntersection else {
            XCTFail("Doesn't intersect slope")
            return
        }
        
        let slopeContact = collisionsController.slopeTileContact(colliderMovement: colliderMovement,
                                                                 shouldCollideGround: true,
                                                                 tileIntersection: slopeIntersection,
                                                                 slopeContext: slopeContext,
                                                                 verticalVelocity: 0)
        XCTAssertNil(slopeContact)
    }
    
    func testCollisionsControllerReturnsNoContactIfColliderIsMovingUpAndDoesntTouchTheSlopeBitmap() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let slope = ColliderTileRepresentation(tile: .slope(fullValue: "slope_15_8"), userData: nil)
        let tileRepresentations = [[ground, nil], [ground, slope]]
        
        let slopeTileCoordinates = TiledPoint(x: 1, y: 1)
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        guard let slopeContext = mapRepresentation.slopeContext(at: slopeTileCoordinates) else {
            XCTFail("Can't find a slope context")
            return
        }
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 42), to: CGPoint(x: 16, y: 32))
        
        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == slopeTileCoordinates }.first
        guard let slopeIntersection = tileIntersection else {
            XCTFail("Doesn't intersect slope")
            return
        }
        
        let contact = collisionsController.slopeTileContact(colliderMovement: colliderMovement,
                                                            shouldCollideGround: true,
                                                            tileIntersection: slopeIntersection,
                                                            slopeContext: slopeContext,
                                                            verticalVelocity: 5)
        XCTAssertNil(contact)
    }
    
}
