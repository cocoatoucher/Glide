//
//  CollisionsController+DefinedCollisionsTests.swift
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

class CollisionsControllerDefinedCollisionsTests: XCTestCase {
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
    
    // MARK: - Snappables
    func testCollisionsControllerReturnsContactIfColliderTouchesSnappable() {
        let sampleEntity = GlideEntity(initialNodePosition: CGPoint.zero)
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 0, y: 30), to: CGPoint(x: 0, y: 24))
        sampleEntity.addComponent(colliderMovement.collider)
        let snapperComponent = SnapperComponent()
        sampleEntity.addComponent(snapperComponent)
        
        let snappableEntity = MovingPlatformEntity(bottomLeftPosition: TiledPoint.zero,
                                                   colliderSize: TiledSize(3, 1).size(with: testsTileSize),
                                                   movementAxes: MovementAxes.horizontal,
                                                   changeDirectionProfiles: [],
                                                   providesOneWayCollision: false,
                                                   tileSize: testsTileSize)
        guard let snappable = snappableEntity.component(ofType: SnappableComponent.self) else {
            XCTFail("Snappable entity should have a snappable component")
            return
        }
        
        var nonCollisionContacts: [ContactContext] = []
        let contact = collisionsController?.snappableContact(for: colliderMovement, snappables: [snappable], contacts: [], nonCollisionContacts: &nonCollisionContacts)
        XCTAssertNotNil(contact)
        XCTAssertTrue(nonCollisionContacts.isEmpty)
    }
    
    func testCollisionsControllerMarksColliderOnCornerJumpIfColliderTouchesSnappableCornerJumpArea() {
        let sampleEntity = GlideEntity(initialNodePosition: CGPoint.zero)
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 35, y: 26), to: CGPoint(x: 58, y: 24))
        colliderMovement.collider.wasOnGround = true
        sampleEntity.addComponent(colliderMovement.collider)
        let snapperComponent = SnapperComponent()
        sampleEntity.addComponent(snapperComponent)
        
        let snappableEntity = MovingPlatformEntity(bottomLeftPosition: TiledPoint.zero,
                                                   colliderSize: TiledSize(3, 1).size(with: testsTileSize),
                                                   movementAxes: MovementAxes.horizontal,
                                                   changeDirectionProfiles: [],
                                                   providesOneWayCollision: false,
                                                   tileSize: testsTileSize)
        guard let snappable = snappableEntity.component(ofType: SnappableComponent.self) else {
            XCTFail("Snappable entity should have a snappable component")
            return
        }
        
        var nonCollisionContacts: [ContactContext] = []
        let contact = collisionsController?.snappableContact(for: colliderMovement, snappables: [snappable], contacts: [], nonCollisionContacts: &nonCollisionContacts)
        XCTAssertNil(contact)
        XCTAssertTrue(colliderMovement.collider.onCornerJump)
    }
    
    func testCollisionsControllerReturnsContactAfterCollidersContactsSnappable() {
        let sampleEntity = GlideEntity(initialNodePosition: CGPoint.zero)
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 0, y: 30), to: CGPoint(x: 0, y: 24))
        sampleEntity.addComponent(colliderMovement.collider)
        let snapperComponent = SnapperComponent()
        sampleEntity.addComponent(snapperComponent)
        
        let snappableEntity = MovingPlatformEntity(bottomLeftPosition: TiledPoint.zero,
                                                   colliderSize: TiledSize(3, 1).size(with: testsTileSize),
                                                   movementAxes: MovementAxes.horizontal,
                                                   changeDirectionProfiles: [],
                                                   providesOneWayCollision: false,
                                                   tileSize: testsTileSize)
        guard let snappable = snappableEntity.component(ofType: SnappableComponent.self) else {
            XCTFail("Snappable entity should have a snappable component")
            return
        }
        guard let snappableCollider = snappableEntity.component(ofType: ColliderComponent.self) else {
            XCTFail("Snappable entity should have a collider component")
            return
        }
        
        let contact = collisionsController?.contact(for: colliderMovement, with: snappable, snappableCollider: snappableCollider)
        XCTAssertNotNil(contact)
        XCTAssertTrue(contact?.isCollision ?? false)
    }
    
    func testCollisionsControllerReturnsContactAfterColliderContactsOnewaySnappable() {
        let sampleEntity = GlideEntity(initialNodePosition: CGPoint.zero)
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: 0, y: 30), to: CGPoint(x: 0, y: 24))
        sampleEntity.addComponent(colliderMovement.collider)
        let snapperComponent = SnapperComponent()
        sampleEntity.addComponent(snapperComponent)
        
        let snappableEntity = MovingPlatformEntity(bottomLeftPosition: TiledPoint.zero,
                                                   colliderSize: TiledSize(3, 1).size(with: testsTileSize),
                                                   movementAxes: MovementAxes.horizontal,
                                                   changeDirectionProfiles: [],
                                                   providesOneWayCollision: true,
                                                   tileSize: testsTileSize)
        guard let snappable = snappableEntity.component(ofType: SnappableComponent.self) else {
            XCTFail("Snappable entity should have a snappable component")
            return
        }
        guard let snappableCollider = snappableEntity.component(ofType: ColliderComponent.self) else {
            XCTFail("Snappable entity should have a collider component")
            return
        }
        
        let contact = collisionsController?.contact(for: colliderMovement, with: snappable, snappableCollider: snappableCollider)
        XCTAssertNotNil(contact)
        XCTAssertTrue(contact?.isCollision ?? false)
    }
    
    // MARK: - Other entities
    func testCollisionsControllerReturnsContactIfColliderContactsWithOtherEntity() {
        let colliderMovement = CollisionsControllerTestsHelper.colliderMovement(from: CGPoint(x: -10, y: -10), to: CGPoint(x: 0, y: 0))
        
        let otherColliderSize = CGSize(width: 20, height: 20)
        let otherEntity = GlideEntity(initialNodePosition: CGPoint.zero, positionOffset: CGPoint(x: (otherColliderSize / 2).width, y: (otherColliderSize / 2).height))
        let otherCollider = ColliderComponent(categoryMask: TestCategoryMask.test,
                                              size: otherColliderSize,
                                              offset: .zero,
                                              leftHitPointsOffsets: (5, 5),
                                              rightHitPointsOffsets: (5, 5),
                                              topHitPointsOffsets: (5, 5),
                                              bottomHitPointsOffsets: (5, 5))
        let contact = collisionsController?.contact(for: colliderMovement,
                                                    with: otherEntity,
                                                    otherCollider: otherCollider)
        XCTAssertNotNil(contact)
    }
    
    func testCollisionsControllerReturnsContactIfTwoEntitiesTouchEachOther() {
        
        let scene = GlideScene(collisionTileMapNode: SKTileMapNode(), zPositionContainers: [])
        
        let entity1 = GlideEntity(initialNodePosition: CGPoint.zero)
        let collider1 = ColliderComponent(categoryMask: TestCategoryMask.testObject1,
                                          size: CGSize(width: 20, height: 20),
                                          offset: .zero,
                                          leftHitPointsOffsets: (5, 5),
                                          rightHitPointsOffsets: (5, 5),
                                          topHitPointsOffsets: (5, 5),
                                          bottomHitPointsOffsets: (5, 5))
        entity1.addComponent(collider1)
        scene.addEntity(entity1)
        
        let entity2 = GlideEntity(initialNodePosition: CGPoint.zero)
        let collider2 = ColliderComponent(categoryMask: TestCategoryMask.testObject2,
                                          size: CGSize(width: 20, height: 20),
                                          offset: .zero,
                                          leftHitPointsOffsets: (5, 5),
                                          rightHitPointsOffsets: (5, 5),
                                          topHitPointsOffsets: (5, 5),
                                          bottomHitPointsOffsets: (5, 5))
        entity2.addComponent(collider2)
        
        scene.mapContact(between: TestCategoryMask.testObject1, and: TestCategoryMask.testObject2)
        
        var contacts: [ContactContext] = []
        collisionsController?.findContactsBetween(entities: [entity1, entity2], contacts: &contacts)
        XCTAssertFalse(contacts.isEmpty)
    }
}
