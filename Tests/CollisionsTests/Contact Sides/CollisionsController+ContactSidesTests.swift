//
//  CollisionsController+ContactSidesTests.swift
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

class CollisionsControllerContactSidesTests: XCTestCase {
    
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
    
    func testContactSideWithMaxOffsetShouldReturnTheContactSideWithMaximumOffset() {
        let contactSidesAndOffsets = [ContactContext.ContactSideAndOffset(contactSide: .top, offset: 3), ContactContext.ContactSideAndOffset(contactSide: .top, offset: 5)]
        
        let result = collisionsController?.contactSideWithMaxOffset(on: .top, within: contactSidesAndOffsets)
        
        XCTAssertTrue(result?.offset == 5)
    }
    
    func testFilteredContactSidesAndOffsetsShouldReturnUniqueContactSides() {
        let contactSidesAndOffsets =
            [ContactContext.ContactSideAndOffset(contactSide: .top, offset: 3),
             ContactContext.ContactSideAndOffset(contactSide: .top, offset: 5),
             ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: 5)]
        
        let result = collisionsController?.filteredContactSidesAndOffsets(from: contactSidesAndOffsets)
        
        let expected = [ContactContext.ContactSideAndOffset(contactSide: .top, offset: 5),
                        ContactContext.ContactSideAndOffset(contactSide: .bottom, offset: 5)]
        
        XCTAssertTrue(result == expected)
    }
}
