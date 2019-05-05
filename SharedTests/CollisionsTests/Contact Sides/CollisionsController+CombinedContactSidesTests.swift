//
//  CollisionsController+CombinedContactSidesTests.swift
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

class CollisionsControllerCombinedContactSidesTests: XCTestCase {
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

    // 1.
    func testBottomAndLeftCombinedWhenLeftApproachesFromTopReturnsBottom() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 54, y: 62)
        let proposedPosition = CGPoint(x: 54, y: 54)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }

    // 2.
    func testBottomAndLeftCombinedWhenLeftApproachesFromRightReturnsBottomAndLeft() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 62, y: 62)
        let proposedPosition = CGPoint(x: 54, y: 54)
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

        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        let expected = [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height),
                        ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)]
        XCTAssertTrue(contactSides == expected)
    }

    // 3.
    func testBottomAndRightCombinedWhenRightApproachesFromTopReturnsBottom() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 26, y: 62)
        let proposedPosition = CGPoint(x: 26, y: 54)
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

        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }

    // 4.
    func testBottomAndRightCombinedWhenRightApproachesFromRightReturnsBottomAndRight() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 18, y: 62)
        let proposedPosition = CGPoint(x: 26, y: 54)
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

        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        let expected = [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height),
                        ContactContext.ContactSideAndOffset(contactSide: .right, offset: -intersection.width)]
        XCTAssertTrue(contactSides == expected)
    }
    
    // 5.
    func testTopAndLeftCombinedWhenLeftApproachesFromBottomReturnsTop() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 54, y: 18)
        let proposedPosition = CGPoint(x: 54, y: 26)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .top, offset: -intersection.height)])
    }
    
    // 6.
    func testTopAndLeftCombinedWhenLeftApproachesFromRightReturnsTopAndLeft() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 62, y: 18)
        let proposedPosition = CGPoint(x: 54, y: 26)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        let expected = [ContactContext.ContactSideAndOffset(contactSide: .top, offset: -intersection.height),
                        ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)]
        XCTAssertTrue(contactSides == expected)
    }
    
    // 7.
    func testTopAndRightCombinedWhenRightApproachesFromBottomReturnsTop() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 26, y: 16)
        let proposedPosition = CGPoint(x: 26, y: 26)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .top, offset: -intersection.height)])
    }
    
    // 8.
    func testTopAndRightCombinedWhenRightApproachesFromRightReturnsTopAndRight() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 16, y: 16)
        let proposedPosition = CGPoint(x: 26, y: 26)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        let expected = [ContactContext.ContactSideAndOffset(contactSide: .top, offset: -intersection.height),
                        ContactContext.ContactSideAndOffset(contactSide: .right, offset: -intersection.width)]
        XCTAssertTrue(contactSides == expected)
    }
    
    // 9.
    func testTopAndBothLeftHitPointsCombinedWhenLeftApproachesFromBottomReturnsTop() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 54, y: 18)
        let proposedPosition = CGPoint(x: 54, y: 37)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .top, offset: -intersection.height)])
    }
    
    // 10.
    func testLeftAndBothTopHitPointsCombinedWhenTopApproachesFromRightReturnsTop() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 64, y: 26)
        let proposedPosition = CGPoint(x: 44, y: 26)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .left, offset: intersection.width)])
    }
    
    // 11.
    func testBottomAndBothLeftHitPointsCombinedWhenLeftApproachesFromTopReturnsBottom() {
        let colliderSize = CGSize(width: 20, height: 20)
        let currentPosition = CGPoint(x: 54, y: 63)
        let proposedPosition = CGPoint(x: 54, y: 45)
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
        
        let contactSides = collisionsController?.contactSides(for: colliderComponent,
                                                              currentPosition: currentPosition,
                                                              proposedPosition: proposedPosition,
                                                              currentHitPoints: currentHitPoints,
                                                              proposedHitPoints: proposedHitPoints,
                                                              intersection: intersection,
                                                              otherObjectFrame: otherObjectFrame,
                                                              proposedOtherObjectFrame: proposedOtherObjectFrame)
        XCTAssertTrue(contactSides == [ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: intersection.height)])
    }
}
