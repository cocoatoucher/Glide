//
//  CollisionsController+EmptyTilesCollisionsTests.swift
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

class CollisionsControllerEmptyTilesCollisionsTests: XCTestCase {
    
    // MARK: - Gaps
    func testCollisionsControllerReturnsGapContactIfColliderContactsGap() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground], [nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let proposedPosition = CGPoint(x: 16, y: 24)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: CGSize(width: 20, height: 20))
        
        let contactsGap = collisionsController.doesContactGap(on: TiledPoint(x: 1, y: 0), proposedObjectFrame: proposedObjectFrame)
        XCTAssertTrue(contactsGap)
    }
    
    func testCollisionsControllerReturnsNoGapContactIfCollidersBottomIsUnderGapStartTileBottom() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground], [nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let proposedPosition = CGPoint(x: 16, y: 0)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: CGSize(width: 20, height: 20))
        
        let contactsGap = collisionsController.doesContactGap(on: TiledPoint(x: 1, y: 0), proposedObjectFrame: proposedObjectFrame)
        XCTAssertTrue(contactsGap == false)
    }
    
    func testCollisionsControllerMarksColliderAsTouchingGapWhenColliderTouchesGapTile() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground], [nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 30), to: CGPoint(x: 16, y: 24))
        
        let emptyTileIntersections = collisionsController.tileIntersections(for: colliderMovement).filter { $0.tileRepresentation == nil }
        
        var nonCollisionContacts: [ContactContext] = []
        collisionsController.emptyTilesContact(for: colliderMovement, emptyTileIntersections: emptyTileIntersections, nonCollisionContacts: &nonCollisionContacts)
        XCTAssertTrue(colliderMovement.collider.onGap)
        XCTAssertFalse(nonCollisionContacts.isEmpty)
    }
    
    // MARK: - Corner jumps
    func testCollisionsControllerMarksColliderOnCornerJumpWhenColliderTouchesCornerJump() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [nil, nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 24), to: CGPoint(x: 16, y: 24))
        colliderMovement.collider.wasOnGround = true
        
        let emptyTileIntersections = collisionsController.tileIntersections(for: colliderMovement).filter { $0.tileRepresentation == nil }
        
        var nonCollisionContacts: [ContactContext] = []
        collisionsController.emptyTilesContact(for: colliderMovement, emptyTileIntersections: emptyTileIntersections, nonCollisionContacts: &nonCollisionContacts)
        XCTAssertTrue(colliderMovement.collider.onCornerJump)
    }
    
    func testCollisionsControllerMarksColliderOnCornerJumpWhileColliderWasContactingCornerJump() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [nil, nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 24), to: CGPoint(x: 16, y: 24))
        colliderMovement.collider.wasOnCornerJump = true
        
        let emptyTileIntersections = collisionsController.tileIntersections(for: colliderMovement).filter { $0.tileRepresentation == nil }
        
        var nonCollisionContacts: [ContactContext] = []
        collisionsController.emptyTilesContact(for: colliderMovement, emptyTileIntersections: emptyTileIntersections, nonCollisionContacts: &nonCollisionContacts)
        XCTAssertTrue(colliderMovement.collider.onCornerJump)
    }
    
    func testCollisionsControllerMarksColliderAsDiscardingCornerJumpWhenColliderMovesOutOfCornerJump() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [nil, nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 24), to: CGPoint(x: 16, y: 0))
        
        let emptyTileIntersections = collisionsController.tileIntersections(for: colliderMovement).filter { $0.tileRepresentation == nil }
        
        var nonCollisionContacts: [ContactContext] = []
        collisionsController.emptyTilesContact(for: colliderMovement, emptyTileIntersections: emptyTileIntersections, nonCollisionContacts: &nonCollisionContacts)
        XCTAssertTrue(colliderMovement.collider.discardsCornerJump)
        XCTAssertTrue(nonCollisionContacts.isEmpty)
    }
    
    func testCollisionsControllerMakesColliderIgnoreCornerJumpIfColliderDiscardsCornerJump() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [nil, nil]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 16, y: 24), to: CGPoint(x: 16, y: 24))
        colliderMovement.collider.discardsCornerJump = true
        
        let emptyTileIntersections = collisionsController.tileIntersections(for: colliderMovement).filter { $0.tileRepresentation == nil }
        
        var nonCollisionContacts: [ContactContext] = []
        collisionsController.emptyTilesContact(for: colliderMovement, emptyTileIntersections: emptyTileIntersections, nonCollisionContacts: &nonCollisionContacts)
        XCTAssertTrue(colliderMovement.collider.onCornerJump == false)
    }
}
