//
//  CollisionsController+BottomContactSides.swift
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

class CollisionsControllerBottomContactSidesTests: XCTestCase {
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

    // 1. Bottom left from top approach
    //
    func testContactSidesWhenColliderApproachesWithBottomLeftFromTopShouldReturnBottomSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 27, y: 62)
        let proposedPosition = CGPoint(x: 27, y: 58)
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

        let contactSides = collisionsController?.bottomContactSides(intersection: intersection,
                                                                    wasOnSlope: false,
                                                                    hitPointsOffsets: colliderComponent.bottomHitPointsOffsets,
                                                                    currentHitPoints: currentHitPoints,
                                                                    proposedHitPoints: proposedHitPoints,
                                                                    otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }

    // 2. Bottom left from right approach
    //
    func testContactSidesWhenColliderApproachesWithBottomLeftFromRightShouldReturnLeftSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 62, y: 56)
        let proposedPosition = CGPoint(x: 53, y: 56)
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

        let contactSides = collisionsController?.bottomContactSides(intersection: intersection,
                                                                    wasOnSlope: false,
                                                                    hitPointsOffsets: colliderComponent.bottomHitPointsOffsets,
                                                                    currentHitPoints: currentHitPoints,
                                                                    proposedHitPoints: proposedHitPoints,
                                                                    otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width - colliderComponent.bottomHitPointsOffsets.left)])
    }

    // 3. Bottom right from top approach
    //
    func testContactSidesWhenColliderApproachesWithBottomRightFromTopShouldReturnBottomSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 28, y: 64)
        let proposedPosition = CGPoint(x: 28, y: 57)
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

        let contactSides = collisionsController?.bottomContactSides(intersection: intersection,
                                                                    wasOnSlope: false,
                                                                    hitPointsOffsets: colliderComponent.bottomHitPointsOffsets,
                                                                    currentHitPoints: currentHitPoints,
                                                                    proposedHitPoints: proposedHitPoints,
                                                                    otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }

    // 4. Bottom right from left approach
    //
    func testContactSidesWhenColliderApproachesWithBottomRightFromLeftShouldReturnRightSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 19, y: 58)
        let proposedPosition = CGPoint(x: 27, y: 58)
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

        let contactSides = collisionsController?.bottomContactSides(intersection: intersection,
                                                                    wasOnSlope: false,
                                                                    hitPointsOffsets: colliderComponent.bottomHitPointsOffsets,
                                                                    currentHitPoints: currentHitPoints,
                                                                    proposedHitPoints: proposedHitPoints,
                                                                    otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .right, offset: -(intersection.width - colliderComponent.bottomHitPointsOffsets.right))])
    }
    
    // 5. Bottom left from right approach after being on slope
    //
    func testContactSidesWhenColliderApproachesWithBottomLeftFromRightAfterBeingOnSlopeShouldReturnBottomSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 62, y: 56)
        let proposedPosition = CGPoint(x: 53, y: 56)
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
        
        let contactSides = collisionsController?.bottomContactSides(intersection: intersection,
                                                                    wasOnSlope: true,
                                                                    hitPointsOffsets: colliderComponent.bottomHitPointsOffsets,
                                                                    currentHitPoints: currentHitPoints,
                                                                    proposedHitPoints: proposedHitPoints,
                                                                    otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }
    
    // 6. Bottom right from left approach after being on slope
    //
    func testContactSidesWhenColliderApproachesWithBottomRightFromLeftAfterBeingOnSlopeShouldReturnBottomSideContact() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 19, y: 58)
        let proposedPosition = CGPoint(x: 27, y: 58)
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
        
        let contactSides = collisionsController?.bottomContactSides(intersection: intersection,
                                                                    wasOnSlope: true,
                                                                    hitPointsOffsets: colliderComponent.bottomHitPointsOffsets,
                                                                    currentHitPoints: currentHitPoints,
                                                                    proposedHitPoints: proposedHitPoints,
                                                                    otherObjectFrame: otherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }
}
