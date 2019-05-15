//
//  CollisionsController+GroundCollisions.swift
//  glide
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
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

import CoreGraphics

extension CollisionsController {
    
    func groundContact(for colliderMovement: ColliderMovement,
                       tileMapRepresentation: CollisionTileMapRepresentation,
                       contacts: [ContactContext],
                       nonCollisionContacts: inout [ContactContext]) -> ContactContext? {
        let collider = colliderMovement.collider
        
        let shouldCollideGround = collider.entity?.component(ofType: ColliderTileHolderComponent.self) != nil
        let shouldContactTestGround = collider.shouldContactTest(otherCategoryMask: GlideCategoryMask.colliderTile)
        var shouldTestContactWithGround: Bool = shouldContactTestGround
        for contact in contacts {
            if case .colliderTile = contact.otherObject {
                shouldTestContactWithGround = false
            }
        }
        
        guard shouldCollideGround || shouldTestContactWithGround else {
            return nil
        }
        
        let allTileIntersections = self.tileIntersections(for: colliderMovement,
                                                          tileMapRepresentation: tileMapRepresentation)
        let tileIntersections = allTileIntersections.filter { $0.tileRepresentation != nil }
        let emptyTileIntersections = allTileIntersections.filter { $0.tileRepresentation == nil }
        
        if let contact = colliderTileContacts(for: colliderMovement,
                                              tileMapRepresentation: tileMapRepresentation,
                                              tileIntersections: tileIntersections,
                                              shouldCollideGround: shouldCollideGround,
                                              nonCollisionContacts: &nonCollisionContacts) {
            if contact.isCollision {
                return contact
            } else {
                nonCollisionContacts.append(contact)
            }
        }
        
        emptyTilesContact(for: colliderMovement,
                          tileMapRepresentation: tileMapRepresentation,
                          emptyTileIntersections: emptyTileIntersections,
                          nonCollisionContacts: &nonCollisionContacts)
        
        return nil
    }
    
    func colliderTileContacts(for colliderMovement: ColliderMovement,
                              tileMapRepresentation: CollisionTileMapRepresentation,
                              tileIntersections: [ColliderTileIntersection],
                              shouldCollideGround: Bool,
                              nonCollisionContacts: inout [ContactContext]) -> ContactContext? {
        for tileIntersection in tileIntersections {
            guard let tileRepresentation = tileIntersection.tileRepresentation else {
                continue
            }
            let tileContact = colliderTileContact(for: colliderMovement,
                                                  tileMapRepresentation: tileMapRepresentation,
                                                  shouldCollideGround: shouldCollideGround,
                                                  colliderTile: tileRepresentation.tile,
                                                  tileIntersection: tileIntersection,
                                                  nonCollisionContacts: &nonCollisionContacts)
            if let contact = tileContact {
                return contact
            }
        }
        
        return nil
    }
    
    func colliderTileContact(for colliderMovement: ColliderMovement,
                             tileMapRepresentation: CollisionTileMapRepresentation,
                             shouldCollideGround: Bool,
                             colliderTile: ColliderTile,
                             tileIntersection: ColliderTileIntersection,
                             nonCollisionContacts: inout [ContactContext]) -> ContactContext? {
        
        switch colliderTile {
        case .ground, .oneWay:
            if let contact = basicGroundAndOnewayTileContact(colliderMovement: colliderMovement,
                                                             tileMapRepresentation: tileMapRepresentation,
                                                             shouldCollideGround: shouldCollideGround,
                                                             tileIntersection: tileIntersection) {
                if contact.isCollision {
                    return contact
                } else {
                    nonCollisionContacts.append(contact)
                }
            }
        case .jumpWallRight, .jumpWallLeft:
            guard colliderMovement.collider.entity?.component(ofType: WallJumpComponent.self) != nil else {
                return nil
            }
            var isJumpWallLeft = false
            if colliderTile == .jumpWallLeft { isJumpWallLeft = true }
            handleJumpWallTileContact(colliderMovement: colliderMovement,
                                      isJumpWallLeft: isJumpWallLeft,
                                      shouldCollideGround: shouldCollideGround,
                                      tileIntersection: tileIntersection)
        case .slope:
            let kinematicsBody = colliderMovement.collider.entity?.component(ofType: KinematicsBodyComponent.self)
            let verticalVelocity = kinematicsBody?.velocity.dy ?? 0
            guard let slopeContext = tileMapRepresentation.slopeContext(at: tileIntersection.coordinates) else {
                return nil
            }
            if let contact = slopeTileContact(colliderMovement: colliderMovement,
                                              shouldCollideGround: shouldCollideGround,
                                              tileIntersection: tileIntersection,
                                              slopeContext: slopeContext,
                                              verticalVelocity: verticalVelocity) {
                if contact.isCollision {
                    return contact
                } else {
                    nonCollisionContacts.append(contact)
                }
            }
        }
        
        return nil
    }
    
    func basicGroundAndOnewayTileContact(colliderMovement: ColliderMovement,
                                         tileMapRepresentation: CollisionTileMapRepresentation,
                                         shouldCollideGround: Bool,
                                         tileIntersection: ColliderTileIntersection) -> ContactContext? {
        let intersection = tileIntersection.intersection
        let tileFrame = tileIntersection.tileFrame
        guard let colliderTile = tileIntersection.tileRepresentation?.tile else {
            return nil
        }
        
        let contact = contactBetweenObjects(colliderMovement: colliderMovement,
                                            intersection: intersection,
                                            otherObject: .colliderTile(isEmptyTile: false),
                                            otherObjectFrame: tileFrame,
                                            proposedOtherObjectFrame: tileFrame,
                                            shouldCollide: shouldCollideGround)
        if let contact = contact, contact.isUnspecified == false {
            if colliderTile == .oneWay {
                if contact.colliderContactSides.contains(.bottom) {
                    if colliderMovement.collider.didPushDown {
                        return nil
                    }
                    return contact
                }
            } else {
                return contact
            }
        }
        return nil
    }
    
    func handleJumpWallTileContact(colliderMovement: ColliderMovement,
                                   isJumpWallLeft: Bool,
                                   shouldCollideGround: Bool,
                                   tileIntersection: ColliderTileIntersection) {
        let collider = colliderMovement.collider
        let tileFrame = tileIntersection.tileFrame
        let intersection = tileIntersection.intersection
        
        guard shouldCollideGround && collider.onGround == false else {
            return
        }
        
        if isJumpWallLeft {
            let leftSide = CGRect(x: tileFrame.origin.x,
                                  y: tileFrame.origin.y,
                                  width: 1,
                                  height: tileFrame.size.height)
            if intersection.intersects(leftSide) {
                collider.pushesLeftJumpWall = true
            }
        } else {
            let rightSide = CGRect(x: tileFrame.origin.x + tileFrame.size.width - 1,
                                   y: tileFrame.origin.y, width: 1, height: tileFrame.size.height)
            if intersection.intersects(rightSide) {
                collider.pushesRightJumpWall = true
            }
        }
    }
    
    // swiftlint:disable:next function_body_length
    func slopeTileContact(colliderMovement: ColliderMovement,
                          shouldCollideGround: Bool,
                          tileIntersection: ColliderTileIntersection,
                          slopeContext: SlopeContext,
                          verticalVelocity: CGFloat) -> ContactContext? {
        let collider = colliderMovement.collider
        let proposedHitPoints = colliderMovement.proposedHitPoints
        
        let intersection = tileIntersection.intersection
        let tileFrame = tileIntersection.tileFrame
        
        guard let colliderTile = tileIntersection.tileRepresentation?.tile else {
            return nil
        }
        
        guard shouldCollideGround else {
            return contactBetweenObjects(colliderMovement: colliderMovement,
                                         intersection: intersection,
                                         otherObject: .colliderTile(isEmptyTile: false),
                                         otherObjectFrame: tileFrame,
                                         proposedOtherObjectFrame: tileFrame,
                                         shouldCollide: false)
        }
        guard collider.onSlope == false else {
            return nil
        }
        
        let leftValue = colliderTile.slopeLeftValue
        let rightValue = colliderTile.slopeRightValue
        
        var intersectTestCorner: CGRect
        if leftValue > rightValue {
            intersectTestCorner = proposedHitPoints.bottom.right
        } else {
            intersectTestCorner = proposedHitPoints.bottom.left
        }
        
        guard intersection.intersects(intersectTestCorner) else {
            return nil
        }
        
        let bottomCornerIntersection = tileFrame.intersection(intersectTestCorner).origin
        let bottomCornerIntersectionLocalX = floor(bottomCornerIntersection.x) - tileFrame.origin.x
        let bottomCornerIntersectionLocalY = floor(bottomCornerIntersection.y) - tileFrame.origin.y
        let bitmapIntersection = TiledPoint(x: Int(bottomCornerIntersectionLocalX),
                                            y: Int(bottomCornerIntersectionLocalY))
        
        let slopeValue = (left: leftValue, right: rightValue)
        let contactOffset: CGFloat = SlopeBitmap.slopeContactOffset(for: bitmapIntersection, slopeValue: slopeValue)
        
        guard contactOffset >= 0 || (contactOffset < 0 && verticalVelocity <= 0) else {
            return nil
        }
        
        collider.onSlope = true
        collider.slopeContext = slopeContext
        
        var modifiedProposedPosition = colliderMovement.proposedPosition
        modifiedProposedPosition.y += contactOffset
        
        return ContactContext(collider: collider,
                              otherObject: .slope(slopeContext),
                              isCollision: true,
                              colliderContactSides: [ContactSide.bottom],
                              colliderIntersection: .zero,
                              otherObjectContactSides: [],
                              otherObjectIntersection: .zero,
                              proposedPosition: modifiedProposedPosition)
    }
    
    func emptyTilesContact(for colliderMovement: ColliderMovement,
                           tileMapRepresentation: CollisionTileMapRepresentation,
                           emptyTileIntersections: [ColliderTileIntersection],
                           nonCollisionContacts: inout [ContactContext]) {
        let collider = colliderMovement.collider
        let proposedHitPoints = colliderMovement.proposedHitPoints
        let proposedObjectFrame = colliderMovement.proposedObjectFrame
        
        for emptyTileIntersection in emptyTileIntersections {
            guard emptyTileIntersection.tileRepresentation == nil else {
                continue
            }
            
            let tileFrame = emptyTileIntersection.tileFrame
            let intersection = emptyTileIntersection.intersection
            let column = emptyTileIntersection.coordinates.x
            let row = emptyTileIntersection.coordinates.y
            
            let contact = contactBetweenObjects(colliderMovement: colliderMovement,
                                                intersection: intersection,
                                                otherObject: .colliderTile(isEmptyTile: true),
                                                otherObjectFrame: tileFrame,
                                                proposedOtherObjectFrame: tileFrame,
                                                shouldCollide: false)
            if let contact = contact, contact.isUnspecified == false {
                if tileMapRepresentation.cornerJumps.contains(TiledPoint(column, row)) {
                    guard collider.onCornerJump == false && collider.discardsCornerJump == false else {
                        continue
                    }
                    
                    if collider.wasOnCornerJump {
                        collider.onCornerJump = true
                    } else if
                        (intersection.intersects(proposedHitPoints.bottom.left) ||
                            intersection.intersects(proposedHitPoints.bottom.right)) &&
                            collider.wasOnGround == true {
                        collider.onCornerJump = true
                    } else {
                        collider.discardsCornerJump = true
                    }
                }
                
                let contactsGap = doesContactGap(on: TiledPoint(column, row),
                                                 tileMapRepresentation: tileMapRepresentation,
                                                 proposedObjectFrame: proposedObjectFrame)
                if contactsGap {
                    if collider.onGap {
                        continue
                    }
                    
                    collider.onGap = true
                    nonCollisionContacts.append(contact)
                }
            }
        }
    }
    
    func doesContactGap(on tiledPoint: TiledPoint,
                        tileMapRepresentation: CollisionTileMapRepresentation,
                        proposedObjectFrame: CGRect) -> Bool {
        guard let gaps = tileMapRepresentation.columnsToGaps[tiledPoint.x] else {
            return false
        }
        for gap in gaps {
            guard tiledPoint.y >= gap.0 && tiledPoint.y <= gap.1 else {
                continue
            }
            
            let gapBeginTileFrame = CGRect(x: CGFloat(tiledPoint.x) * tileMapRepresentation.tileSize.width,
                                           y: CGFloat(gap.0) * tileMapRepresentation.tileSize.height,
                                           width: tileMapRepresentation.tileSize.width,
                                           height: tileMapRepresentation.tileSize.height)
            if gapBeginTileFrame.minY < proposedObjectFrame.minY {
                return true
            }
        }
        return false
    }
    
    func tileIntersections(for colliderMovement: ColliderMovement,
                           tileMapRepresentation: CollisionTileMapRepresentation) -> [ColliderTileIntersection] {
        let tileRange = tileMapRepresentation.tileRangeAroundFrame(colliderMovement.proposedObjectFrame)
        
        var result = [ColliderTileIntersection]()
        
        for column in tileRange.left ... tileRange.right {
            for row in tileRange.bottom ... tileRange.top {
                let tileFrame = CGRect(x: CGFloat(column) * tileMapRepresentation.tileSize.width,
                                       y: CGFloat(row) * tileMapRepresentation.tileSize.height,
                                       width: tileMapRepresentation.tileSize.width,
                                       height: tileMapRepresentation.tileSize.height)
                
                let intersection = tileFrame.intersection(colliderMovement.proposedObjectFrame)
                
                guard intersection.size.height > 0 && intersection.size.width > 0 else {
                    continue
                }
                
                guard let tileRepresentation = tileMapRepresentation.tileRepresentationAt(column: column, row: row) else {
                    let emptyTileIntersection = ColliderTileIntersection(tileRepresentation: nil,
                                                                         coordinates: TiledPoint(x: column, y: row),
                                                                         tileFrame: tileFrame,
                                                                         intersection: intersection)
                    result.append(emptyTileIntersection)
                    continue
                }
                
                let intersectingTile = ColliderTileIntersection(tileRepresentation: tileRepresentation,
                                                                coordinates: TiledPoint(x: column, y: row),
                                                                tileFrame: tileFrame,
                                                                intersection: intersection)
                result.append(intersectingTile)
            }
        }
        
        result.sort { (tileA, tileB) -> Bool in
            let distanceA = colliderMovement.currentPosition.distanceTo(tileA.tileFrame.origin + (tileA.tileFrame.size / 2.0))
            let distanceB = colliderMovement.currentPosition.distanceTo(tileB.tileFrame.origin + (tileB.tileFrame.size / 2.0))
            return distanceA < distanceB
        }
        
        return result
    }
}
