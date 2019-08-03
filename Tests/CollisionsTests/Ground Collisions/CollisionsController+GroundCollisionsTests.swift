//
//  CollisionsController+GroundCollisionsTests.swift
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

class CollisionsControllerGroundCollisionsTests: XCTestCase {
    // MARK: - Tile intersections
    func testCollisionsControllerReturnsNonEmptyIntersectionsIfColliderTouchesNonEmptyTiles() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground]]

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: .zero, to: .zero)

        let tileIntersections = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation)

        XCTAssertTrue(tileIntersections.count == 1)
        XCTAssertTrue(tileIntersections.first?.tileRepresentation == mapRepresentation.tileRepresentationAt(column: 0, row: 0))
        XCTAssertTrue(tileIntersections.first?.coordinates == TiledPoint(x: 0, y: 0))
    }

    func testCollisionsControllerReturnsEmptyTileIntersectionsIfColliderTouchesEmptyTiles() {
        let tileRepresentations: [[ColliderTileRepresentation?]] = [[nil]]

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)

        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: .zero, to: .zero)

        let tileIntersections = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation)

        XCTAssertTrue(tileIntersections.count == 1)
        XCTAssertTrue(tileIntersections.first?.tileRepresentation == nil)
        XCTAssertTrue(tileIntersections.first?.coordinates == TiledPoint(x: 0, y: 0))
    }

    func testCollisionsControllerReturnsEmptyAndNonEmptyTileIntersectionsIfColliderTouchesThem() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [ground, ground]]

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)

        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: .zero, to: CGPoint(x: 16, y: 16))

        let tileIntersections = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation)

        XCTAssertTrue(tileIntersections.count == 4)
        XCTAssertTrue(tileIntersections.contains { $0.coordinates == TiledPoint(x: 0, y: 0) })
        XCTAssertTrue(tileIntersections.contains { $0.coordinates == TiledPoint(x: 1, y: 0) })
        XCTAssertTrue(tileIntersections.contains { $0.coordinates == TiledPoint(x: 1, y: 0) })
        XCTAssertTrue(tileIntersections.contains { $0.coordinates == TiledPoint(x: 1, y: 1) })
    }

    func testCollisionsControllerReturnsSortedTileIntersectionsWithTheirDistanceToColliderCurrentPosition() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground], [ground]]

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)

        // Closer to the the ground at (1,0) and farther from ground at (0,0)
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 22, y: 0), to: CGPoint(x: 22, y: 0))

        let tileIntersections = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation)

        XCTAssertTrue(tileIntersections.count == 2)
        XCTAssertTrue(tileIntersections.first?.coordinates == TiledPoint(x: 1, y: 0))
    }

    // MARK: - Ground, one way and jump wall tiles

    func testCollisionsControllerReturnsBasisGroundContactIfColliderTouchesBasicColliderTile() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [ground, nil]]

        let colliderTileCoordinates = TiledPoint(x: 1, y: 0)

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)

        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 26), to: CGPoint(x: 16, y: 24))

        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == colliderTileCoordinates }.first
        guard let basicGroundIntersection = tileIntersection else {
            XCTFail("Doesn't intersect basic ground")
            return
        }

        let contact = collisionsController.basicGroundAndOnewayTileContact(colliderMovement: colliderMovement,
                                                                           tileMapRepresentation: mapRepresentation,
                                                                           shouldCollideGround: true,
                                                                           tileIntersection: basicGroundIntersection)
        XCTAssertNotNil(contact)
    }

    func testCollisionsControllerReturnsNoContactForOnewayGroundIfColliderIgnoredOnewayGrounds() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let oneWay = ColliderTileRepresentation(tile: .oneWay, userData: nil)
        let tileRepresentations = [[ground, nil], [oneWay, nil]]

        let oneWayTileCoordinates = TiledPoint(x: 1, y: 0)

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)

        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 26), to: CGPoint(x: 16, y: 24))
        colliderMovement.collider.didPushDown = true

        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == oneWayTileCoordinates }.first
        guard let oneWayGroundIntersection = tileIntersection else {
            XCTFail("Doesn't intersect one way ground")
            return
        }

        let contact = collisionsController.basicGroundAndOnewayTileContact(colliderMovement: colliderMovement,
                                                                           tileMapRepresentation: mapRepresentation,
                                                                           shouldCollideGround: true,
                                                                           tileIntersection: oneWayGroundIntersection)
        XCTAssertNil(contact)
    }

    func testCollisionsControllerMarksColliderAsPushingLeftJumpWallIfColliderTouchesLeftJumpWallTile() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let jumpWall = ColliderTileRepresentation(tile: .jumpWallLeft, userData: nil)
        let tileRepresentations = [[ground, nil], [jumpWall, nil]]

        let jumpWallCoordinates = TiledPoint(x: 1, y: 0)

        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 26, y: 0), to: CGPoint(x: 26, y: 0))

        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == jumpWallCoordinates }.first
        guard let jumpWallIntersection = tileIntersection else {
            XCTFail("Doesn't intersect jump wall")
            return
        }

        _ = collisionsController.handleJumpWallTileContact(colliderMovement: colliderMovement, isJumpWallLeft: true, shouldCollideGround: true, tileIntersection: jumpWallIntersection)
        XCTAssertTrue(colliderMovement.collider.pushesLeftJumpWall)
    }
    
    func testCollisionsControllerMarksColliderAsPushingRightJumpWallIfColliderTouchesRightJumpWallTile() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let jumpWall = ColliderTileRepresentation(tile: .jumpWallRight, userData: nil)
        let tileRepresentations = [[ground, nil], [jumpWall, nil]]
        
        let jumpWallCoordinates = TiledPoint(x: 1, y: 0)
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 26, y: 0), to: CGPoint(x: 26, y: 0))
        
        let tileIntersection = collisionsController.tileIntersections(for: colliderMovement, tileMapRepresentation: mapRepresentation).filter { $0.coordinates == jumpWallCoordinates }.first
        guard let jumpWallIntersection = tileIntersection else {
            XCTFail("Doesn't intersect jump wall")
            return
        }
        
        _ = collisionsController.handleJumpWallTileContact(colliderMovement: colliderMovement, isJumpWallLeft: false, shouldCollideGround: true, tileIntersection: jumpWallIntersection)
        XCTAssertTrue(colliderMovement.collider.pushesRightJumpWall)
    }
}
