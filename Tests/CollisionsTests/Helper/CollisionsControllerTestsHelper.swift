//
//  CollisionsControllerTestsHelper.swift
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

enum TestCategoryMask: UInt32, CategoryMask {
    case test = 0xa
    case testObject1 = 0xb
    case testObject2 = 0xc
}

let testsTileSize = CGSize(width: 16, height: 16)

class CollisionsControllerTestsHelper {
    static func colliderMovement(from currentPosition: CGPoint, to proposedPosition: CGPoint) -> CollisionsController.ColliderMovement {
        let colliderSize = CGSize(width: 20, height: 20)
        let proposedObjectFrame = proposedPosition.centeredFrame(withSize: colliderSize)
        
        let colliderComponent = ColliderComponent(categoryMask: TestCategoryMask.test,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
        
        let currentHitPoints = colliderComponent.hitPoints(at: currentPosition)
        let proposedHitPoints = colliderComponent.hitPoints(at: proposedPosition)
        let colliderMovement = CollisionsController.ColliderMovement(collider: colliderComponent,
                                                                     proposedPosition: proposedPosition,
                                                                     proposedObjectFrame: proposedObjectFrame,
                                                                     proposedHitPoints: proposedHitPoints,
                                                                     currentPosition: currentPosition,
                                                                     currentHitPoints: currentHitPoints)
        return colliderMovement
    }
}
