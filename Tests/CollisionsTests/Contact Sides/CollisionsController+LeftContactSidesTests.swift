//
//  CollisionsController+LeftContactSidesTests.swift
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

class CollisionsControllerLeftContactSidesTests: XCTestCase {
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

    // 1. Left top from right approach
    //
    func testContactSidesWhenColliderApproachesWithLeftTopFromRightShouldReturnLeftSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 63, y: 26)
        let proposedPosition = CGPoint(x: 58, y: 26)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)

        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))

        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherObjectFrame)

        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)

        let contactSides = collisionsController?.leftContactSides(intersection: intersection,
                                                                  hitPointsOffsets: colliderComponent.leftHitPointsOffsets,
                                                                  currentHitPoints: currentHitPoints,
                                                                  proposedHitPoints: proposedHitPoints,
                                                                  colliderContactsBottom: false,
                                                                  otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)])
    }

    // 2. Left top from bottom approach
    //
    func testContactSidesWhenColliderApproachesWithLeftTopFromBottomShouldReturnTopSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 58, y: 16)
        let proposedPosition = CGPoint(x: 58, y: 26)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)

        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))

        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherObjectFrame)

        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)

        let contactSides = collisionsController?.leftContactSides(intersection: intersection,
                                                                  hitPointsOffsets: colliderComponent.leftHitPointsOffsets,
                                                                  currentHitPoints: currentHitPoints,
                                                                  proposedHitPoints: proposedHitPoints,
                                                                  colliderContactsBottom: false,
                                                                  otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .top, offset: -(intersection.height - colliderComponent.leftHitPointsOffsets.top))])
    }

    // 3. Left bottom from right approach
    //
    func testContactSidesWhenColliderApproachesWithLeftBottomFromRightShouldReturnLeftSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 64, y: 54)
        let proposedPosition = CGPoint(x: 58, y: 54)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)

        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))

        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherObjectFrame)

        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)

        let contactSides = collisionsController?.leftContactSides(intersection: intersection,
                                                                  hitPointsOffsets: colliderComponent.leftHitPointsOffsets,
                                                                  currentHitPoints: currentHitPoints,
                                                                  proposedHitPoints: proposedHitPoints,
                                                                  colliderContactsBottom: false,
                                                                  otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)])
    }

    // 4. Left bottom from top approach
    //
    func testContactSidesWhenColliderApproachesWithLeftBottomFromTopShouldReturnLeftSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 58, y: 62)
        let proposedPosition = CGPoint(x: 58, y: 54)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)

        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))

        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherObjectFrame)

        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)

        let contactSides = collisionsController?.leftContactSides(intersection: intersection,
                                                                  hitPointsOffsets: colliderComponent.leftHitPointsOffsets,
                                                                  currentHitPoints: currentHitPoints,
                                                                  proposedHitPoints: proposedHitPoints,
                                                                  colliderContactsBottom: false,
                                                                  otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)])
    }

    // 5. Left bottom from top approach & collider already contacts bottom
    //
    func testContactSidesWhenColliderApproachesWithLeftBottomFromTopIfColliderContactsBottomShouldReturnNoContactSides() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 58, y: 62)
        let proposedPosition = CGPoint(x: 58, y: 54)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)

        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))

        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherObjectFrame)

        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)

        let contactSides = collisionsController?.rightContactSides(intersection: intersection,
                                                                   hitPointsOffsets: colliderComponent.leftHitPointsOffsets,
                                                                   currentHitPoints: currentHitPoints,
                                                                   proposedHitPoints: proposedHitPoints,
                                                                   colliderContactsBottom: true,
                                                                   otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides?.isEmpty ?? false)
    }

    // 6. Full left approach
    //
    func testContactSidesWhenColliderApproachesWithBothLeftHitPointsShouldReturnTwoLeftContactSides() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 62, y: 40)
        let proposedPosition = CGPoint(x: 58, y: 40)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)

        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))

        let otherObjectFrame = CGRect(x: 30, y: 30, width: 20, height: 20)
        let proposedOtherObjectFrame = otherObjectFrame
        let intersection = proposedObjectFrame.intersection(proposedOtherObjectFrame)

        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)

        let contactSides = collisionsController?.leftContactSides(intersection: intersection,
                                                                  hitPointsOffsets: colliderComponent.leftHitPointsOffsets,
                                                                  currentHitPoints: currentHitPoints,
                                                                  proposedHitPoints: proposedHitPoints,
                                                                  colliderContactsBottom: false,
                                                                  otherObjectFrame: otherObjectFrame)
        let expected = [ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width),
                        ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)]
        XCTAssertTrue(contactSides == expected)
    }
}
