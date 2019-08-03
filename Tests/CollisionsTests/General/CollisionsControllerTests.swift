//
//  CollisionsControllerTests.swift
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

class CollisionsControllerTests: XCTestCase {
    
    var collisionsController: CollisionsController?
    override func setUp() {
        super.setUp()
        let tileRepresentations: [[ColliderTileRepresentation?]] = []
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
    }
    
    override func tearDown() {
        super.tearDown()
        collisionsController = nil
    }
    
    func testCollisionsControllerReturnsContactBetweenTwoObjectsIfTheyContactEachOther() {
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 17, y: 26), to: CGPoint(x: 22, y: 26))
        
        let otherCollider = ColliderComponent(categoryMask: TestCategoryMask.test,
                                              size: CGSize(width: 20, height: 20),
                                              offset: .zero,
                                              leftHitPointsOffsets: (5, 5),
                                              rightHitPointsOffsets: (5, 5),
                                              topHitPointsOffsets: (5, 5),
                                              bottomHitPointsOffsets: (5, 5))
        
        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = colliderMovement.proposedObjectFrame.intersection(proposedOtherObjectFrame)
        
        let contact = collisionsController?.contactBetweenObjects(colliderMovement: colliderMovement,
                                                                  intersection: intersection,
                                                                  otherObject: .collider(otherCollider),
                                                                  otherObjectFrame: otherObjectFrame,
                                                                  proposedOtherObjectFrame: proposedOtherObjectFrame,
                                                                  shouldCollide: true)
        XCTAssertNotNil(contact)
    }
    
    func testCollisionsControllerReturnsValidContactIfColliderTouchesGround() {
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground, nil], [ground, ground]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        let entity = GlideEntity(initialNodePosition: CGPoint(x: 0, y: 26))
        let collider = ColliderComponent(categoryMask: TestCategoryMask.test,
                                         size: CGSize(width: 20, height: 20),
                                         offset: .zero,
                                         leftHitPointsOffsets: (5, 5),
                                         rightHitPointsOffsets: (5, 5),
                                         topHitPointsOffsets: (5, 5),
                                         bottomHitPointsOffsets: (5, 5))
        entity.addComponent(collider)
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        entity.addComponent(colliderTileHolderComponent)
        
        var nonCollisionContacts: [ContactContext] = []
        let contact = collisionsController.contact(of: entity,
                                                   collider: collider,
                                                   at: CGPoint(x: 10, y: 26),
                                                   snappables: [],
                                                   contacts: [],
                                                   nonCollisionContacts: &nonCollisionContacts)
        XCTAssertNotNil(contact)
        XCTAssertTrue(contact?.isCollision == true)
        XCTAssertTrue(contact?.otherObject == ContactedObject.colliderTile(isEmptyTile: false))
    }
    
    func testCollisionsControllerReturnsCorrectInterpolatedPositions() {
        let startPosition = CGPoint.zero
        let endPosition = CGPoint(x: 16, y: 16)
        let positions = collisionsController?.interpolatedPositions(from: startPosition,
                                                                    to: endPosition,
                                                                    intermediaryPositions: nil,
                                                                    maximumDelta: 8.0)
        XCTAssertTrue(positions?.count == 2)
        XCTAssertTrue(positions == [CGPoint(x: 8, y: 8), CGPoint(x: 16, y: 16)])
    }
    
    func testCollisionsControllerReturnsCorrectInterpolatedPositionsWithIntermediaryPositions() {
        let startPosition = CGPoint.zero
        let intermediaryPosition = CGPoint(x: 9, y: 9)
        let endPosition = CGPoint(x: 16, y: 16)
        let positions = collisionsController?.interpolatedPositions(from: startPosition,
                                                                    to: endPosition,
                                                                    intermediaryPositions: [intermediaryPosition],
                                                                    maximumDelta: 8.0)
        XCTAssertTrue(positions?.count == 3)
        XCTAssertTrue(positions == [CGPoint(x: 4.5, y: 4.5), CGPoint(x: 9, y: 9), CGPoint(x: 16, y: 16)])
    }
    
    func testCollisionsControllerReturnsCorrectResolvedProposedPosition() {
        let entity = GlideEntity(initialNodePosition: CGPoint(x: 0, y: 30))
        let collider = ColliderComponent(categoryMask: TestCategoryMask.test,
                                         size: CGSize(width: 20, height: 20),
                                         offset: .zero,
                                         leftHitPointsOffsets: (5, 5),
                                         rightHitPointsOffsets: (5, 5),
                                         topHitPointsOffsets: (5, 5),
                                         bottomHitPointsOffsets: (5, 5))
        entity.addComponent(collider)
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        entity.addComponent(colliderTileHolderComponent)
        
        let ground = ColliderTileRepresentation(tile: .ground, userData: nil)
        let tileRepresentations = [[ground], [ground]]
        
        let mapRepresentation = CollisionTileMapRepresentation(tileRepresentations: tileRepresentations, tileSize: testsTileSize)
        let collisionsController = CollisionsController(tileMapRepresentation: mapRepresentation)
        
        var contacts = [ContactContext]()
        
        let proposedPosition = collisionsController.resolvedProposedPosition(for: entity,
                                                                             to: CGPoint(x: 0, y: 24),
                                                                             shouldLerp: true,
                                                                             snappables: [],
                                                                             contacts: &contacts)
        XCTAssertTrue(proposedPosition == CGPoint(x: 0, y: 26))
    }
    
    func testCollisionsControllerFindsAndResolvesContactsWithEnvironment() {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        let collider = ColliderComponent(categoryMask: TestCategoryMask.test,
                                         size: CGSize(width: 20, height: 20),
                                         offset: .zero,
                                         leftHitPointsOffsets: (5, 5),
                                         rightHitPointsOffsets: (5, 5),
                                         topHitPointsOffsets: (5, 5),
                                         bottomHitPointsOffsets: (5, 5))
        entity.addComponent(collider)
        
        var contacts = [ContactContext]()
        
        collisionsController?.findContactsAndResolveCollisionsWithEnvironment([entity],
                                                                              contacts: &contacts)
        XCTAssertTrue(contacts.isEmpty)
    }
    
}
